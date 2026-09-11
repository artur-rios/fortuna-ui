/// Exporting a data set (UC-39).
///
/// `FR-EX-02` is the rule the whole file serves: **the API produces every
/// export and this client renders none.** Nothing here writes a CSV row,
/// lays out a PDF, or builds a spreadsheet. What this does is state what the
/// export should cover, ask for it, and hand the bytes the instance produced
/// to the platform's own file saving.
///
/// That is not a division of labour for tidiness. An export rendered here
/// would be a second implementation of what a figure means — a total this
/// client computed, a currency it converted — and the file the user filed
/// away would then disagree with the screen they exported it from.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// The formats an export can be produced in (`FR-EX-01`).
enum ExportFormat {
  csv('csv', 'CSV', 'text/csv'),
  excel('excel', 'Excel', 'application/vnd.ms-excel'),
  pdf('pdf', 'PDF', 'application/pdf');

  const ExportFormat(this.wireName, this.label, this.contentType);

  final String wireName;
  final String label;
  final String contentType;
}

/// Where an export is in its life.
enum ExportState {
  pending(1),
  running(2),
  completed(3),
  failed(4),

  /// A state this build does not recognize. Shown as unknown rather than
  /// guessed at, since guessing "completed" would offer a file that may not
  /// exist.
  unknown(0);

  const ExportState(this.wire);

  final int wire;

  static ExportState from(DataExportStatus? status) => switch (status?.json) {
    1 => ExportState.pending,
    2 => ExportState.running,
    3 => ExportState.completed,
    4 => ExportState.failed,
    _ => ExportState.unknown,
  };

  bool get isFinished =>
      this == ExportState.completed || this == ExportState.failed;
}

/// One filter the export will apply, named as the user will read it.
///
/// Carried as a pair so step 2 can state what the export covers in words
/// before anything is produced — an export whose scope the user did not see
/// is one they cannot check.
@immutable
class ExportFilter {
  const ExportFilter({
    required this.field,
    required this.operator,
    required this.value,
    required this.description,
  });

  final String field;
  final String operator;
  final String value;

  /// What the user is told this filter does.
  final String description;
}

/// A file the instance produced.
@immutable
class ExportedFile {
  const ExportedFile({
    required this.bytes,
    required this.fileName,
    required this.contentType,
  });

  final Uint8List bytes;
  final String fileName;
  final String contentType;

  int get sizeBytes => bytes.length;
}

/// An export the instance is producing or has produced.
@immutable
class DataExport {
  const DataExport({
    required this.id,
    required this.state,
    required this.format,
    this.fileName,
    this.rowCount,
    this.failureReason,
    this.expiresAt,
  });

  final String id;
  final ExportState state;
  final ExportFormat format;
  final String? fileName;
  final int? rowCount;

  /// `AF-02`: the API's own reason, where it failed.
  final String? failureReason;

  final DateTime? expiresAt;

  bool get isReady => state == ExportState.completed;

  /// `AF-04`: produced, but no longer retrievable.
  ///
  /// [now] is passed rather than read from the clock so the rule is a pure
  /// function a test can pin.
  bool hasExpired({required DateTime now}) {
    final expiry = expiresAt;
    return expiry != null && now.isAfter(expiry);
  }
}

/// What asking for an export produced.
///
/// Two outcomes because the API has two deliveries: a small export comes back
/// as the file itself, a large one as a job to follow. `AF-05` needs the
/// second to be a value the interface can keep rather than a request it must
/// block on.
@immutable
sealed class ExportOutcome {
  const ExportOutcome();
}

/// The instance produced it there and then.
@immutable
final class ExportDelivered extends ExportOutcome {
  const ExportDelivered(this.file);

  final ExportedFile file;
}

/// The instance took it as a job (`FR-EX-04`, `AF-05`).
@immutable
final class ExportQueued extends ExportOutcome {
  const ExportQueued(this.export);

  final DataExport export;
}

abstract interface class ExportRepository {
  /// Asks the API to produce an export (`FR-EX-02`, `FR-EX-03`).
  Future<Result<ExportOutcome>> request({
    required String recordSet,
    required ExportFormat format,
    required List<ExportFilter> filters,
    String? displayCurrencyCode,
    String? locale,
  });

  /// Reads a queued export's progress.
  Future<Result<DataExport>> read(String exportId);

  /// Retrieves a completed export's file.
  Future<Result<ExportedFile>> download(DataExport export);
}

class HttpExportRepository implements ExportRepository {
  HttpExportRepository(this._client, this._dio);

  factory HttpExportRepository.fromDio(Dio dio) =>
      HttpExportRepository(ExportsClient(dio), dio);

  final ExportsClient _client;

  /// Used directly for the file itself: the generated client returns typed
  /// JSON, and these two responses are bytes. The same approach UC-43 takes
  /// for the personal archive, and for the same reason.
  final Dio _dio;

  @override
  Future<Result<ExportOutcome>> request({
    required String recordSet,
    required ExportFormat format,
    required List<ExportFilter> filters,
    String? displayCurrencyCode,
    String? locale,
  }) async {
    try {
      final response = await _dio.post<List<int>>(
        '/api/exports',
        data: RequestDataExportCommand(
          recordSet: recordSet,
          format: format.wireName,
          displayCurrencyCode: displayCurrencyCode,
          locale: locale,
          filters: [
            for (final filter in filters)
              DataExportFilterInput(
                field: filter.field,
                operatorValue: filter.operator,
                value: filter.value,
              ),
          ],
        ).toJson(),
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return const Failure(
          message: 'The instance produced nothing.',
          kind: FailureKind.serverError,
        );
      }

      // The same route answers two ways: a direct delivery is the file, a
      // queued one is a job described in JSON. The content type is what says
      // which, rather than a guess from the payload's shape.
      final contentType =
          response.headers.value('content-type')?.toLowerCase() ?? '';

      if (contentType.contains('application/json')) {
        return Success(ExportQueued(_queuedFrom(bytes, format)));
      }

      return Success(
        ExportDelivered(
          ExportedFile(
            bytes: Uint8List.fromList(bytes),
            fileName: _fileNameFrom(response) ?? 'export.${format.wireName}',
            contentType: contentType.isEmpty ? format.contentType : contentType,
          ),
        ),
      );
    } on DioException catch (exception) {
      // AF-02 and AF-06 both arrive here: a job the instance refused, and a
      // format it does not produce for this data set, each in its own words.
      return failureFromDioException<ExportOutcome>(exception);
    }
  }

  @override
  Future<Result<DataExport>> read(String exportId) async {
    try {
      final output = (await _client.getApiExportsId(id: exportId)).data;

      if (output == null) {
        return const Failure(
          message: 'That export was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(
        DataExport(
          id: output.id ?? exportId,
          state: ExportState.from(output.status),
          format: _formatFrom(output.format),
          fileName: output.fileName,
          rowCount: output.rowCount,
          failureReason: output.failureReason,
          expiresAt: output.expiresAt,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<DataExport>(exception);
    }
  }

  @override
  Future<Result<ExportedFile>> download(DataExport export) async {
    try {
      final response = await _dio.get<List<int>>(
        '/api/exports/${export.id}',
        options: Options(
          responseType: ResponseType.bytes,
          // The route serves the record as JSON and the file as bytes; this
          // is how the file is asked for.
          headers: const {'Accept': 'application/octet-stream'},
        ),
      );

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return const Failure(
          message: 'The export came back empty.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        ExportedFile(
          bytes: Uint8List.fromList(bytes),
          fileName: export.fileName ?? 'export.${export.format.wireName}',
          contentType:
              response.headers.value('content-type') ??
              export.format.contentType,
        ),
      );
    } on DioException catch (exception) {
      // AF-04 arrives here where the instance has already discarded it.
      return failureFromDioException<ExportedFile>(exception);
    }
  }

  static DataExport _queuedFrom(List<int> bytes, ExportFormat format) {
    // The queued answer is small JSON. Parsed only for the identifiers it
    // carries; nothing about the data itself is read from it.
    final decoded = _decodeJson(bytes);

    return DataExport(
      id: (decoded['exportId'] ?? decoded['jobId'] ?? '') as String,
      state: ExportState.pending,
      format: format,
      fileName: decoded['fileName'] as String?,
      rowCount: decoded['rowCount'] as int?,
    );
  }

  static Map<String, Object?> _decodeJson(List<int> bytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map<String, Object?>) {
        final data = decoded['data'];
        return data is Map<String, Object?> ? data : decoded;
      }
    } on Object {
      // A queued answer this client cannot read leaves an export with no
      // identifier, which the caller reports rather than pretending to track.
    }
    return const {};
  }

  static ExportFormat _formatFrom(DataExportFormat? format) =>
      switch (format?.json) {
        2 => ExportFormat.excel,
        3 => ExportFormat.pdf,
        _ => ExportFormat.csv,
      };

  static String? _fileNameFrom(Response<Object?> response) {
    final disposition = response.headers.value('content-disposition');
    if (disposition == null) return null;

    final match = RegExp('filename="?([^";]+)"?').firstMatch(disposition);
    return match?.group(1);
  }
}

final exportRepositoryProvider = Provider<ExportRepository>(
  (ref) => HttpExportRepository.fromDio(ref.watch(dioProvider)),
);

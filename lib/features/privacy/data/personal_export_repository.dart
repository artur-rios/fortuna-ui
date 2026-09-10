/// The complete personal-data export (UC-43).
///
/// Not the same thing as the ordinary export of `UC-39`. That one exports a
/// data set the user chose; this one is the portability right — everything the
/// system holds about them, whether or not they would have thought to ask for
/// it.
library;

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Where a personal export has got to.
enum PersonalExportStatus {
  pending,
  running,
  completed,
  failed,

  /// A status this build does not recognize. Shown as unknown rather than
  /// guessed at, since guessing "completed" would offer a download of nothing.
  unknown;

  /// Maps the API's status onto this one.
  ///
  /// Matched on the numeric value rather than the generated name. The contract
  /// does name these — `x-enum-varnames: [Pending, Running, Completed,
  /// Failed]` — but swagger_parser does not read that extension, so the
  /// generated enum is positional (`value1` … `value4`). Matching on the
  /// number is the honest reading of what the contract actually specifies, and
  /// it does not silently change meaning if the generator learns those names
  /// later.
  static PersonalExportStatus from(DataExportStatus? status) =>
      switch (status?.json) {
        1 => PersonalExportStatus.pending,
        2 => PersonalExportStatus.running,
        3 => PersonalExportStatus.completed,
        4 => PersonalExportStatus.failed,
        _ => PersonalExportStatus.unknown,
      };

  bool get isFinished =>
      this == PersonalExportStatus.completed ||
      this == PersonalExportStatus.failed;
}

/// A personal export job, as the API reports it.
@immutable
class PersonalExport {
  const PersonalExport({
    required this.jobId,
    required this.status,
    required this.progress,
    this.fileName,
    this.contentType,
    this.expiresAt,
    this.failureReason,
  });

  final String jobId;
  final PersonalExportStatus status;

  /// 0-100, as the API counts it.
  final int progress;

  final String? fileName;
  final String? contentType;

  /// When the archive stops being retrievable (`AF-02`).
  final DateTime? expiresAt;

  /// Why it failed, in the API's words (`AF-01`).
  final String? failureReason;

  /// Whether the archive is gone before anyone fetched it.
  ///
  /// Checked against the clock rather than trusted from a flag, because the
  /// job may have been sitting on screen for a while.
  bool get hasExpired {
    final expiry = expiresAt;
    return expiry != null && DateTime.now().isAfter(expiry);
  }

  bool get isRetrievable =>
      status == PersonalExportStatus.completed && !hasExpired;
}

/// An archive, in hand.
@immutable
class PersonalArchive {
  const PersonalArchive({
    required this.bytes,
    required this.fileName,
    required this.contentType,
  });

  final Uint8List bytes;
  final String fileName;
  final String contentType;

  /// `AF-05`: a user who holds almost nothing still gets a valid archive.
  /// Small is not empty, and empty is not an error.
  int get sizeBytes => bytes.length;
}

abstract interface class PersonalExportRepository {
  /// Asks the API to produce the archive (`FR-PR-06`).
  Future<Result<PersonalExport>> request();

  /// Reads where the job has got to.
  Future<Result<PersonalExport>> read(String jobId);

  /// Fetches the finished archive.
  Future<Result<PersonalArchive>> download(PersonalExport export);
}

class HttpPersonalExportRepository implements PersonalExportRepository {
  HttpPersonalExportRepository(this._client, this._dio);

  factory HttpPersonalExportRepository.fromDio(Dio dio) =>
      HttpPersonalExportRepository(MeClient(dio), dio);

  final MeClient _client;

  /// Used directly for the archive itself: the generated client returns typed
  /// JSON, and this one response is bytes.
  final Dio _dio;

  @override
  Future<Result<PersonalExport>> request() async {
    try {
      final output = (await _client.postApiMeDataExport()).data;

      if (output == null) {
        return const Failure(
          message: 'The instance did not start an export.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        PersonalExport(
          jobId: output.jobId ?? '',
          status: PersonalExportStatus.from(output.status),
          progress: output.progress ?? 0,
          expiresAt: output.expiresAt,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<PersonalExport>(exception);
    }
  }

  @override
  Future<Result<PersonalExport>> read(String jobId) async {
    try {
      final output = (await _client.getApiMeDataExportJobId(jobId: jobId)).data;

      if (output == null) {
        return const Failure(
          message: 'The instance did not report the export.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        PersonalExport(
          jobId: output.jobId ?? jobId,
          status: PersonalExportStatus.from(output.status),
          progress: output.progress ?? 0,
          fileName: output.fileName,
          contentType: output.contentType,
          expiresAt: output.expiresAt,
          failureReason: output.failureReason,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<PersonalExport>(exception);
    }
  }

  @override
  Future<Result<PersonalArchive>> download(PersonalExport export) async {
    try {
      final response = await _dio.get<List<int>>(
        '/api/me/data-export/${export.jobId}',
        options: Options(
          responseType: ResponseType.bytes,
          // The same route serves the report as JSON and the archive as bytes;
          // this is how the archive is asked for.
          headers: const {'Accept': 'application/octet-stream'},
        ),
      );

      final bytes = response.data;
      if (bytes == null) {
        return const Failure(
          message: 'The archive came back empty.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        PersonalArchive(
          bytes: Uint8List.fromList(bytes),
          fileName: export.fileName ?? 'fortuna-personal-data.zip',
          contentType: export.contentType ?? 'application/zip',
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<PersonalArchive>(exception);
    }
  }
}

final personalExportRepositoryProvider = Provider<PersonalExportRepository>(
  (ref) => HttpPersonalExportRepository.fromDio(ref.watch(dioProvider)),
);

/// Uploading a file for import (UC-32).
///
/// **Why this does not use the generated client.** `swagger_parser` types the
/// multipart file part as `dart:io`'s `File`, which does not exist on the web —
/// and `File` requires a path, which the web has no concept of. The generated
/// method is therefore unusable on one of this application's four targets.
///
/// So the request is built here with `dio`'s own `FormData` and
/// `MultipartFile.fromBytes`, which works identically everywhere. This is not
/// hand-editing generated code (`BR-36`) — the generated client is untouched;
/// it simply cannot serve this endpoint on every target, and the file is
/// still uploaded byte-for-byte unmodified (`BR-28`, `FR-IN-08`).
library;

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Where an import can come from, and what it accepts.
///
/// The limits are the client's fast check, not the authority: the API refuses
/// as well, and its refusal is what the user is shown (`AF-05`).
enum ImportSource {
  excel(
    label: 'Spreadsheet',
    description: 'An Excel workbook exported from a bank or kept by hand.',
    path: '/api/imports/excel',
    extensions: ['xlsx', 'xls'],
  ),
  pdf(
    label: 'Statement PDF',
    description: 'A credit card invoice in one of the supported layouts.',
    path: '/api/imports/pdf',
    extensions: ['pdf'],
  );

  const ImportSource({
    required this.label,
    required this.description,
    required this.path,
    required this.extensions,
  });

  final String label;
  final String description;
  final String path;

  /// The extensions this source accepts, lower-case and without a dot.
  final List<String> extensions;

  /// What to tell the user when their file is not one of these (`AF-01`).
  String get acceptedTypesLabel => extensions.map((e) => '.$e').join(' or ');

  /// Whether [fileName] is a type this source accepts.
  bool accepts(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) return false;
    return extensions.contains(fileName.substring(dot + 1).toLowerCase());
  }
}

/// The largest upload the instance is expected to take.
///
/// A client-side guard so a 200 MB file is refused instantly rather than after
/// a long upload (`AF-02`). The instance decides for certain, and its refusal
/// is presented if it disagrees.
const maxUploadBytes = 25 * 1024 * 1024;

/// A file the user picked, held only until it is uploaded.
@immutable
class PendingUpload {
  const PendingUpload({
    required this.fileName,
    required this.bytes,
    required this.source,
  });

  final String fileName;
  final Uint8List bytes;
  final ImportSource source;

  int get sizeBytes => bytes.length;
}

abstract interface class ImportUploadRepository {
  /// Uploads [upload] unmodified and returns the id of the job the API started.
  Future<Result<String>> upload(PendingUpload upload, {String? targetId});
}

class HttpImportUploadRepository implements ImportUploadRepository {
  const HttpImportUploadRepository(this._dio);

  final Dio _dio;

  @override
  Future<Result<String>> upload(
    PendingUpload upload, {
    String? targetId,
  }) async {
    try {
      final fields = <String, dynamic>{
        'File': MultipartFile.fromBytes(
          upload.bytes,
          filename: upload.fileName,
        ),
      };

      if (targetId != null) {
        // The two endpoints name the same idea differently: a PDF invoice
        // belongs to a card, a workbook to whichever holding was chosen.
        final field = upload.source == ImportSource.pdf
            ? 'CreditCardId'
            : 'TargetId';
        fields[field] = targetId;
      }

      final form = FormData.fromMap(fields);

      final response = await _dio.post<Map<String, dynamic>>(
        upload.source.path,
        data: form,
      );

      final jobId = _jobIdFrom(response.data);

      if (jobId == null) {
        // The upload was accepted but named no job, so there is nothing to
        // follow. Reported rather than claimed as a success with nowhere to go.
        return const Failure(
          message: 'The instance accepted the file but started no import.',
          kind: FailureKind.serverError,
        );
      }

      return Success(jobId);
    } on DioException catch (exception) {
      // AF-04 and AF-05 alike: the reason is the API's where it gave one, and
      // no partial import is ever claimed.
      return failureFromDioException<String>(exception);
    }
  }

  /// Digs the job id out of the API's envelope.
  String? _jobIdFrom(Map<String, dynamic>? body) {
    final data = body?['data'];
    if (data is! Map) return null;

    for (final key in ['importJobId', 'jobId', 'id']) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }
}

final importUploadRepositoryProvider = Provider<ImportUploadRepository>(
  (ref) => HttpImportUploadRepository(ref.watch(dioProvider)),
);

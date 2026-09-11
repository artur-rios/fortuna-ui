/// Imported record state (UC-34).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/imported_record_repository.dart';

/// Which page of which job's records is being read.
@immutable
class RecordPageRequest {
  const RecordPageRequest({required this.jobId, this.pageNumber = 1});

  final String jobId;
  final int pageNumber;

  RecordPageRequest atPage(int page) =>
      RecordPageRequest(jobId: jobId, pageNumber: page < 1 ? 1 : page);

  @override
  bool operator ==(Object other) =>
      other is RecordPageRequest &&
      other.jobId == jobId &&
      other.pageNumber == pageNumber;

  @override
  int get hashCode => Object.hash(jobId, pageNumber);
}

/// A page of the records a job took in.
///
/// Keyed on the request so paging is a different question rather than a
/// mutation of this one — the same property that keeps the spreadsheet view
/// from showing a stale page as current.
final importedRecordsProvider =
    FutureProvider.family<ImportedRecordPage, RecordPageRequest>(
      retry: (retryCount, error) => null,
      (ref, request) async {
        final result = await ref
            .read(importedRecordRepositoryProvider)
            .forJob(request.jobId, pageNumber: request.pageNumber);

        return switch (result) {
          Success<ImportedRecordPage>(:final value) => value,
          // AF-04.
          Failure<ImportedRecordPage>(:final message) =>
            throw ImportedRecordsUnavailable(message),
        };
      },
    );

class ImportedRecordsUnavailable implements Exception {
  const ImportedRecordsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

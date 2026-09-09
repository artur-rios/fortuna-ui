/// Import and synchronization jobs (UC-33).
///
/// A job belongs to the API, not to this client. The client tracks one; it does
/// not own it, cannot pause it, and does not lose it when the user navigates
/// away or the session ends (`AF-04`).
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Where a job has got to.
///
/// The API publishes these as unnamed integers; the mapping is its own —
/// 1 pending, 2 running, 3 completed, 4 failed.
enum JobState {
  pending,
  running,
  completed,
  failed,

  /// A state this build does not recognize. Shown as unknown rather than
  /// guessed at, since guessing "completed" would be a lie about someone's
  /// import.
  unknown;

  static JobState from(ImportJobStatus? status) => switch (status) {
    ImportJobStatus.value1 => JobState.pending,
    ImportJobStatus.value2 => JobState.running,
    ImportJobStatus.value3 => JobState.completed,
    ImportJobStatus.value4 => JobState.failed,
    _ => JobState.unknown,
  };

  bool get isFinished => this == JobState.completed || this == JobState.failed;
}

/// One import or synchronization.
@immutable
class ImportJob {
  const ImportJob({
    required this.id,
    required this.state,
    required this.processed,
    required this.imported,
    required this.duplicates,
    required this.rejected,
    required this.startedAt,
    this.failureReason,
    this.connectionId,
  });

  final String id;
  final JobState state;

  /// Rows the API has read so far.
  final int processed;

  /// The three outcomes, kept apart deliberately.
  ///
  /// `AF-02`: a partial import is never reported as a plain success or a plain
  /// failure. One malformed line in a 400-row statement must not cost the other
  /// 399, and the user has to be able to see that is what happened.
  final int imported;
  final int duplicates;
  final int rejected;

  final DateTime startedAt;
  final String? failureReason;
  final String? connectionId;

  bool get isFinished => state.isFinished;

  /// Whether some rows landed and others did not (`AF-02`).
  bool get isPartial => imported > 0 && (rejected > 0 || duplicates > 0);
}

abstract interface class ImportJobRepository {
  Future<Result<List<ImportJob>>> list();
  Future<Result<ImportJob>> read(String id);

  /// Starts a fresh job from a failed one (`AF-03`).
  Future<Result<void>> retry(String id);
}

class HttpImportJobRepository implements ImportJobRepository {
  HttpImportJobRepository(this._client);

  factory HttpImportJobRepository.fromDio(Dio dio) =>
      HttpImportJobRepository(ImportJobsClient(dio));

  final ImportJobsClient _client;

  @override
  Future<Result<List<ImportJob>>> list() async {
    try {
      final response = await _client.getApiImportJobs();
      return Success([
        for (final job in response.data ?? const <ImportJobOutput>[])
          _from(job),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<ImportJob>>(exception);
    }
  }

  @override
  Future<Result<ImportJob>> read(String id) async {
    try {
      final response = await _client.getApiImportJobsId(id: id);
      final job = response.data;

      if (job == null) {
        // AF-06: a job that is not there, or is not this user's — which the API
        // deliberately makes indistinguishable.
        return const Failure(
          message: 'That import job could not be found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(_from(job));
    } on DioException catch (exception) {
      return failureFromDioException<ImportJob>(exception);
    }
  }

  @override
  Future<Result<void>> retry(String id) async {
    try {
      await _client.postApiImportJobsIdRetry(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  ImportJob _from(ImportJobOutput output) => ImportJob(
    id: output.id ?? '',
    state: JobState.from(output.status),
    processed: output.processedCount ?? 0,
    imported: output.importedCount ?? 0,
    duplicates: output.duplicateCount ?? 0,
    rejected: output.rejectedCount ?? 0,
    startedAt: output.createdAt ?? DateTime.now(),
    failureReason: output.failureReason,
    connectionId: output.connectionId,
  );
}

final importJobRepositoryProvider = Provider<ImportJobRepository>(
  (ref) => HttpImportJobRepository.fromDio(ref.watch(dioProvider)),
);

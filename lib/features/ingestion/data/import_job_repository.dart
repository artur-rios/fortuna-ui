/// Import and synchronization jobs (UC-33).
///
/// A job belongs to the API, not to this client. The client tracks one; it does
/// not own it, cannot pause it, and does not lose it when the user navigates
/// away or the session ends (`AF-04`).
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/api.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/paging.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';

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
  /// One page of the user's jobs, newest first.
  ///
  /// Jobs accumulate with every import and synchronization, so they are read
  /// a page at a time, the way the transaction grid is (UC-25).
  Future<Result<PagedList<ImportJob>>> page(int pageNumber);

  /// Every job still pending or running, wherever it sits in the full list.
  ///
  /// What `UC-31 AF-06` needs: whether a connection already has a
  /// synchronization going cannot depend on which page that job is on.
  Future<Result<List<ImportJob>>> unfinished();

  Future<Result<ImportJob>> read(String id);

  /// Starts a fresh job from a failed one (`AF-03`).
  Future<Result<void>> retry(String id);
}

class HttpImportJobRepository implements ImportJobRepository {
  HttpImportJobRepository(this._client, {this._clock = systemClock});

  factory HttpImportJobRepository.fromDio(
    Dio dio, {
    Clock clock = systemClock,
  }) => HttpImportJobRepository(ImportJobsClient(dio), clock: clock);

  final ImportJobsClient _client;
  final Clock _clock;

  @override
  Future<Result<PagedList<ImportJob>>> page(int pageNumber) async {
    try {
      final page = await _client.getApiImportJobs(
        // Newest first, asked for rather than left to the API's default.
        sortBy: 'CreatedAt',
        descending: true,
        pageNumber: pageNumber,
        pageSize: browsePageSize,
      );
      final jobs = [
        for (final job in page.data ?? const <ImportJobOutput>[]) _from(job),
      ];

      return Success(
        PagedList(
          items: jobs,
          // UC-25 AF-05: the page the API answered with.
          pageNumber: page.pageNumber ?? pageNumber,
          totalItems: page.totalItems ?? jobs.length,
          totalPages: page.totalPages ?? 1,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<PagedList<ImportJob>>(exception);
    } on Object catch (error) {
      return failureFromUnreadableAnswer<PagedList<ImportJob>>(error);
    }
  }

  @override
  Future<Result<List<ImportJob>>> unfinished() async {
    try {
      // The API filters by one state at a time; these two are few, so each
      // is read whole.
      final jobs = <ImportJobOutput>[
        for (final status in const [
          ImportJobStatus.value1,
          ImportJobStatus.value2,
        ])
          ...await readEveryPage((pageNumber, pageSize) async {
            final page = await _client.getApiImportJobs(
              status: status,
              pageNumber: pageNumber,
              pageSize: pageSize,
            );
            return (
              items: page.data ?? const <ImportJobOutput>[],
              totalPages: page.totalPages,
            );
          }),
      ];

      return Success([for (final job in jobs) _from(job)]);
    } on DioException catch (exception) {
      return failureFromDioException<List<ImportJob>>(exception);
    } on Object catch (error) {
      return failureFromUnreadableAnswer<List<ImportJob>>(error);
    }
  }

  @override
  Future<Result<ImportJob>> read(String id) async {
    try {
      final response = await _client.getApiImportJobsById(id: id);
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
    } on Object catch (error) {
      return failureFromUnreadableAnswer<ImportJob>(error);
    }
  }

  @override
  Future<Result<void>> retry(String id) async {
    try {
      await _client.postApiImportJobsByIdRetry(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    } on Object catch (error) {
      return failureFromUnreadableAnswer<void>(error);
    }
  }

  ImportJob _from(ImportJobOutput output) => ImportJob(
    id: output.id ?? '',
    state: JobState.from(output.status),
    processed: output.processedCount ?? 0,
    imported: output.importedCount ?? 0,
    duplicates: output.duplicateCount ?? 0,
    rejected: output.rejectedCount ?? 0,
    startedAt: output.createdAt ?? _clock(),
    failureReason: output.failureReason,
    connectionId: output.connectionId,
  );
}

final importJobRepositoryProvider = Provider<ImportJobRepository>(
  (ref) => HttpImportJobRepository.fromDio(
    ref.watch(dioProvider),
    clock: ref.watch(clockProvider),
  ),
);

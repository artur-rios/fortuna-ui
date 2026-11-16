/// Import job state (UC-33).
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/paging.dart';
import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/import_job_repository.dart';

/// How often a running job is re-read.
///
/// The API offers no push and no progress figure, so completion is discovered
/// by asking. Three seconds is slow enough not to hammer an instance and fast
/// enough that a finished import does not sit unnoticed.
const jobPollInterval = Duration(seconds: 3);

/// Which page of the jobs is shown.
final importJobsPageProvider = NotifierProvider<ImportJobsPage, int>(
  ImportJobsPage.new,
);

class ImportJobsPage extends Notifier<int> {
  @override
  int build() => 1;

  void goToPage(int pageNumber) => state = pageNumber < 1 ? 1 : pageNumber;
}

/// The page of the user's jobs being shown, newest first.
///
/// Polls only while something on it is actually running — a page of finished
/// jobs is static, and polling it would be pure noise against the instance.
final importJobsProvider = StreamProvider<PagedList<ImportJob>>(
  retry: (retryCount, error) => null,
  (ref) {
    ref.read(sessionTeardownProvider).register('import-jobs', () async {
      ref.invalidateSelf();
    });

    final pageNumber = ref.watch(importJobsPageProvider);
    final repository = ref.read(importJobRepositoryProvider);

    return _pollWhileRunning(
      ref,
      read: () => repository.page(pageNumber),
      jobsOf: (page) => page.items,
    );
  },
);

/// Every job still pending or running, polled until none is.
///
/// Read apart from the page being shown, because `UC-31 AF-06` asks whether a
/// connection has a synchronization going, and the answer cannot depend on
/// which page that job sits on.
final unfinishedJobsProvider = StreamProvider<List<ImportJob>>(
  retry: (retryCount, error) => null,
  (ref) {
    ref.read(sessionTeardownProvider).register('unfinished-jobs', () async {
      ref.invalidateSelf();
    });

    final repository = ref.read(importJobRepositoryProvider);

    return _pollWhileRunning(
      ref,
      read: repository.unfinished,
      jobsOf: (jobs) => jobs,
    );
  },
);

/// Reads with [read] and yields each answer, again every [jobPollInterval]
/// while any job in it is unfinished.
Stream<T> _pollWhileRunning<T>(
  Ref ref, {
  required Future<Result<T>> Function() read,
  required List<ImportJob> Function(T value) jobsOf,
}) async* {
  // Cancelled when the provider is disposed, so the pending delay below is
  // torn down with it. Without this the loop would hold a live timer for up
  // to one interval after the screen is gone — harmless in production, and a
  // leak the test framework rightly refuses to ignore.
  final cancelled = Completer<void>();
  ref.onDispose(() {
    if (!cancelled.isCompleted) cancelled.complete();
  });

  while (true) {
    final value = switch (await read()) {
      Success<T>(:final value) => value,
      Failure<T>(:final message) => throw JobsUnavailable(message),
    };

    yield value;

    // AF-04 is the API's to keep, not this client's: the job runs there
    // regardless. This loop only decides how often to look.
    if (!jobsOf(value).any((job) => !job.isFinished)) return;

    await _wait(jobPollInterval, cancelled.future);
    if (cancelled.isCompleted) return;
  }
}

/// Waits [duration], or returns early — cancelling the timer — when
/// [cancelled] completes first.
Future<void> _wait(Duration duration, Future<void> cancelled) {
  final completer = Completer<void>();
  final timer = Timer(duration, () {
    if (!completer.isCompleted) completer.complete();
  });

  unawaited(
    cancelled.whenComplete(() {
      timer.cancel();
      if (!completer.isCompleted) completer.complete();
    }),
  );

  return completer.future;
}

class JobsUnavailable implements Exception {
  const JobsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Retrying a failed job (`AF-03`).
class ImportJobActions {
  const ImportJobActions(this._ref);

  final Ref _ref;

  /// Starts a fresh job from [id].
  ///
  /// The previous job is left exactly as it is — `AF-03` requires its outcome
  /// to remain visible, because a retry that erases what went wrong the first
  /// time takes away the only evidence of why.
  Future<Failure<void>?> retry(String id) async {
    final result = await _ref.read(importJobRepositoryProvider).retry(id);

    return switch (result) {
      Success<void>() => () {
        _ref
          ..invalidate(importJobsProvider)
          ..invalidate(unfinishedJobsProvider);
        return null;
      }(),
      final Failure<void> failure => failure,
    };
  }
}

final importJobActionsProvider = Provider<ImportJobActions>(
  ImportJobActions.new,
);

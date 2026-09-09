/// Import job state (UC-33).
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/import_job_repository.dart';

/// How often a running job is re-read.
///
/// The API offers no push and no progress figure, so completion is discovered
/// by asking. Three seconds is slow enough not to hammer an instance and fast
/// enough that a finished import does not sit unnoticed.
const jobPollInterval = Duration(seconds: 3);

/// The user's jobs, newest first.
///
/// Polls only while something is actually running — a list of finished jobs is
/// static, and polling it would be pure noise against the instance.
final importJobsProvider = StreamProvider<List<ImportJob>>(
  retry: (retryCount, error) => null,
  (ref) async* {
    ref.read(sessionTeardownProvider).register('import-jobs', () async {
      ref.invalidateSelf();
    });

    final repository = ref.read(importJobRepositoryProvider);

    // Cancelled when the provider is disposed, so the pending delay below is
    // torn down with it. Without this the loop would hold a live timer for up
    // to one interval after the screen is gone — harmless in production, and a
    // leak the test framework rightly refuses to ignore.
    final cancelled = Completer<void>();
    ref.onDispose(() {
      if (!cancelled.isCompleted) cancelled.complete();
    });

    while (true) {
      final result = await repository.list();

      final jobs = switch (result) {
        Success<List<ImportJob>>(:final value) =>
          value.toList()..sort((a, b) => b.startedAt.compareTo(a.startedAt)),
        Failure<List<ImportJob>>(:final message) => throw JobsUnavailable(
          message,
        ),
      };

      yield jobs;

      // AF-04 is the API's to keep, not this client's: the job runs there
      // regardless. This loop only decides how often to look.
      if (!jobs.any((job) => !job.isFinished)) return;

      await _wait(jobPollInterval, cancelled.future);
      if (cancelled.isCompleted) return;
    }
  },
);

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
        _ref.invalidate(importJobsProvider);
        return null;
      }(),
      final Failure<void> failure => failure,
    };
  }
}

final importJobActionsProvider = Provider<ImportJobActions>(
  ImportJobActions.new,
);

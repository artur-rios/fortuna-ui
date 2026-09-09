/// Connection state (UC-31).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/connection_repository.dart';
import '../data/import_job_repository.dart';
import 'import_job_providers.dart';

final connectionsProvider = FutureProvider<List<Connection>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('connections', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(connectionRepositoryProvider).list();

    return switch (result) {
      Success<List<Connection>>(:final value) =>
        value.toList()..sort((a, b) => b.connectedAt.compareTo(a.connectedAt)),
      Failure<List<Connection>>(:final message) => throw ConnectionsUnavailable(
        message,
      ),
    };
  },
);

class ConnectionsUnavailable implements Exception {
  const ConnectionsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The job already running for a connection, if there is one (`AF-06`).
///
/// This is why `ImportJob` carries the connection it belongs to: without it the
/// screen could only offer to start another synchronization and hope.
final runningSyncProvider = Provider.family<ImportJob?, String>((
  ref,
  connectionId,
) {
  final jobs = ref.watch(importJobsProvider).value ?? const <ImportJob>[];

  for (final job in jobs) {
    if (job.connectionId == connectionId && !job.isFinished) return job;
  }
  return null;
});

/// What a synchronization attempt did.
sealed class SyncOutcome {
  const SyncOutcome();
}

final class SyncStarted extends SyncOutcome {
  const SyncStarted(this.jobId);

  final String? jobId;
}

/// Refused before anything was sent, because the connection cannot sync
/// (`AF-01`, `AF-06`).
final class SyncNotAttempted extends SyncOutcome {
  const SyncNotAttempted(this.reason);

  final String reason;
}

final class SyncFailed extends SyncOutcome {
  const SyncFailed(this.reason);

  final String reason;
}

class ConnectionActions {
  const ConnectionActions(this._ref);

  final Ref _ref;

  ConnectionRepository get _repository =>
      _ref.read(connectionRepositoryProvider);

  /// Starts a synchronization, unless the connection cannot have one.
  Future<SyncOutcome> synchronize(Connection connection) async {
    // AF-01. A connection needing reauthentication cannot synchronize, so no
    // job is started that would only fail — the user is pointed at the thing
    // that would actually help.
    if (connection.state == BankConnectionState.requiresReauthentication) {
      return const SyncNotAttempted(
        'This connection needs to be reauthenticated before it can '
        'synchronize again.',
      );
    }

    if (connection.isRevoked) {
      return const SyncNotAttempted(
        'This connection was revoked and no longer synchronizes.',
      );
    }

    // AF-06. One already running: show it rather than starting a second.
    final running = _ref.read(runningSyncProvider(connection.id));
    if (running != null) {
      return SyncStarted(running.id);
    }

    final result = await _repository.synchronize(connection.id);

    return switch (result) {
      Success<String?>(:final value) => () {
        _ref
          ..invalidate(importJobsProvider)
          ..invalidate(connectionsProvider);
        return SyncStarted(value);
      }(),
      Failure<String?>(:final message) => SyncFailed(message),
    };
  }

  Future<Failure<void>?> reauthenticate(String id) =>
      _afterChange(_repository.reauthenticate(id));

  Future<Failure<void>?> revoke(String id) =>
      _afterChange(_repository.revoke(id));

  Future<Failure<void>?> _afterChange(Future<Result<void>> operation) async {
    final result = await operation;

    return switch (result) {
      Success<void>() => () {
        _ref.invalidate(connectionsProvider);
        return null;
      }(),
      final Failure<void> failure => failure,
    };
  }
}

final connectionActionsProvider = Provider<ConnectionActions>(
  ConnectionActions.new,
);

/// Data sources and the consent that gates connecting to one (UC-30).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/connection_repository.dart';
import '../data/data_source_repository.dart';
import 'connection_providers.dart';

/// The purpose a network connection discloses under (`FR-IN-02`, `BR-40`).
///
/// Named here rather than inlined at the call site so the consent this use
/// case asks for and the consent UC-42 records are provably the same string.
const externalProcessingPurpose = 'external-processing';

/// The sources this instance supports (`FR-IN-01`).
final dataSourcesProvider = FutureProvider<List<DataSource>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('dataSources', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(dataSourceRepositoryProvider).list();

    return switch (result) {
      Success<List<DataSource>>(:final value) => value,
      Failure<List<DataSource>>(:final message) => throw DataSourcesUnavailable(
        message,
      ),
    };
  },
);

class DataSourcesUnavailable implements Exception {
  const DataSourcesUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// What happened when a connection was attempted.
@immutable
sealed class ConnectOutcome {
  const ConnectOutcome();
}

/// Step 6: the connection exists.
@immutable
final class Connected extends ConnectOutcome {
  const Connected(this.connection);

  final Connection connection;
}

/// `AF-07`: one already covers this institution, so none was created.
@immutable
final class AlreadyConnected extends ConnectOutcome {
  const AlreadyConnected(this.existing);

  final Connection existing;
}

/// `AF-03`: the API refused for want of a consent it named.
///
/// Distinguished from a plain failure so the screen can present the
/// disclosure again rather than a bare error — which is exactly what the
/// alternative flow asks for.
@immutable
final class ConsentMissing extends ConnectOutcome {
  const ConsentMissing(this.reason);

  final String reason;
}

/// `AF-05`, and every other refusal, in the API's own words.
@immutable
final class ConnectFailed extends ConnectOutcome {
  const ConnectFailed(this.reason, {this.isRetryable = false});

  final String reason;

  /// Whether trying again could plausibly help. An unreachable aggregator
  /// could; a malformed request could not.
  final bool isRetryable;
}

/// Connecting an institution.
class ConnectActions {
  const ConnectActions(this._ref);

  final Ref _ref;

  /// Step 5, with `AF-07` checked first.
  Future<ConnectOutcome> connect({
    required String dataSource,
    required String externalReference,
  }) async {
    // AF-07: an existing connection is shown rather than duplicated. Asked
    // before submitting, because the API creating a second one and this
    // client then hiding it would leave a connection nobody manages.
    final existing = await _existingFor(externalReference);
    if (existing != null) return AlreadyConnected(existing);

    final result = await _ref
        .read(connectionRepositoryProvider)
        .connect(dataSource: dataSource, externalReference: externalReference);

    switch (result) {
      case Success<Connection>(:final value):
        _ref.invalidate(connectionsProvider);
        return Connected(value);

      case Failure<Connection>(:final message, :final kind):
        // AF-03: a refusal that names a consent is answered with the
        // disclosure, not with an error the user cannot act on.
        if (kind == FailureKind.forbidden ||
            message.toLowerCase().contains('consent')) {
          return ConsentMissing(message);
        }

        // AF-05: the aggregator being unreachable is worth retrying; a
        // rejected request is not.
        return ConnectFailed(
          message,
          isRetryable:
              kind == FailureKind.unreachable ||
              kind == FailureKind.serverError,
        );
    }
  }

  Future<Connection?> _existingFor(String externalReference) async {
    final result = await _ref.read(connectionRepositoryProvider).list();
    if (result case Success<List<Connection>>(:final value)) {
      for (final connection in value) {
        // A revoked connection is not one to reuse — it is a closed door, and
        // connecting again is the point of being here.
        if (!connection.isRevoked &&
            connection.externalReference == externalReference) {
          return connection;
        }
      }
    }
    return null;
  }
}

final connectActionsProvider = Provider<ConnectActions>(ConnectActions.new);

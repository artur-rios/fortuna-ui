/// Bank connections (UC-31).
///
/// The aggregator is reached only through the API (`BR-20`, `FR-IN-03`). This
/// client holds no bank credential, no aggregator token, and no knowledge of
/// which aggregator is in use — it acts on a connection by its identifier and
/// nothing else.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Where a connection stands.
///
/// Named for the bank rather than just `ConnectionState`, which would collide
/// with Flutter's own — a collision every file touching this would inherit.
///
/// The API publishes these as unnamed integers; its own mapping is
/// 1 active, 2 requires reauthentication, 3 revoked.
enum BankConnectionState {
  active,
  requiresReauthentication,

  /// Terminal. Synchronization stops; everything already imported stays
  /// (`BR-29`).
  revoked,

  /// A state this build does not recognize, shown as unknown rather than
  /// assumed to be working.
  unknown;

  static BankConnectionState from(ConnectionStatus? status) => switch (status) {
    ConnectionStatus.value1 => BankConnectionState.active,
    ConnectionStatus.value2 => BankConnectionState.requiresReauthentication,
    ConnectionStatus.value3 => BankConnectionState.revoked,
    _ => BankConnectionState.unknown,
  };
}

@immutable
class Connection {
  const Connection({
    required this.id,
    required this.state,
    required this.connectedAt,
    this.externalReference,
  });

  final String id;
  final BankConnectionState state;
  final DateTime connectedAt;

  /// The aggregator's own reference. Shown so a user can tell two connections
  /// apart; it is not a credential and never was.
  final String? externalReference;

  /// Whether anything can still be done with it (`AF-04`).
  bool get isRevoked => state == BankConnectionState.revoked;
}

abstract interface class ConnectionRepository {
  Future<Result<List<Connection>>> list();

  /// Starts a synchronization, returning the job the API created.
  Future<Result<String?>> synchronize(String id);

  Future<Result<void>> reauthenticate(String id);
  Future<Result<void>> revoke(String id);
}

class HttpConnectionRepository implements ConnectionRepository {
  HttpConnectionRepository(this._connections, this._sync);

  factory HttpConnectionRepository.fromDio(Dio dio) => HttpConnectionRepository(
    ConnectionsClient(dio),
    ConnectionSynchronizationClient(dio),
  );

  final ConnectionsClient _connections;
  final ConnectionSynchronizationClient _sync;

  @override
  Future<Result<List<Connection>>> list() async {
    try {
      final response = await _connections.getApiConnections();
      return Success([
        for (final connection in response.data ?? const <ConnectionOutput>[])
          Connection(
            id: connection.id ?? '',
            state: BankConnectionState.from(connection.status),
            connectedAt: connection.createdAt ?? DateTime.now(),
            externalReference: connection.externalReference,
          ),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<Connection>>(exception);
    }
  }

  @override
  Future<Result<String?>> synchronize(String id) async {
    try {
      final response = await _sync.postApiConnectionsIdSync(id: id);
      final data = response.data;

      return Success(_jobIdFrom(data?.toJson()));
    } on DioException catch (exception) {
      // AF-03: the aggregator being unavailable is the API's answer, presented
      // with its reason rather than reworded.
      return failureFromDioException<String?>(exception);
    }
  }

  @override
  Future<Result<void>> reauthenticate(String id) =>
      _run(() => _connections.postApiConnectionsIdReauthenticate(id: id));

  @override
  Future<Result<void>> revoke(String id) =>
      _run(() => _connections.postApiConnectionsIdRevoke(id: id));

  Future<Result<void>> _run(Future<Object?> Function() call) async {
    try {
      await call();
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  String? _jobIdFrom(Map<String, dynamic>? body) {
    for (final key in ['importJobId', 'jobId', 'id']) {
      final value = body?[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }
}

final connectionRepositoryProvider = Provider<ConnectionRepository>(
  (ref) => HttpConnectionRepository.fromDio(ref.watch(dioProvider)),
);

/// The instance's operational health (UC-45).
///
/// One subtlety shapes this whole file: the API answers the detailed check with
/// **503 and the same body** when the instance is unhealthy. Dio treats 503 as
/// an error, so the obvious implementation would report "the request failed"
/// at exactly the moment the API successfully told us what is wrong — which is
/// `AF-05`'s degraded instance, not `AF-01`'s failure. The body is read off the
/// error response instead.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// How a service or the instance as a whole is doing.
enum HealthStatus {
  healthy,
  degraded,
  unhealthy,

  /// Present in the deployment's configuration but not set up here.
  ///
  /// `AF-02`: distinct from unhealthy, because "we do not use this" and "this
  /// is broken" call for entirely different reactions.
  notConfigured,

  /// The API named a status this build does not recognize. Shown as reported
  /// rather than mapped onto something that looks reassuring.
  unknown;

  static HealthStatus parse(String? raw) =>
      switch (raw?.toLowerCase().replaceAll(RegExp('[ _-]'), '')) {
        'healthy' || 'up' || 'ok' => HealthStatus.healthy,
        'degraded' => HealthStatus.degraded,
        'unhealthy' || 'down' => HealthStatus.unhealthy,
        'notconfigured' ||
        'notapplicable' ||
        'disabled' => HealthStatus.notConfigured,
        _ => HealthStatus.unknown,
      };
}

/// One dependency's state.
@immutable
class ServiceHealth {
  const ServiceHealth({
    required this.name,
    required this.status,
    required this.rawStatus,
    this.queueDepth,
    this.oldestPendingSeconds,
  });

  final String name;
  final HealthStatus status;

  /// Exactly what the API called it, shown when [status] is
  /// [HealthStatus.unknown] so an unrecognized state is still legible.
  final String rawStatus;

  final int? queueDepth;
  final int? oldestPendingSeconds;
}

/// The instance's health, as the API reports it.
@immutable
class InstanceHealth {
  const InstanceHealth({
    required this.status,
    required this.rawStatus,
    required this.services,
  });

  final HealthStatus status;
  final String rawStatus;
  final List<ServiceHealth> services;

  /// The dependencies that are not well, for `AF-05` — which asks that the
  /// degraded state say *which* dependency caused it.
  List<ServiceHealth> get troubled => [
    for (final service in services)
      if (service.status == HealthStatus.degraded ||
          service.status == HealthStatus.unhealthy)
        service,
  ];
}

abstract interface class HealthRepository {
  Future<Result<InstanceHealth>> readDetailed();
}

class HttpHealthRepository implements HealthRepository {
  HttpHealthRepository(this._client);

  factory HttpHealthRepository.fromDio(Dio dio) =>
      HttpHealthRepository(DetailedHealthCheckClient(dio));

  final DetailedHealthCheckClient _client;

  @override
  Future<Result<InstanceHealth>> readDetailed() async {
    try {
      return Success(_from(await _client.getHealthcheckDetailed()));
    } on DioException catch (exception) {
      // The unhealthy instance answers 503 with a full report. That is an
      // answer, not a failure to get one.
      final recovered = _fromErrorBody(exception);
      if (recovered != null) return Success(recovered);

      return failureFromDioException<InstanceHealth>(exception);
    }
  }

  InstanceHealth? _fromErrorBody(DioException exception) {
    if (exception.response?.statusCode != 503) return null;

    final data = exception.response?.data;
    if (data is! Map<String, dynamic>) return null;

    try {
      return _from(OperationalHealthOutput.fromJson(data));
    } on Object {
      // A 503 whose body is not a health report really is a failure.
      return null;
    }
  }

  InstanceHealth _from(OperationalHealthOutput output) => InstanceHealth(
    status: HealthStatus.parse(output.status),
    rawStatus: output.status ?? 'unknown',
    services: [
      for (final service
          in output.services ?? const <OperationalHealthServiceOutput>[])
        ServiceHealth(
          name: service.name ?? 'Unnamed service',
          status: HealthStatus.parse(service.status),
          rawStatus: service.status ?? 'unknown',
          queueDepth: service.queueDepth,
          oldestPendingSeconds: service.oldestPendingSeconds,
        ),
    ],
  );
}

final healthRepositoryProvider = Provider<HealthRepository>(
  (ref) => HttpHealthRepository.fromDio(ref.watch(dioProvider)),
);

/// The instance's health, re-read on demand.
///
/// Automatic retry is **off**, deliberately. Riverpod retries a failed provider
/// on its own by default, which here means an unreachable instance is polled
/// with backoff behind the user's back — while the screen simultaneously offers
/// them a Retry button that would then be meaningless. `AF-01` asks for a
/// failed state with a reason and a retry; the retry is the user's.
final instanceHealthProvider = FutureProvider<InstanceHealth>(
  retry: (retryCount, error) => null,
  (ref) async {
    final result = await ref.read(healthRepositoryProvider).readDetailed();

    return switch (result) {
      Success<InstanceHealth>(:final value) => value,
      Failure<InstanceHealth>(:final message) => throw HealthUnavailable(
        message,
      ),
    };
  },
);

/// Raised when the health could not be read at all (`AF-01`, `AF-03`).
class HealthUnavailable implements Exception {
  const HealthUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

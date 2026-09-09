import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/administration/data/health_repository.dart';

/// Answers from memory, so no test reaches the network.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);

  Future<ResponseBody> Function(RequestOptions options) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);

  @override
  void close({bool force = false}) {}
}

Dio dioAnswering(int status, Object? body) {
  final dio = Dio(BaseOptions(baseUrl: 'https://fortuna.example'))
    ..httpClientAdapter = _Adapter(
      (options) async => ResponseBody.fromString(
        body == null ? '' : jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
  return dio;
}

const _report = {
  'status': 'Degraded',
  'services': [
    {'name': 'Database', 'status': 'Healthy'},
    {'name': 'Aggregator', 'status': 'Unhealthy'},
    {'name': 'Rate source', 'status': 'NotConfigured'},
    {
      'name': 'Job runner',
      'status': 'Healthy',
      'queueDepth': 4,
      'oldestPendingSeconds': 12,
    },
  ],
};

void main() {
  group('HttpHealthRepository', () {
    test(
      'Given a healthy instance '
      'When the detailed check is read '
      'Then the aggregate and each dependency are reported (UC-45 main flow)',
      () async {
        final repository = HttpHealthRepository.fromDio(
          dioAnswering(200, _report),
        );

        final result = await repository.readDetailed();

        expect(result, isA<Success<InstanceHealth>>());
        final health = (result as Success<InstanceHealth>).value;
        expect(health.status, HealthStatus.degraded);
        expect(health.services, hasLength(4));
      },
    );

    test('Given an unhealthy instance answering 503 with a full report '
        'When the detailed check is read '
        'Then the report is read from it rather than treated as a failure '
        '(UC-45 AF-05)', () async {
      // This is the case that makes the whole repository non-obvious: dio
      // throws on 503, and the naive implementation would report "the
      // request failed" at the moment the API successfully said what is
      // wrong.
      final repository = HttpHealthRepository.fromDio(
        dioAnswering(503, _report),
      );

      final result = await repository.readDetailed();

      expect(result, isA<Success<InstanceHealth>>());
      final health = (result as Success<InstanceHealth>).value;
      expect(health.status, HealthStatus.degraded);
      expect(
        health.troubled.map((service) => service.name),
        contains('Aggregator'),
      );
    });

    test('Given a 503 whose body is not a health report '
        'When the detailed check is read '
        'Then it really is a failure (UC-45 AF-01)', () async {
      final repository = HttpHealthRepository.fromDio(
        dioAnswering(503, 'the gateway is down'),
      );

      expect(await repository.readDetailed(), isA<Failure<InstanceHealth>>());
    });

    test(
      'Given the API refuses the detailed check '
      'When it is read '
      'Then the refusal is reported and no data is shown (UC-45 AF-03)',
      () async {
        final repository = HttpHealthRepository.fromDio(
          dioAnswering(403, {
            'messages': ['Administering the instance confers no access.'],
          }),
        );

        final result = await repository.readDetailed();

        expect(result, isA<Failure<InstanceHealth>>());
        final failure = result as Failure<InstanceHealth>;
        expect(failure.kind, FailureKind.forbidden);
        expect(
          failure.message,
          'Administering the instance confers no access.',
        );
      },
    );

    test(
      'Given a dependency the deployment does not configure '
      'When the report is read '
      'Then it is not-configured rather than unhealthy (UC-45 AF-02)',
      () async {
        final repository = HttpHealthRepository.fromDio(
          dioAnswering(200, _report),
        );

        final health =
            ((await repository.readDetailed()) as Success<InstanceHealth>)
                .value;
        final rateSource = health.services.firstWhere(
          (service) => service.name == 'Rate source',
        );

        expect(rateSource.status, HealthStatus.notConfigured);
        // And it is not counted among the causes of trouble.
        expect(
          health.troubled.map((s) => s.name),
          isNot(contains('Rate source')),
        );
      },
    );

    test('Given a status this build does not recognize '
        'When the report is read '
        'Then it is unknown and keeps what the API called it', () async {
      final repository = HttpHealthRepository.fromDio(
        dioAnswering(200, {'status': 'Fantastic', 'services': <Object>[]}),
      );

      final health =
          ((await repository.readDetailed()) as Success<InstanceHealth>).value;

      expect(health.status, HealthStatus.unknown);
      expect(health.rawStatus, 'Fantastic');
    });

    test('Given the instance cannot be reached '
        'When the detailed check is read '
        'Then it is a retryable failure (UC-45 AF-01)', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://fortuna.example'))
        ..httpClientAdapter = _Adapter(
          (options) async => throw DioException.connectionError(
            requestOptions: options,
            reason: 'offline',
          ),
        );

      final result = await HttpHealthRepository.fromDio(dio).readDetailed();

      expect(result, isA<Failure<InstanceHealth>>());
      expect((result as Failure<InstanceHealth>).kind, FailureKind.unreachable);
    });
  });

  group('HealthStatus.parse', () {
    test('Given the statuses the API uses '
        'When they are parsed '
        'Then each maps to its own state, however it is spelled', () {
      expect(HealthStatus.parse('Healthy'), HealthStatus.healthy);
      expect(HealthStatus.parse('up'), HealthStatus.healthy);
      expect(HealthStatus.parse('Degraded'), HealthStatus.degraded);
      expect(HealthStatus.parse('UNHEALTHY'), HealthStatus.unhealthy);
      expect(HealthStatus.parse('Not Configured'), HealthStatus.notConfigured);
      expect(HealthStatus.parse('not_configured'), HealthStatus.notConfigured);
      expect(HealthStatus.parse(null), HealthStatus.unknown);
    });
  });
}

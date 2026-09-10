import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/setup/data/instance_probe.dart';

/// Answers from memory, so no test reaches the network.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);

  final Future<ResponseBody> Function(RequestOptions options) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);

  @override
  void close({bool force = false}) {}
}

HttpInstanceProbe probeAnswering(
  Future<ResponseBody> Function(RequestOptions options) respond, {
  void Function(String address)? onBuild,
}) => HttpInstanceProbe(
  buildClient: (address) {
    onBuild?.call(address);
    return Dio(BaseOptions(baseUrl: address))
      ..httpClientAdapter = _Adapter(respond);
  },
);

Future<ResponseBody> json(int status, Object? body) async =>
    ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  group('HttpInstanceProbe', () {
    test(
      'Given an instance that answers the anonymous health check '
      'When it is probed '
      'Then its contract and service are reported (UC-01 main flow)',
      () async {
        final probe = probeAnswering(
          (_) => json(200, {'contractVersion': 'v1', 'service': 'Fortuna API'}),
        );

        final result = await probe.probe('https://fortuna.example');

        expect(result, isA<Success<InstanceIdentity>>());
        final identity = result.valueOrNull!;
        expect(identity.contractVersion, 'v1');
        expect(identity.service, 'Fortuna API');
        expect(identity.compatibility.isCompatible, isTrue);
      },
    );

    test(
      'Given the candidate address '
      'When it is probed '
      'Then the client is built against that address, not the configured one',
      () async {
        final built = <String>[];
        final probe = probeAnswering(
          (_) => json(200, {'contractVersion': 'v1', 'service': 'Fortuna API'}),
          onBuild: built.add,
        );

        await probe.probe('https://elsewhere.example:8443');

        expect(built, ['https://elsewhere.example:8443']);
      },
    );

    test('Given an instance that cannot be reached '
        'When it is probed '
        'Then it is reported as unreachable (UC-01 AF-02)', () async {
      final probe = probeAnswering(
        (options) => Future.error(
          DioException.connectionError(
            requestOptions: options,
            reason: 'no route to host',
          ),
        ),
      );

      final result = await probe.probe('https://nowhere.example');

      expect(result, isA<Failure<InstanceIdentity>>());
      expect(
        (result as Failure<InstanceIdentity>).kind,
        FailureKind.unreachable,
      );
    });

    test('Given an instance that answered once and then stops answering '
        'When it is probed again '
        'Then the earlier answer is not replayed as though current '
        '(UC-01 AF-06)', () async {
      var answered = true;
      final probe = probeAnswering((options) {
        if (answered) {
          answered = false;
          return json(200, {'contractVersion': 'v1', 'service': 'Fortuna API'});
        }
        return Future.error(
          DioException.connectionError(
            requestOptions: options,
            reason: 'connection lost',
          ),
        );
      });

      final first = await probe.probe('https://fortuna.example');
      final second = await probe.probe('https://fortuna.example');

      expect(first, isA<Success<InstanceIdentity>>());
      expect(second, isA<Failure<InstanceIdentity>>());
      expect(
        (second as Failure<InstanceIdentity>).kind,
        FailureKind.unreachable,
      );
    });

    test('Given an instance reporting a contract this build does not speak '
        'When it is probed '
        'Then it answers successfully and is judged incompatible '
        '(UC-01 AF-05)', () async {
      final probe = probeAnswering(
        (_) => json(200, {'contractVersion': 'v9', 'service': 'Fortuna API'}),
      );

      final result = await probe.probe('https://fortuna.example');

      // The distinction that matters: reaching it worked, so this is not AF-02.
      expect(result, isA<Success<InstanceIdentity>>());
      expect(result.valueOrNull!.compatibility.isCompatible, isFalse);
    });

    test('Given an address that answers with something that is not Fortuna '
        'When it is probed '
        'Then it is refused without being called unreachable', () async {
      final probe = probeAnswering((_) => json(200, 'a web page'));

      final result = await probe.probe('https://example.com');

      expect(result, isA<Failure<InstanceIdentity>>());
      expect(
        (result as Failure<InstanceIdentity>).kind,
        isNot(FailureKind.unreachable),
      );
    });
  });
}

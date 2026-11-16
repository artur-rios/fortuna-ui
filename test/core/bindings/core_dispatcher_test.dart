import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_dispatcher.dart';
import 'package:fortuna_ui/core/bindings/core_dispatcher_native.dart';

/// Stands in for the boundary, so the lifecycle is tested without a library.
class FakeDispatcher implements CoreDispatcher {
  FakeDispatcher({
    this.initializeWith = const CoreResponse(status: 200, body: ''),
  });

  CoreResponse initializeWith;
  int initializations = 0;
  final List<String> calls = [];
  bool disposed = false;

  @override
  Future<CoreResponse> initialize(String requestJson) async {
    initializations++;
    return initializeWith;
  }

  @override
  Future<CoreResponse> call(String symbol, String requestJson) async {
    calls.add(symbol);
    return const CoreResponse(status: 200, body: '{"success":true}');
  }

  @override
  Future<void> dispose() async => disposed = true;
}

void main() {
  group('InitializingCoreDispatcher', () {
    test('Given a core that has not been initialized '
        'When an operation is called '
        'Then the core is initialized first', () async {
      final inner = FakeDispatcher();
      final dispatcher = InitializingCoreDispatcher(
        inner,
        configurationJson: '{"databasePath":""}',
      );

      await dispatcher.call('fortuna_api_tags_get', '{}');

      expect(inner.initializations, 1);
      expect(inner.calls, ['fortuna_api_tags_get']);
    });

    test('Given several operations '
        'When they are called '
        'Then the core is initialized exactly once', () async {
      final inner = FakeDispatcher();
      final dispatcher = InitializingCoreDispatcher(
        inner,
        configurationJson: '{}',
      );

      await Future.wait([
        dispatcher.call('a', '{}'),
        dispatcher.call('b', '{}'),
        dispatcher.call('c', '{}'),
      ]);

      expect(inner.initializations, 1);
      expect(inner.calls, hasLength(3));
    });

    test('Given a core another dispatcher already initialized '
        'When initialization answers 409 '
        'Then that counts as ready rather than as a failure', () async {
      final inner = FakeDispatcher(
        initializeWith: const CoreResponse(status: 409, body: 'already'),
      );
      final dispatcher = InitializingCoreDispatcher(
        inner,
        configurationJson: '{}',
      );

      await dispatcher.call('fortuna_api_tags_get', '{}');

      expect(inner.calls, ['fortuna_api_tags_get']);
    });

    test('Given a core that cannot be initialized '
        'When an operation is called '
        'Then it fails with the reason and the operation is not attempted '
        '(UC-02 AF-01)', () async {
      final inner = FakeDispatcher(
        initializeWith: const CoreResponse(
          status: 500,
          body: 'the database is locked',
        ),
      );
      final dispatcher = InitializingCoreDispatcher(
        inner,
        configurationJson: '{}',
      );

      await expectLater(
        dispatcher.call('fortuna_api_tags_get', '{}'),
        throwsA(
          isA<CoreUnavailable>().having(
            (error) => error.message,
            'message',
            contains('the database is locked'),
          ),
        ),
      );
      expect(inner.calls, isEmpty);
    });

    test('Given initialization failed once '
        'When it is called again '
        'Then it is retried rather than permanently poisoned', () async {
      final inner = FakeDispatcher(
        initializeWith: const CoreResponse(status: 500, body: 'locked'),
      );
      final dispatcher = InitializingCoreDispatcher(
        inner,
        configurationJson: '{}',
      );

      await expectLater(
        dispatcher.call('a', '{}'),
        throwsA(isA<CoreUnavailable>()),
      );

      inner.initializeWith = const CoreResponse(status: 200, body: '');
      await dispatcher.call('a', '{}');

      expect(inner.initializations, 2);
      expect(inner.calls, ['a']);
    });

    test('Given a dispatcher in use '
        'When it is disposed '
        'Then the boundary beneath it is disposed too', () async {
      final inner = FakeDispatcher();
      final dispatcher = InitializingCoreDispatcher(
        inner,
        configurationJson: '{}',
      );

      await dispatcher.dispose();

      expect(inner.disposed, isTrue);
    });

    test('Given a caller that initializes the core explicitly '
        'When it does '
        "Then the request reaches the core and the core's answer comes back "
        'as it is, a 409 included', () async {
      final inner = FakeDispatcher(
        initializeWith: const CoreResponse(status: 409, body: 'already'),
      );
      final dispatcher = InitializingCoreDispatcher(
        inner,
        configurationJson: '{}',
      );

      final response = await dispatcher.initialize('{"databasePath":"x"}');

      expect((response.status, response.body), (409, 'already'));
      expect(inner.initializations, 1);
    });
  });

  group('createCoreDispatcher', () {
    test('Given a library path on a target with dart:ffi '
        'When the dispatcher is created '
        'Then it is the isolate-backed one for that path, and nothing is '
        'loaded until it is used', () async {
      final dispatcher = createCoreDispatcher(
        libraryPath: 'missing/fortuna_core.dll',
      );

      expect(
        dispatcher,
        isA<IsolateCoreDispatcher>().having(
          (native) => native.libraryPath,
          'libraryPath',
          'missing/fortuna_core.dll',
        ),
      );
      await dispatcher.dispose();
    });
  });

  group('CoreUnavailable', () {
    test('Given the core cannot be reached '
        'When the reason is shown '
        'Then it reads as the message rather than as an exception type', () {
      expect(
        const CoreUnavailable('The core could not be loaded.').toString(),
        'The core could not be loaded.',
      );
    });
  });
}

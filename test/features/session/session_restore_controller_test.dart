import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/session/data/session_repository.dart';
import 'package:fortuna_ui/features/session/state/session_restore_controller.dart';

import '../../core/session/token_claims_test.dart' show tokenWith;

/// A token store whose read always throws, for `AF-04`.
class UnavailableTokenStore implements TokenStore {
  @override
  Future<String?> read() async =>
      throw StateError('secure storage unavailable');

  @override
  Future<void> write(String token) async {}

  @override
  Future<void> clear() async {}
}

class FakeSessionRepository implements SessionRepository {
  FakeSessionRepository(this._result);

  final Result<VerifiedProfile> _result;
  int calls = 0;

  @override
  Future<Result<VerifiedProfile>> verifyCurrentToken() async {
    calls++;
    return _result;
  }
}

const _ownerToken = {'id': 'subject-1', 'role': 3};

ProviderContainer containerWith({
  required TokenStore tokenStore,
  required SessionRepository repository,
}) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        const AppConfig(
          apiBaseUrl: 'https://fortuna.example',
          googleClientId: '',
          transport: Transport.http,
          databasePath: '',
        ),
      ),
      tokenStoreProvider.overrideWithValue(tokenStore),
      sessionRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('SessionRestoreController', () {
    test('Given a stored token the API confirms '
        'When the session is restored '
        'Then a session is held with the role the token names', () async {
      final store = InMemoryTokenStore();
      await store.write(tokenWith(_ownerToken));
      final container = containerWith(
        tokenStore: store,
        repository: FakeSessionRepository(
          const Success(VerifiedProfile(displayName: 'Ada')),
        ),
      );

      await container.read(sessionRestoreProvider.notifier).restore();

      expect(
        container.read(sessionRestoreProvider),
        isA<SessionRestoreComplete>(),
      );
      final session = container.read(sessionProvider);
      expect(session, isA<SignedIn>());
      expect((session as SignedIn).role, Role.accountOwner);
      expect(session.subjectReference, 'subject-1');
    });

    test('Given no token is stored '
        'When the session is restored '
        'Then it completes with no session and the API is never called '
        '(UC-11 AF-01)', () async {
      final repository = FakeSessionRepository(
        const Success(VerifiedProfile()),
      );
      final container = containerWith(
        tokenStore: InMemoryTokenStore(),
        repository: repository,
      );

      await container.read(sessionRestoreProvider.notifier).restore();

      expect(
        container.read(sessionRestoreProvider),
        isA<SessionRestoreComplete>(),
      );
      expect(container.read(sessionProvider), isA<SignedOut>());
      expect(repository.calls, 0);
    });

    test(
      'Given the API rejects the stored token '
      'When the session is restored '
      'Then the token is discarded and no session is held (UC-11 AF-02)',
      () async {
        final store = InMemoryTokenStore();
        await store.write(tokenWith(_ownerToken));
        final container = containerWith(
          tokenStore: store,
          repository: FakeSessionRepository(
            const Failure(
              message: 'Unauthorized.',
              kind: FailureKind.unauthenticated,
            ),
          ),
        );

        await container.read(sessionRestoreProvider.notifier).restore();

        expect(
          container.read(sessionRestoreProvider),
          isA<SessionRestoreComplete>(),
        );
        expect(container.read(sessionProvider), isA<SignedOut>());
        expect(await store.read(), isNull);
      },
    );

    test('Given the API cannot be reached '
        'When the session is restored '
        'Then the user is not admitted, a retry is offered, and the token is '
        'kept (UC-11 AF-03)', () async {
      final store = InMemoryTokenStore();
      await store.write(tokenWith(_ownerToken));
      final container = containerWith(
        tokenStore: store,
        repository: FakeSessionRepository(
          const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await container.read(sessionRestoreProvider.notifier).restore();

      final state = container.read(sessionRestoreProvider);
      expect(state, isA<SessionRestoreFailed>());
      expect((state as SessionRestoreFailed).canRetry, isTrue);
      expect(state.message, 'The instance could not be reached.');
      expect(container.read(sessionProvider), isA<SignedOut>());
      // The token may well still be valid — we simply could not ask.
      expect(await store.read(), isNotNull);
    });

    test('Given secure storage is unavailable '
        'When the session is restored '
        'Then it reports so and offers no retry (UC-11 AF-04)', () async {
      final container = containerWith(
        tokenStore: UnavailableTokenStore(),
        repository: FakeSessionRepository(const Success(VerifiedProfile())),
      );

      await container.read(sessionRestoreProvider.notifier).restore();

      final state = container.read(sessionRestoreProvider);
      expect(state, isA<SessionRestoreFailed>());
      expect((state as SessionRestoreFailed).canRetry, isFalse);
      expect(container.read(sessionProvider), isA<SignedOut>());
    });

    test('Given a stored token naming an unrecognized role '
        'When the session is restored '
        'Then it is discarded without asking the API (UC-11 AF-05)', () async {
      final store = InMemoryTokenStore();
      await store.write(tokenWith({'id': 's', 'role': 99}));
      final repository = FakeSessionRepository(
        const Success(VerifiedProfile()),
      );
      final container = containerWith(
        tokenStore: store,
        repository: repository,
      );

      await container.read(sessionRestoreProvider.notifier).restore();

      expect(container.read(sessionProvider), isA<SignedOut>());
      expect(await store.read(), isNull);
      expect(repository.calls, 0);
    });

    test('Given a malformed stored token '
        'When the session is restored '
        'Then it is discarded without asking the API', () async {
      final store = InMemoryTokenStore();
      await store.write('not-a-token');
      final repository = FakeSessionRepository(
        const Success(VerifiedProfile()),
      );
      final container = containerWith(
        tokenStore: store,
        repository: repository,
      );

      await container.read(sessionRestoreProvider.notifier).restore();

      expect(container.read(sessionProvider), isA<SignedOut>());
      expect(await store.read(), isNull);
      expect(repository.calls, 0);
    });

    test('Given a restore that failed as unreachable '
        'When it is retried and the instance answers '
        'Then the session is admitted', () async {
      final store = InMemoryTokenStore();
      await store.write(tokenWith(_ownerToken));
      var attempt = 0;
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              apiBaseUrl: 'https://fortuna.example',
              googleClientId: '',
              transport: Transport.http,
              databasePath: '',
            ),
          ),
          tokenStoreProvider.overrideWithValue(store),
          sessionRepositoryProvider.overrideWithValue(
            _SwitchingRepository(() {
              attempt++;
              return attempt == 1
                  ? const Failure<VerifiedProfile>(
                      message: 'unreachable',
                      kind: FailureKind.unreachable,
                    )
                  : const Success(VerifiedProfile());
            }),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(sessionRestoreProvider.notifier).restore();
      expect(
        container.read(sessionRestoreProvider),
        isA<SessionRestoreFailed>(),
      );

      await container.read(sessionRestoreProvider.notifier).restore();

      expect(
        container.read(sessionRestoreProvider),
        isA<SessionRestoreComplete>(),
      );
      expect(container.read(sessionProvider), isA<SignedIn>());
    });
  });
}

class _SwitchingRepository implements SessionRepository {
  _SwitchingRepository(this._next);

  final Result<VerifiedProfile> Function() _next;

  @override
  Future<Result<VerifiedProfile>> verifyCurrentToken() async => _next();
}

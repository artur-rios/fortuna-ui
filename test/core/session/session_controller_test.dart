import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/session/session_teardown.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';

/// A store whose `clear` always fails, for `AF-04`.
class UnclearableTokenStore implements TokenStore {
  UnclearableTokenStore(this._token);

  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async => _token = token;

  @override
  Future<void> clear() async => throw StateError('cannot clear');
}

const _session = SignedIn(
  role: Role.accountOwner,
  mode: AppMode.connected,
  subjectReference: 'subject-1',
);

ProviderContainer containerWith(TokenStore store, [SessionTeardown? teardown]) {
  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(store),
      if (teardown != null) sessionTeardownProvider.overrideWithValue(teardown),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('SessionController.signOut', () {
    test('Given a session '
        'When the user signs out '
        'Then the token is cleared, the caches are torn down, and the session '
        'ends (UC-12 main flow)', () async {
      final store = InMemoryTokenStore();
      await store.write('a-token');
      final teardown = SessionTeardown();
      var cleared = false;
      teardown.register('accounts', () async => cleared = true);

      final container = containerWith(store, teardown);
      await container
          .read(sessionProvider.notifier)
          .grant(token: 'a-token', session: _session);

      final outcome = await container.read(sessionProvider.notifier).signOut();

      expect(outcome, isA<SignedOutCleanly>());
      expect(container.read(sessionProvider), isA<SignedOut>());
      expect(await store.read(), isNull);
      expect(cleared, isTrue);
    });

    test(
      'Given the token cannot be removed '
      'When the user signs out '
      'Then the session is NOT ended and they are told (UC-12 AF-04)',
      () async {
        final teardown = SessionTeardown();
        var cleared = false;
        teardown.register('accounts', () async => cleared = true);

        final container = containerWith(
          UnclearableTokenStore('a-token'),
          teardown,
        );
        await container
            .read(sessionProvider.notifier)
            .grant(token: 'a-token', session: _session);

        final outcome = await container
            .read(sessionProvider.notifier)
            .signOut();

        expect(outcome, isA<SignOutFailed>());
        // Still signed in: telling someone they signed out when their token is
        // still on the device is the one outcome worse than refusing.
        expect(container.read(sessionProvider), isA<SignedIn>());
        // And nothing was half-cleared.
        expect(cleared, isFalse);
      },
    );

    test('Given a signed-out session '
        'When the user signs out again '
        'Then it is harmless', () async {
      final container = containerWith(InMemoryTokenStore());

      final outcome = await container.read(sessionProvider.notifier).signOut();

      expect(outcome, isA<SignedOutCleanly>());
      expect(container.read(sessionProvider), isA<SignedOut>());
    });
  });

  group('SessionController.rejectedByApi', () {
    test('Given a token the API rejected mid-session '
        'When the session ends '
        'Then it ends with a reason and the caches are torn down '
        '(UC-12 AF-01)', () async {
      final store = InMemoryTokenStore();
      await store.write('a-token');
      final teardown = SessionTeardown();
      var cleared = false;
      teardown.register('accounts', () async => cleared = true);

      final container = containerWith(store, teardown);
      await container
          .read(sessionProvider.notifier)
          .grant(token: 'a-token', session: _session);

      await container.read(sessionProvider.notifier).rejectedByApi();

      final state = container.read(sessionProvider);
      expect(state, isA<SignedOut>());
      expect((state as SignedOut).reason, isNotNull);
      expect(await store.read(), isNull);
      expect(cleared, isTrue);
    });

    test('Given a rejected token that also cannot be cleared '
        'When the session ends '
        'Then it ends anyway — a rejected token is worthless', () async {
      final container = containerWith(UnclearableTokenStore('a-token'));
      await container
          .read(sessionProvider.notifier)
          .grant(token: 'a-token', session: _session);

      await container.read(sessionProvider.notifier).rejectedByApi();

      expect(container.read(sessionProvider), isA<SignedOut>());
    });

    test(
      'Given a session ended by the API '
      'When it ends '
      'Then nothing is retried, refreshed or replayed (UC-12 AF-02)',
      () async {
        final store = InMemoryTokenStore();
        await store.write('a-token');
        var writes = 0;
        final container = containerWith(_CountingStore(store, () => writes++));

        await container
            .read(sessionProvider.notifier)
            .grant(token: 'a-token', session: _session);
        final writesAfterGrant = writes;

        await container.read(sessionProvider.notifier).rejectedByApi();

        // No new token was written: no silent refresh was attempted, which is
        // what FR-SE-19 forbids and what would otherwise hide an expiry from
        // the user.
        expect(writes, writesAfterGrant);
        expect(container.read(sessionProvider), isA<SignedOut>());
      },
    );

    test('Given a custom reason '
        'When the session ends '
        'Then that reason is carried, not a generic expiry message', () async {
      final container = containerWith(InMemoryTokenStore());

      await container
          .read(sessionProvider.notifier)
          .rejectedByApi(reason: 'The stored session could not be read.');

      expect(
        (container.read(sessionProvider) as SignedOut).reason,
        'The stored session could not be read.',
      );
    });
  });
}

class _CountingStore implements TokenStore {
  _CountingStore(this._inner, this._onWrite);

  final TokenStore _inner;
  final void Function() _onWrite;

  @override
  Future<String?> read() => _inner.read();

  @override
  Future<void> write(String token) {
    _onWrite();
    return _inner.write(token);
  }

  @override
  Future<void> clear() => _inner.clear();
}

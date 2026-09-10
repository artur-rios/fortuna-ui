import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/auth/data/credentials_repository.dart';
import 'package:fortuna_ui/features/auth/state/sign_in_controller.dart';

/// A token the client can actually read, so `grant` reaches a real session.
String tokenFor({int role = 1, String subject = 'user-1'}) {
  String segment(Map<String, Object?> claims) =>
      base64Url.encode(utf8.encode(jsonEncode(claims))).replaceAll('=', '');

  return '${segment({'alg': 'none'})}.'
      '${segment({'id': subject, 'role': role, 'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000})}.signature';
}

class FakeCredentials implements CredentialsRepository {
  FakeCredentials(this.answer);

  Result<SignInOutcome> Function(String email, String password) answer;
  final List<({String email, String password})> submitted = [];

  @override
  Future<Result<SignInOutcome>> signIn({
    required String email,
    required String password,
  }) async {
    submitted.add((email: email, password: password));
    return answer(email, password);
  }

  /// What the Google exchange answers, and what it was handed.
  Result<SignInGranted> Function(String idToken) googleAnswer = (_) =>
      const Failure(message: 'not used here', kind: FailureKind.serverError);
  final List<String> exchangedIdTokens = [];

  @override
  Future<Result<SignInGranted>> exchangeGoogleIdToken(String idToken) async {
    exchangedIdTokens.add(idToken);
    return googleAnswer(idToken);
  }

  @override
  Future<Result<SignInGranted>> verifyTwoFactor({
    required String challengeToken,
    String? code,
    String? recoveryCode,
  }) async =>
      const Failure(message: 'not used here', kind: FailureKind.serverError);
}

ProviderContainer containerWith(FakeCredentials credentials) {
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
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      coreLibraryProbeProvider.overrideWithValue(
        const FixedCoreLibraryProbe(CoreLibraryAvailability.absent),
      ),
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      credentialsRepositoryProvider.overrideWithValue(credentials),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('SignInController.isPlausibleEmail', () {
    test('Given an address that could be real '
        'When it is checked '
        'Then it is accepted, because the API decides and not this client '
        '(FR-DA-15)', () {
      for (final email in [
        'someone@example.com',
        'a+tag@sub.domain.example',
        'x@y.z',
      ]) {
        expect(SignInController.isPlausibleEmail(email), isTrue, reason: email);
      }
    });

    test('Given something that cannot be an address '
        'When it is checked '
        'Then it is rejected in the form (UC-03 AF-01)', () {
      for (final email in [
        '',
        '   ',
        'someone',
        '@example.com',
        'a@',
        'a@b c',
      ]) {
        expect(
          SignInController.isPlausibleEmail(email),
          isFalse,
          reason: '"$email"',
        );
      }
    });
  });

  group('SignInController.submit', () {
    test(
      'Given a malformed address '
      'When it is submitted '
      'Then it is rejected and nothing reaches the API (UC-03 AF-01)',
      () async {
        final credentials = FakeCredentials(
          (_, _) =>
              Success(SignInGranted(token: tokenFor(), emailVerified: true)),
        );
        final container = containerWith(credentials);

        await container
            .read(signInControllerProvider.notifier)
            .submit(email: 'nonsense', password: 'secret');

        expect(container.read(signInControllerProvider), isA<SignInInvalid>());
        expect(credentials.submitted, isEmpty);
      },
    );

    test(
      'Given an empty password '
      'When it is submitted '
      'Then it is rejected and nothing reaches the API (UC-03 AF-01)',
      () async {
        final credentials = FakeCredentials(
          (_, _) =>
              Success(SignInGranted(token: tokenFor(), emailVerified: true)),
        );
        final container = containerWith(credentials);

        await container
            .read(signInControllerProvider.notifier)
            .submit(email: 'someone@example.com', password: '');

        expect(container.read(signInControllerProvider), isA<SignInInvalid>());
        expect(credentials.submitted, isEmpty);
      },
    );

    test(
      'Given valid credentials the API accepts '
      'When they are submitted '
      'Then a session is held and the token is stored (UC-03 main flow)',
      () async {
        final token = tokenFor(subject: 'owner-7');
        final container = containerWith(
          FakeCredentials(
            (_, _) => Success(SignInGranted(token: token, emailVerified: true)),
          ),
        );

        await container
            .read(signInControllerProvider.notifier)
            .submit(email: '  someone@example.com ', password: 'secret');

        expect(container.read(signInControllerProvider), isA<SignInDone>());

        final session = container.read(sessionProvider);
        expect(session, isA<SignedIn>());
        expect((session as SignedIn).subjectReference, 'owner-7');
        expect(session.isAuthenticated, isTrue);
        expect(await container.read(tokenStoreProvider).read(), token);
      },
    );

    test('Given an address with surrounding spaces '
        'When it is submitted '
        'Then the API receives it trimmed', () async {
      final credentials = FakeCredentials(
        (_, _) =>
            Success(SignInGranted(token: tokenFor(), emailVerified: true)),
      );
      final container = containerWith(credentials);

      await container
          .read(signInControllerProvider.notifier)
          .submit(email: '  someone@example.com  ', password: 'secret');

      expect(credentials.submitted.single.email, 'someone@example.com');
    });

    test('Given the API refuses the credentials '
        'When it answers '
        'Then its single message is shown and no cause is distinguished '
        '(UC-03 AF-02, FR-SE-23)', () async {
      const refusal =
          'That email address and password do not match an account.';
      final container = containerWith(
        FakeCredentials(
          (_, _) => const Failure(
            message: refusal,
            kind: FailureKind.unauthenticated,
          ),
        ),
      );

      await container
          .read(signInControllerProvider.notifier)
          .submit(email: 'someone@example.com', password: 'wrong');

      final state = container.read(signInControllerProvider);
      expect(state, isA<SignInRefused>());
      // Exactly what the API said, unaltered.
      expect(state.message, refusal);
      expect(container.read(sessionProvider).isAuthenticated, isFalse);
    });

    test(
      'Given the account has two-factor active '
      'When the API answers with a challenge '
      'Then the challenge is held and grants nothing (UC-03 AF-03, BR-19)',
      () async {
        final expiry = DateTime.now().add(const Duration(minutes: 5));
        final container = containerWith(
          FakeCredentials(
            (_, _) => Success(
              SignInChallenged(
                challengeToken: 'challenge-abc',
                methods: const ['authenticator', 'email'],
                expiresAt: expiry,
              ),
            ),
          ),
        );

        await container
            .read(signInControllerProvider.notifier)
            .submit(email: 'someone@example.com', password: 'secret');

        final session = container.read(sessionProvider);
        expect(session, isA<ChallengePending>());
        expect((session as ChallengePending).challengeToken, 'challenge-abc');
        expect(session.methods, ['authenticator', 'email']);
        // The whole point: a challenge is not a session.
        expect(session.isAuthenticated, isFalse);
        expect(await container.read(tokenStoreProvider).read(), isNull);
      },
    );

    test('Given the instance cannot be reached '
        'When credentials are submitted '
        'Then a lost connection is reported and a retry is possible '
        '(UC-03 AF-04)', () async {
      final container = containerWith(
        FakeCredentials(
          (_, _) => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await container
          .read(signInControllerProvider.notifier)
          .submit(email: 'someone@example.com', password: 'secret');

      final state = container.read(signInControllerProvider);
      expect(state, isA<SignInUnreachable>());
      expect(state.message, 'The instance could not be reached.');
    });

    test('Given the API refuses because the address is unverified '
        'When it answers '
        'Then its reason is shown and the verification path is offered '
        '(UC-03 AF-06)', () async {
      const reason = 'Verify your email address before signing in.';
      final container = containerWith(
        FakeCredentials(
          (_, _) => const Failure(message: reason, kind: FailureKind.forbidden),
        ),
      );

      await container
          .read(signInControllerProvider.notifier)
          .submit(email: 'someone@example.com', password: 'secret');

      final state = container.read(signInControllerProvider);
      expect(state, isA<SignInNeedsVerification>());
      expect(state.message, reason);
    });

    test(
      'Given a failed sign-in '
      'When it has been reported '
      'Then the session is signed out rather than left authenticating',
      () async {
        final container = containerWith(
          FakeCredentials(
            (_, _) => const Failure(
              message: 'No.',
              kind: FailureKind.unauthenticated,
            ),
          ),
        );

        await container
            .read(signInControllerProvider.notifier)
            .submit(email: 'someone@example.com', password: 'secret');

        expect(container.read(sessionProvider), isA<SignedOut>());
      },
    );

    test('Given the API issues a token this client cannot read '
        'When it is granted '
        'Then it is refused rather than half-accepted', () async {
      final container = containerWith(
        FakeCredentials(
          (_, _) => const Success(
            SignInGranted(token: 'not-a-jwt', emailVerified: true),
          ),
        ),
      );

      await container
          .read(signInControllerProvider.notifier)
          .submit(email: 'someone@example.com', password: 'secret');

      expect(container.read(signInControllerProvider), isA<SignInRefused>());
      expect(container.read(sessionProvider).isAuthenticated, isFalse);
      expect(await container.read(tokenStoreProvider).read(), isNull);
    });

    test('Given a rejection is showing '
        'When the user edits a field '
        'Then it clears so the correction is not masked', () async {
      final container = containerWith(
        FakeCredentials(
          (_, _) =>
              const Failure(message: 'No.', kind: FailureKind.unauthenticated),
        ),
      );
      final controller = container.read(signInControllerProvider.notifier);

      await controller.submit(email: 'someone@example.com', password: 'x');
      expect(container.read(signInControllerProvider), isA<SignInRefused>());

      controller.reset();
      expect(container.read(signInControllerProvider), isA<SignInReady>());
    });
  });
}

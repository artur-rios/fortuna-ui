import 'package:flutter/material.dart';
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
import 'package:fortuna_ui/features/auth/data/google_identity.dart';
import 'package:fortuna_ui/features/auth/state/sign_in_controller.dart';
import 'package:fortuna_ui/features/auth/ui/sign_in_screen.dart';

import 'sign_in_controller_test.dart' show FakeCredentials, tokenFor;

/// Answers as the platform sheet would, without one.
class FakeGoogle implements GoogleIdentityService {
  FakeGoogle(this.outcome);

  GoogleIdentityOutcome outcome;
  int attempts = 0;

  @override
  Future<GoogleIdentityOutcome> obtainIdToken() async {
    attempts++;
    return outcome;
  }
}

/// Builds the overrides these tests share.
///
/// Inlined at each use rather than returned from a helper: Riverpod's
/// `Override` is sealed and not exported, so a shared list cannot be typed.
ProviderContainer containerWith({
  required FakeCredentials credentials,
  GoogleIdentityService? google,
  String googleClientId = 'client-id.apps.googleusercontent.com',
}) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        AppConfig(
          apiBaseUrl: 'https://fortuna.example',
          googleClientId: googleClientId,
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
      if (google != null)
        googleIdentityServiceProvider.overrideWithValue(google),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpSignIn(
  WidgetTester tester, {
  required FakeCredentials credentials,
  GoogleIdentityService? google,
  String googleClientId = 'client-id.apps.googleusercontent.com',
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            apiBaseUrl: 'https://fortuna.example',
            googleClientId: googleClientId,
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
        if (google != null)
          googleIdentityServiceProvider.overrideWithValue(google),
      ],
      child: const MaterialApp(home: SignInScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('googleIdentityServiceProvider', () {
    test(
      'Given a build with no Google client configured '
      'When the service is asked for '
      'Then there is none, so the option cannot be offered (UC-05 AF-04)',
      () {
        final container = containerWith(
          credentials: FakeCredentials(
            (_, _) =>
                const Failure(message: 'x', kind: FailureKind.serverError),
          ),
          googleClientId: '',
        );

        expect(container.read(googleIdentityServiceProvider), isNull);
      },
    );

    test('Given a build carrying a Google client id '
        'When the service is asked for '
        'Then one exists', () {
      final container = containerWith(
        credentials: FakeCredentials(
          (_, _) => const Failure(message: 'x', kind: FailureKind.serverError),
        ),
      );

      expect(container.read(googleIdentityServiceProvider), isNotNull);
    });
  });

  group('SignInController.signInWithGoogle', () {
    test(
      'Given Google returns an ID token the API accepts '
      'When it is exchanged '
      'Then a session is held and the token stored (UC-05 main flow)',
      () async {
        final token = tokenFor(subject: 'google-owner');
        final credentials =
            FakeCredentials(
                (_, _) =>
                    const Failure(message: 'x', kind: FailureKind.serverError),
              )
              ..googleAnswer = (_) =>
                  Success(SignInGranted(token: token, emailVerified: true));

        final container = containerWith(
          credentials: credentials,
          google: FakeGoogle(const GoogleIdentityObtained('google-id-token')),
        );

        await container
            .read(signInControllerProvider.notifier)
            .signInWithGoogle();

        expect(container.read(signInControllerProvider), isA<SignInDone>());
        // FR-SE-22: exactly the token Google issued, submitted to the API and
        // nowhere else.
        expect(credentials.exchangedIdTokens, ['google-id-token']);

        final session = container.read(sessionProvider);
        expect(session, isA<SignedIn>());
        expect((session as SignedIn).subjectReference, 'google-owner');
        expect(await container.read(tokenStoreProvider).read(), token);
      },
    );

    test('Given the user closes the Google sheet '
        'When nothing comes of it '
        'Then the screen returns to ready with no error and nothing changed '
        '(UC-05 AF-01)', () async {
      final credentials = FakeCredentials(
        (_, _) => const Failure(message: 'x', kind: FailureKind.serverError),
      );
      final container = containerWith(
        credentials: credentials,
        google: FakeGoogle(const GoogleIdentityCancelled()),
      );

      await container
          .read(signInControllerProvider.notifier)
          .signInWithGoogle();

      final state = container.read(signInControllerProvider);
      expect(state, isA<SignInReady>());
      // The point of AF-01: a cancellation is never shown as a failure.
      expect(state.message, isNull);
      expect(credentials.exchangedIdTokens, isEmpty);
      expect(container.read(sessionProvider), isA<SignedOut>());
    });

    test(
      'Given Google returns no usable token '
      'When sign-in is attempted '
      'Then it is reported and nothing is sent to the API (UC-05 AF-02)',
      () async {
        final credentials = FakeCredentials(
          (_, _) => const Failure(message: 'x', kind: FailureKind.serverError),
        );
        final container = containerWith(
          credentials: credentials,
          google: FakeGoogle(
            const GoogleIdentityUnavailable(
              'Google did not return a usable sign-in token.',
            ),
          ),
        );

        await container
            .read(signInControllerProvider.notifier)
            .signInWithGoogle();

        final state = container.read(signInControllerProvider);
        expect(state, isA<SignInRefused>());
        expect(state.message, 'Google did not return a usable sign-in token.');
        expect(credentials.exchangedIdTokens, isEmpty);
      },
    );

    test('Given the API rejects the Google token '
        'When it answers '
        'Then its own reason is presented (UC-05 AF-03)', () async {
      const reason = 'That Google account is not permitted on this instance.';
      final credentials =
          FakeCredentials(
              (_, _) =>
                  const Failure(message: 'x', kind: FailureKind.serverError),
            )
            ..googleAnswer = (_) =>
                const Failure(message: reason, kind: FailureKind.forbidden);

      final container = containerWith(
        credentials: credentials,
        google: FakeGoogle(const GoogleIdentityObtained('google-id-token')),
      );

      await container
          .read(signInControllerProvider.notifier)
          .signInWithGoogle();

      final state = container.read(signInControllerProvider);
      expect(state, isA<SignInRefused>());
      expect(state.message, reason);
      expect(container.read(sessionProvider).isAuthenticated, isFalse);
    });

    test(
      'Given the account already has a password and will not be linked '
      'When the API refuses '
      'Then its reason stands and the credential path remains (UC-05 AF-05)',
      () async {
        const reason =
            'This address already has a password. Sign in with it instead.';
        final credentials =
            FakeCredentials(
                (_, _) =>
                    const Failure(message: 'x', kind: FailureKind.serverError),
              )
              ..googleAnswer = (_) =>
                  const Failure(message: reason, kind: FailureKind.conflict);

        final container = containerWith(
          credentials: credentials,
          google: FakeGoogle(const GoogleIdentityObtained('google-id-token')),
        );

        await container
            .read(signInControllerProvider.notifier)
            .signInWithGoogle();

        expect(container.read(signInControllerProvider).message, reason);
      },
    );

    test('Given a build that cannot offer Google sign-in '
        'When it is asked for anyway '
        'Then nothing happens (UC-05 AF-04)', () async {
      final credentials = FakeCredentials(
        (_, _) => const Failure(message: 'x', kind: FailureKind.serverError),
      );
      final container = containerWith(
        credentials: credentials,
        googleClientId: '',
      );

      await container
          .read(signInControllerProvider.notifier)
          .signInWithGoogle();

      expect(container.read(signInControllerProvider), isA<SignInReady>());
      expect(credentials.exchangedIdTokens, isEmpty);
    });
  });

  group('SignInScreen with Google', () {
    testWidgets('Given an instance with Google enabled '
        'When the screen is shown '
        'Then the Google option is offered', (tester) async {
      await pumpSignIn(
        tester,
        credentials: FakeCredentials(
          (_, _) => const Failure(message: 'x', kind: FailureKind.serverError),
        ),
        google: FakeGoogle(const GoogleIdentityCancelled()),
      );

      expect(find.byKey(const Key('signIn.google')), findsOneWidget);
    });

    testWidgets('Given an instance without Google enabled '
        'When the screen is shown '
        'Then the option is not offered at all (UC-05 AF-04)', (tester) async {
      await pumpSignIn(
        tester,
        credentials: FakeCredentials(
          (_, _) => const Failure(message: 'x', kind: FailureKind.serverError),
        ),
        googleClientId: '',
      );

      expect(find.byKey(const Key('signIn.google')), findsNothing);
      // The credential path is unaffected.
      expect(find.byKey(const Key('signIn.submit')), findsOneWidget);
    });

    testWidgets('Given the user cancels the Google sheet '
        'When it closes '
        'Then no error is shown and the credential path is still there '
        '(UC-05 AF-01)', (tester) async {
      await pumpSignIn(
        tester,
        credentials: FakeCredentials(
          (_, _) => const Failure(message: 'x', kind: FailureKind.serverError),
        ),
        google: FakeGoogle(const GoogleIdentityCancelled()),
      );

      await tester.tap(find.byKey(const Key('signIn.google')));
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsWidgets);
      expect(find.textContaining('could not'), findsNothing);
      expect(find.byKey(const Key('signIn.submit')), findsOneWidget);
    });
  });
}

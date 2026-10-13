import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/auth/data/credentials_repository.dart';
import 'package:fortuna_ui/features/auth/data/google_identity.dart';
import 'package:fortuna_ui/features/auth/data/registration_repository.dart';
import 'package:fortuna_ui/features/auth/state/sign_in_controller.dart';
import 'package:fortuna_ui/features/auth/ui/sign_up_screen.dart';

import 'google_sign_in_test.dart' show FakeGoogle;
import 'sign_in_controller_test.dart' show FakeCredentials, tokenFor;
import 'sign_up_controller_test.dart' show FakeRegistration;

Future<void> pumpSignUp(
  WidgetTester tester, {
  required RegistrationRepository registration,
  GoogleIdentityService? google,
  FakeCredentials? credentials,
  VoidCallback? onSignIn,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            apiBaseUrl: 'https://fortuna.example',
            googleClientId: google == null ? '' : 'client-id',
            transport: Transport.http,
            databasePath: '',
          ),
        ),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
        coreLibraryProbeProvider.overrideWithValue(
          const FixedCoreLibraryProbe(CoreLibraryAvailability.absent),
        ),
        tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
        registrationRepositoryProvider.overrideWithValue(registration),
        credentialsRepositoryProvider.overrideWithValue(
          credentials ??
              FakeCredentials(
                (_, _) => Success(
                  SignInGranted(token: tokenFor(), emailVerified: true),
                ),
              ),
        ),
        if (google != null)
          googleIdentityServiceProvider.overrideWithValue(google),
      ],
      child: MaterialApp(home: SignUpScreen(onSignIn: onSignIn)),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> fillForm(
  WidgetTester tester, {
  String name = 'New Person',
  String email = 'new@example.com',
  String password = 'a-long-secret',
}) async {
  await tester.enterText(find.byKey(const Key('signUp.name')), name);
  await tester.enterText(find.byKey(const Key('signUp.email')), email);
  await tester.enterText(find.byKey(const Key('signUp.password')), password);
}

void main() {
  sharedStateTests();

  group('SignUpScreen', () {
    testWidgets('Given the screen is shown '
        'When it settles '
        'Then the three fields and the submit action are offered, and no Google '
        'option where none is configured', (tester) async {
      await pumpSignUp(tester, registration: FakeRegistration());

      expect(find.byKey(const Key('signUp.name')), findsOneWidget);
      expect(find.byKey(const Key('signUp.email')), findsOneWidget);
      expect(find.byKey(const Key('signUp.password')), findsOneWidget);
      expect(find.byKey(const Key('signUp.submit')), findsOneWidget);
      expect(find.byKey(const Key('signUp.google')), findsNothing);
    });

    testWidgets('Given the password field '
        'When the screen is shown '
        'Then it is obscured until the user asks otherwise', (tester) async {
      await pumpSignUp(tester, registration: FakeRegistration());

      TextField password() =>
          tester.widget<TextField>(find.byKey(const Key('signUp.password')));

      expect(password().obscureText, isTrue);
      await tester.tap(find.byKey(const Key('signUp.reveal')));
      await tester.pumpAndSettle();
      expect(password().obscureText, isFalse);
    });

    testWidgets(
      'Given a short password '
      'When it is submitted '
      'Then the reason is shown under the password field and nothing is sent',
      (tester) async {
        final registration = FakeRegistration();
        await pumpSignUp(tester, registration: registration);

        await fillForm(tester, password: '1234567');
        await tester.tap(find.byKey(const Key('signUp.submit')));
        await tester.pumpAndSettle();

        final field = tester.widget<TextField>(
          find.byKey(const Key('signUp.password')),
        );
        expect(field.decoration!.errorText, contains('at least 8'));
        expect(registration.submitted, isEmpty);
      },
    );

    testWidgets(
      'Given the API accepts '
      'When the form is submitted '
      'Then the form is replaced by the API message and a way back to sign in',
      (tester) async {
        var backToSignIn = 0;
        await pumpSignUp(
          tester,
          registration: FakeRegistration(
            () => const Success('Check your email.'),
          ),
          onSignIn: () => backToSignIn++,
        );

        await fillForm(tester);
        await tester.tap(find.byKey(const Key('signUp.submit')));
        await tester.pumpAndSettle();

        expect(find.text('Check your email.'), findsOneWidget);
        expect(find.byKey(const Key('signUp.name')), findsNothing);
        await tester.tap(find.byKey(const Key('signUp.done')));
        expect(backToSignIn, 1);
      },
    );

    testWidgets('Given a closed instance '
        'When it answers '
        'Then its reason is shown and no retry is offered', (tester) async {
      await pumpSignUp(
        tester,
        registration: FakeRegistration(
          () => const Failure(
            message: 'This instance is not accepting new accounts.',
            kind: FailureKind.forbidden,
          ),
        ),
      );

      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('This instance is not accepting new accounts.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('signUp.retry')), findsNothing);
    });

    testWidgets('Given Heimdall is down '
        'When it answers '
        'Then a retry is offered and resubmits', (tester) async {
      final registration = FakeRegistration(
        () => const Failure(
          message: 'The identity service is temporarily unavailable.',
          kind: FailureKind.serverError,
        ),
      );
      await pumpSignUp(tester, registration: registration);

      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('signUp.retry')));
      await tester.pumpAndSettle();

      expect(registration.submitted, hasLength(2));
    });

    testWidgets('Given a request in flight '
        'When submit is tapped again '
        'Then only one request is sent', (tester) async {
      final pending = Completer<Result<String>>();
      final registration = _PendingRegistration(pending.future);
      await pumpSignUp(tester, registration: registration);

      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pump();
      await tester.tap(
        find.byKey(const Key('signUp.submit')),
        warnIfMissed: false,
      );
      await tester.pump();

      expect(registration.calls, 1);
      pending.complete(const Success('Check your email.'));
      await tester.pumpAndSettle();
    });

    testWidgets('Given Google is configured '
        'When "Continue with Google" is tapped '
        'Then the existing Google exchange runs', (tester) async {
      final google = FakeGoogle(const GoogleIdentityObtained('id-token'));
      final credentials =
          FakeCredentials(
              (_, _) => Success(
                SignInGranted(token: tokenFor(), emailVerified: true),
              ),
            )
            ..googleAnswer = (_) =>
                Success(SignInGranted(token: tokenFor(), emailVerified: true));
      await pumpSignUp(
        tester,
        registration: FakeRegistration(),
        google: google,
        credentials: credentials,
      );

      await tester.tap(find.byKey(const Key('signUp.google')));
      await tester.pumpAndSettle();

      expect(google.attempts, 1);
      expect(credentials.exchangedIdTokens, ['id-token']);
    });

    testWidgets('Given "Already have an account?" '
        'When it is tapped '
        'Then the screen asks to go to sign in', (tester) async {
      var backToSignIn = 0;
      await pumpSignUp(
        tester,
        registration: FakeRegistration(),
        onSignIn: () => backToSignIn++,
      );

      await tester.tap(find.byKey(const Key('signUp.signIn')));

      expect(backToSignIn, 1);
    });
  });
}

/// The overrides a sign-up screen needs, for tests that keep one container
/// across several screens.
List<Override> _overridesFor({
  required RegistrationRepository registration,
  GoogleIdentityService? google,
  FakeCredentials? credentials,
}) => [
  appConfigProvider.overrideWithValue(
    AppConfig(
      apiBaseUrl: 'https://fortuna.example',
      googleClientId: google == null ? '' : 'client-id',
      transport: Transport.http,
      databasePath: '',
    ),
  ),
  preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
  coreLibraryProbeProvider.overrideWithValue(
    const FixedCoreLibraryProbe(CoreLibraryAvailability.absent),
  ),
  tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
  registrationRepositoryProvider.overrideWithValue(registration),
  credentialsRepositoryProvider.overrideWithValue(
    credentials ??
        FakeCredentials(
          (_, _) =>
              Success(SignInGranted(token: tokenFor(), emailVerified: true)),
        ),
  ),
  if (google != null) googleIdentityServiceProvider.overrideWithValue(google),
];

Future<void> pumpIn(
  WidgetTester tester,
  ProviderContainer container,
  Widget home,
) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: home),
    ),
  );
  await tester.pumpAndSettle();
}

void sharedStateTests() {
  group('SignUpScreen and the controllers it shares', () {
    testWidgets('Given a refused sign-in left in the sign-in controller '
        'When the sign-up screen is opened '
        'Then that sign-in error is not shown on it', (tester) async {
      const reason = 'Those credentials were not accepted.';
      final container = ProviderContainer(
        overrides: _overridesFor(
          registration: FakeRegistration(),
          credentials: FakeCredentials(
            (_, _) => const Failure(
              message: reason,
              kind: FailureKind.unauthenticated,
            ),
          ),
        ),
      );
      addTearDown(container.dispose);
      await container
          .read(signInControllerProvider.notifier)
          .submit(email: 'a@example.com', password: 'a-long-secret');
      expect(container.read(signInControllerProvider), isA<SignInRefused>());

      await pumpIn(tester, container, const SignUpScreen());

      expect(find.text(reason), findsNothing);
      expect(container.read(signInControllerProvider).message, isNull);
    });

    testWidgets('Given Google is configured and its exchange fails '
        'When the user goes back to sign in '
        'Then the failure is not carried over to the sign-in screen', (
      tester,
    ) async {
      const reason = 'Google is not available right now.';
      final container = ProviderContainer(
        overrides: _overridesFor(
          registration: FakeRegistration(),
          google: FakeGoogle(const GoogleIdentityUnavailable(reason)),
        ),
      );
      addTearDown(container.dispose);
      var backToSignIn = 0;
      await pumpIn(
        tester,
        container,
        SignUpScreen(onSignIn: () => backToSignIn++),
      );

      await tester.tap(find.byKey(const Key('signUp.google')));
      await tester.pumpAndSettle();
      expect(find.text(reason), findsOneWidget);

      await tester.tap(find.byKey(const Key('signUp.signIn')));

      expect(backToSignIn, 1);
      expect(container.read(signInControllerProvider).message, isNull);
    });

    testWidgets('Given an accepted sign-up '
        'When the sign-up screen is opened again '
        'Then it shows the empty form, not the old acceptance', (tester) async {
      final container = ProviderContainer(
        overrides: _overridesFor(
          registration: FakeRegistration(
            () => const Success('Check your email.'),
          ),
        ),
      );
      addTearDown(container.dispose);
      await pumpIn(tester, container, SignUpScreen(onSignIn: () {}));
      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('signUp.done')), findsOneWidget);

      await pumpIn(tester, container, const SizedBox());
      await pumpIn(tester, container, SignUpScreen(onSignIn: () {}));

      expect(find.byKey(const Key('signUp.done')), findsNothing);
      expect(find.byKey(const Key('signUp.name')), findsOneWidget);
      expect(find.text('Check your email.'), findsNothing);
    });
  });
}

/// Holds its answer until the test releases it, counting calls meanwhile.
class _PendingRegistration implements RegistrationRepository {
  _PendingRegistration(this.answer);

  final Future<Result<String>> answer;
  int calls = 0;

  @override
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  }) {
    calls++;
    return answer;
  }
}

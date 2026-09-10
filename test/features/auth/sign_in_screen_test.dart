import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/auth/data/credentials_repository.dart';
import 'package:fortuna_ui/features/auth/ui/sign_in_screen.dart';

import 'sign_in_controller_test.dart' show FakeCredentials, tokenFor;

Future<void> pumpSignIn(
  WidgetTester tester,
  FakeCredentials credentials,
) async {
  await tester.pumpWidget(
    ProviderScope(
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
      child: const MaterialApp(home: SignInScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> enterCredentials(
  WidgetTester tester, {
  String email = 'someone@example.com',
  String password = 'secret',
}) async {
  await tester.enterText(find.byKey(const Key('signIn.email')), email);
  await tester.enterText(find.byKey(const Key('signIn.password')), password);
}

void main() {
  group('SignInScreen', () {
    testWidgets('Given the screen is shown '
        'When it settles '
        'Then both credential fields and the submit action are offered', (
      tester,
    ) async {
      await pumpSignIn(
        tester,
        FakeCredentials(
          (_, _) =>
              Success(SignInGranted(token: tokenFor(), emailVerified: true)),
        ),
      );

      expect(find.byKey(const Key('signIn.email')), findsOneWidget);
      expect(find.byKey(const Key('signIn.password')), findsOneWidget);
      expect(find.byKey(const Key('signIn.submit')), findsOneWidget);
    });

    testWidgets('Given the password field '
        'When the screen is shown '
        'Then it is obscured until the user asks otherwise', (tester) async {
      await pumpSignIn(
        tester,
        FakeCredentials(
          (_, _) =>
              Success(SignInGranted(token: tokenFor(), emailVerified: true)),
        ),
      );

      TextField password() =>
          tester.widget<TextField>(find.byKey(const Key('signIn.password')));

      expect(password().obscureText, isTrue);

      await tester.tap(find.byKey(const Key('signIn.reveal')));
      await tester.pumpAndSettle();

      expect(password().obscureText, isFalse);
    });

    testWidgets('Given a malformed address '
        'When it is submitted '
        'Then the form says so and nothing reaches the API (UC-03 AF-01)', (
      tester,
    ) async {
      final credentials = FakeCredentials(
        (_, _) =>
            Success(SignInGranted(token: tokenFor(), emailVerified: true)),
      );
      await pumpSignIn(tester, credentials);

      await enterCredentials(tester, email: 'nonsense');
      await tester.tap(find.byKey(const Key('signIn.submit')));
      await tester.pumpAndSettle();

      expect(find.textContaining('email address for your account'), findsOne);
      expect(credentials.submitted, isEmpty);
    });

    testWidgets('Given the API refuses '
        'When it answers '
        'Then its own message is shown and no retry is offered '
        '(UC-03 AF-02)', (tester) async {
      await pumpSignIn(
        tester,
        FakeCredentials(
          (_, _) => const Failure(
            message: 'That email address and password do not match an account.',
            kind: FailureKind.unauthenticated,
          ),
        ),
      );

      await enterCredentials(tester);
      await tester.tap(find.byKey(const Key('signIn.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('That email address and password do not match an account.'),
        findsOneWidget,
      );
      // A retry would just invite the same refusal.
      expect(find.byKey(const Key('signIn.retry')), findsNothing);
    });

    testWidgets('Given the instance cannot be reached '
        'When credentials are submitted '
        'Then a retry is offered (UC-03 AF-04)', (tester) async {
      await pumpSignIn(
        tester,
        FakeCredentials(
          (_, _) => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await enterCredentials(tester);
      await tester.tap(find.byKey(const Key('signIn.submit')));
      await tester.pumpAndSettle();

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.byKey(const Key('signIn.retry')), findsOneWidget);
    });

    testWidgets('Given the address is unverified '
        'When the API refuses on it '
        'Then the verification path is offered alongside the reason '
        '(UC-03 AF-06)', (tester) async {
      await pumpSignIn(
        tester,
        FakeCredentials(
          (_, _) => const Failure(
            message: 'Verify your email address before signing in.',
            kind: FailureKind.forbidden,
          ),
        ),
      );

      await enterCredentials(tester);
      await tester.tap(find.byKey(const Key('signIn.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('Verify your email address before signing in.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('signIn.verify')), findsOneWidget);
    });

    testWidgets('Given credentials have been typed '
        'When the screen goes away '
        'Then the fields are cleared (UC-03 AF-05)', (tester) async {
      final email = TextEditingController();
      final password = TextEditingController();
      addTearDown(email.dispose);
      addTearDown(password.dispose);

      await pumpSignIn(
        tester,
        FakeCredentials(
          (_, _) =>
              Success(SignInGranted(token: tokenFor(), emailVerified: true)),
        ),
      );
      await enterCredentials(tester);

      // Capture the live controllers before the screen is torn down.
      final fields = tester
          .widgetList<TextField>(find.byType(TextField))
          .map((field) => field.controller!)
          .toList();
      expect(fields.map((c) => c.text), isNot(everyElement(isEmpty)));

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pumpAndSettle();

      expect(fields.map((c) => c.text), everyElement(isEmpty));
    });
  });
}

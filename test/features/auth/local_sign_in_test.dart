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
import 'package:fortuna_ui/features/auth/data/local_account_repository.dart';
import 'package:fortuna_ui/features/auth/state/local_sign_in_controller.dart';
import 'package:fortuna_ui/features/auth/ui/local_sign_in_screen.dart';

import 'sign_in_controller_test.dart' show tokenFor;

class FakeLocalAccounts implements LocalAccountRepository {
  FakeLocalAccounts({this.onAuthenticate});

  Result<String> Function(String name, String secret)? onAuthenticate;
  final List<({String name, String secret})> attempts = [];

  @override
  Future<Result<CreatedLocalAccount>> create({
    required String displayName,
    required String secret,
  }) async =>
      const Failure(message: 'not used here', kind: FailureKind.serverError);

  @override
  Future<Result<String>> authenticate({
    required String name,
    required String secret,
  }) async {
    attempts.add((name: name, secret: secret));
    return onAuthenticate?.call(name, secret) ??
        const Failure(message: 'no answer', kind: FailureKind.serverError);
  }
}

ProviderContainer containerWith(FakeLocalAccounts repository) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        const AppConfig(
          apiBaseUrl: '',
          googleClientId: '',
          transport: Transport.ffi,
          databasePath: '',
        ),
      ),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      coreLibraryProbeProvider.overrideWithValue(
        const FixedCoreLibraryProbe(CoreLibraryAvailability.available),
      ),
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      localAccountRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpScreen(
  WidgetTester tester,
  FakeLocalAccounts repository, {
  bool accountExists = true,
  VoidCallback? onRecover,
  VoidCallback? onCreateAccount,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(
            apiBaseUrl: '',
            googleClientId: '',
            transport: Transport.ffi,
            databasePath: '',
          ),
        ),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
        coreLibraryProbeProvider.overrideWithValue(
          const FixedCoreLibraryProbe(CoreLibraryAvailability.available),
        ),
        tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
        localAccountRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        home: LocalSignInScreen(
          accountExists: accountExists,
          onRecover: onRecover,
          onCreateAccount: onCreateAccount,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('LocalSignInController.submit', () {
    test(
      'Given an empty field '
      'When it is submitted '
      'Then it is rejected and nothing reaches the core (UC-07 AF-01)',
      () async {
        final repository = FakeLocalAccounts();
        final container = containerWith(repository);
        final controller = container.read(
          localSignInControllerProvider.notifier,
        );

        await controller.submit(name: '  ', secret: 'secret');
        expect(
          container.read(localSignInControllerProvider),
          isA<LocalSignInInvalid>(),
        );

        await controller.submit(name: 'Local User', secret: '');
        expect(
          container.read(localSignInControllerProvider),
          isA<LocalSignInInvalid>(),
        );

        expect(repository.attempts, isEmpty);
      },
    );

    test('Given correct credentials '
        'When the core authenticates them '
        'Then a session is held carrying the account owner role '
        '(UC-07 main flow)', () async {
      final token = tokenFor(subject: 'local-1');
      final container = containerWith(
        FakeLocalAccounts(onAuthenticate: (_, _) => Success(token)),
      );

      await container
          .read(localSignInControllerProvider.notifier)
          .submit(name: '  Local User  ', secret: 'secret');

      expect(
        container.read(localSignInControllerProvider),
        isA<LocalSignInDone>(),
      );

      final session = container.read(sessionProvider);
      expect(session, isA<SignedIn>());
      // Step 4: always the account owner. There is no administrator offline.
      expect((session as SignedIn).role, Role.accountOwner);
      expect(session.mode, AppMode.desktopOffline);
      expect(await container.read(tokenStoreProvider).read(), token);
    });

    test('Given a token issued for the administrator role '
        'When a local session is granted '
        'Then it still carries the account owner role (UC-07 step 4)', () async {
      // The core has no administrator to issue, but the client must not depend
      // on that: offline, the role is a property of the mode.
      final container = containerWith(
        FakeLocalAccounts(onAuthenticate: (_, _) => Success(tokenFor(role: 2))),
      );

      await container
          .read(localSignInControllerProvider.notifier)
          .submit(name: 'Local User', secret: 'secret');

      final session = container.read(sessionProvider) as SignedIn;
      expect(session.role, Role.accountOwner);
    });

    test('Given wrong credentials '
        'When the core refuses '
        'Then its single message is shown for name and secret alike '
        '(UC-07 AF-02)', () async {
      const refusal = 'That name and secret do not match a local account.';
      final container = containerWith(
        FakeLocalAccounts(
          onAuthenticate: (_, _) => const Failure(
            message: refusal,
            kind: FailureKind.unauthenticated,
          ),
        ),
      );

      await container
          .read(localSignInControllerProvider.notifier)
          .submit(name: 'Local User', secret: 'wrong');

      final state = container.read(localSignInControllerProvider);
      expect(state, isA<LocalSignInRefused>());
      expect(state.message, refusal);
      expect(container.read(sessionProvider).isAuthenticated, isFalse);
    });

    test('Given the core cannot be reached or initialized '
        'When sign-in is attempted '
        'Then the installation is reported unusable rather than the '
        'credentials blamed (UC-07 AF-05)', () async {
      for (final kind in [FailureKind.unreachable, FailureKind.serverError]) {
        final container = containerWith(
          FakeLocalAccounts(
            onAuthenticate: (_, _) => Failure(
              message: 'The Fortuna core could not be loaded.',
              kind: kind,
            ),
          ),
        );

        await container
            .read(localSignInControllerProvider.notifier)
            .submit(name: 'Local User', secret: 'secret');

        expect(
          container.read(localSignInControllerProvider),
          isA<LocalSignInUnusable>(),
          reason: '$kind should read as a broken installation',
        );
      }
    });

    test('Given the core issues a token this client cannot read '
        'When it is granted '
        'Then no session is held', () async {
      final container = containerWith(
        FakeLocalAccounts(onAuthenticate: (_, _) => const Success('not-a-jwt')),
      );

      await container
          .read(localSignInControllerProvider.notifier)
          .submit(name: 'Local User', secret: 'secret');

      expect(
        container.read(localSignInControllerProvider),
        isA<LocalSignInUnusable>(),
      );
      expect(container.read(sessionProvider).isAuthenticated, isFalse);
      expect(await container.read(tokenStoreProvider).read(), isNull);
    });
  });

  group('LocalSignInScreen', () {
    testWidgets('Given a desktop offline installation '
        'When sign-in is shown '
        'Then no identity-provider path is offered (UC-07 main flow step 1)', (
      tester,
    ) async {
      await pumpScreen(tester, FakeLocalAccounts());

      expect(find.byKey(const Key('localSignIn.name')), findsOneWidget);
      // Not hidden — absent. There is no network to reach either through.
      expect(find.textContaining('Google'), findsNothing);
      expect(find.textContaining('Email address'), findsNothing);
    });

    testWidgets('Given the user asks to reset the secret '
        'When there is no reset to give '
        'Then the reason is explained and recovery is offered '
        '(UC-07 AF-03, FR-SE-09)', (tester) async {
      var recovered = false;
      await pumpScreen(
        tester,
        FakeLocalAccounts(),
        onRecover: () => recovered = true,
      );

      await tester.tap(find.byKey(const Key('localSignIn.forgot')));
      await tester.pumpAndSettle();

      expect(find.textContaining('no such channel'), findsOneWidget);
      expect(find.byKey(const Key('localSignIn.resetRecover')), findsOneWidget);

      await tester.tap(find.byKey(const Key('localSignIn.resetRecover')));
      await tester.pumpAndSettle();

      expect(recovered, isTrue);
    });

    testWidgets('Given no local account exists '
        'When sign-in is shown '
        'Then creation is offered instead (UC-07 AF-04)', (tester) async {
      var creating = false;
      await pumpScreen(
        tester,
        FakeLocalAccounts(),
        accountExists: false,
        onCreateAccount: () => creating = true,
      );

      expect(find.byKey(const Key('localSignIn.submit')), findsNothing);
      expect(find.byKey(const Key('localSignIn.create')), findsOneWidget);

      await tester.tap(find.byKey(const Key('localSignIn.create')));
      await tester.pumpAndSettle();

      expect(creating, isTrue);
    });

    testWidgets('Given the core refuses the credentials '
        'When it answers '
        'Then its message is shown (UC-07 AF-02)', (tester) async {
      await pumpScreen(
        tester,
        FakeLocalAccounts(
          onAuthenticate: (_, _) => const Failure(
            message: 'That name and secret do not match a local account.',
            kind: FailureKind.unauthenticated,
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('localSignIn.name')),
        'Local User',
      );
      await tester.enterText(
        find.byKey(const Key('localSignIn.secret')),
        'wrong',
      );
      await tester.tap(find.byKey(const Key('localSignIn.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('That name and secret do not match a local account.'),
        findsOneWidget,
      );
    });
  });
}

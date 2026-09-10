import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/auth/data/local_account_repository.dart';
import 'package:fortuna_ui/features/auth/state/local_account_controller.dart';
import 'package:fortuna_ui/features/auth/ui/create_local_account_screen.dart';

class FakeLocalAccounts implements LocalAccountRepository {
  FakeLocalAccounts(this.answer);

  Result<CreatedLocalAccount> Function(String displayName, String secret)
  answer;
  final List<({String displayName, String secret})> created = [];

  @override
  Future<Result<CreatedLocalAccount>> create({
    required String displayName,
    required String secret,
  }) async {
    created.add((displayName: displayName, secret: secret));
    return answer(displayName, secret);
  }

  @override
  Future<Result<String>> authenticate({
    required String name,
    required String secret,
  }) async =>
      const Failure(message: 'not used here', kind: FailureKind.serverError);
}

const _codes = ['AAAA-1111', 'BBBB-2222', 'CCCC-3333'];

Result<CreatedLocalAccount> createdOk([String? warning]) => Success(
  CreatedLocalAccount(
    displayName: 'Local User',
    recoveryCodes: _codes,
    warning: warning,
  ),
);

ProviderContainer containerWith(
  FakeLocalAccounts repository, {
  Transport transport = Transport.ffi,
  CoreLibraryAvailability core = CoreLibraryAvailability.available,
}) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        AppConfig(
          apiBaseUrl: '',
          googleClientId: '',
          transport: transport,
          databasePath: '',
        ),
      ),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      coreLibraryProbeProvider.overrideWithValue(FixedCoreLibraryProbe(core)),
      localAccountRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpScreen(
  WidgetTester tester,
  FakeLocalAccounts repository, {
  VoidCallback? onFinished,
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
        localAccountRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        home: CreateLocalAccountScreen(onFinished: onFinished),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('LocalAccountController.create', () {
    test(
      'Given a missing name '
      'When creation is attempted '
      'Then it is rejected and nothing reaches the core (UC-06 AF-01)',
      () async {
        final repository = FakeLocalAccounts((_, _) => createdOk());
        final container = containerWith(repository);

        await container
            .read(localAccountControllerProvider.notifier)
            .create(displayName: '   ', secret: 'secret');

        expect(
          container.read(localAccountControllerProvider),
          isA<LocalAccountInvalid>(),
        );
        expect(repository.created, isEmpty);
      },
    );

    test(
      'Given a missing secret '
      'When creation is attempted '
      'Then it is rejected and nothing reaches the core (UC-06 AF-01)',
      () async {
        final repository = FakeLocalAccounts((_, _) => createdOk());
        final container = containerWith(repository);

        await container
            .read(localAccountControllerProvider.notifier)
            .create(displayName: 'Local User', secret: '');

        expect(
          container.read(localAccountControllerProvider),
          isA<LocalAccountInvalid>(),
        );
        expect(repository.created, isEmpty);
      },
    );

    test('Given a name and a secret '
        'When the core creates the account '
        'Then the recovery codes are presented (UC-06 main flow)', () async {
      final repository = FakeLocalAccounts((_, _) => createdOk());
      final container = containerWith(repository);

      await container
          .read(localAccountControllerProvider.notifier)
          .create(displayName: '  Local User  ', secret: 'secret');

      final state = container.read(localAccountControllerProvider);
      expect(state, isA<LocalAccountCodesShown>());
      expect((state as LocalAccountCodesShown).account.recoveryCodes, _codes);
      expect(repository.created.single.displayName, 'Local User');
    });

    test('Given a local account already exists '
        'When creation is attempted '
        "Then the core's reason is presented (UC-06 AF-02)", () async {
      const reason = 'This installation already has a local account.';
      final container = containerWith(
        FakeLocalAccounts(
          (_, _) => const Failure(message: reason, kind: FailureKind.conflict),
        ),
      );

      await container
          .read(localAccountControllerProvider.notifier)
          .create(displayName: 'Local User', secret: 'secret');

      final state = container.read(localAccountControllerProvider);
      expect(state, isA<LocalAccountRefused>());
      expect(state.message, reason);
    });

    test('Given the credential store is unavailable '
        'When creation is attempted '
        'Then the reason is presented and no account is left half-made '
        '(UC-06 AF-03)', () async {
      const reason = 'The credential store could not be opened.';
      final container = containerWith(
        FakeLocalAccounts(
          (_, _) =>
              const Failure(message: reason, kind: FailureKind.serverError),
        ),
      );

      await container
          .read(localAccountControllerProvider.notifier)
          .create(displayName: 'Local User', secret: 'secret');

      final state = container.read(localAccountControllerProvider);
      expect(state, isA<LocalAccountRefused>());
      expect(state.message, reason);
      // Nothing is shown that would imply an account exists.
      expect(state, isNot(isA<LocalAccountCodesShown>()));
    });

    test('Given local accounts are disabled in this installation '
        'When creation is attempted '
        "Then the core's reason is stated (UC-06 AF-05)", () async {
      const reason = 'Local accounts are disabled in this installation.';
      final container = containerWith(
        FakeLocalAccounts(
          (_, _) => const Failure(message: reason, kind: FailureKind.forbidden),
        ),
      );

      await container
          .read(localAccountControllerProvider.notifier)
          .create(displayName: 'Local User', secret: 'secret');

      expect(container.read(localAccountControllerProvider).message, reason);
    });

    test('Given an installation that is not in desktop offline mode '
        'When creation is attempted '
        'Then it is not offered, and the reason says why', () async {
      final repository = FakeLocalAccounts((_, _) => createdOk());
      final container = containerWith(
        repository,
        transport: Transport.http,
        core: CoreLibraryAvailability.absent,
      );

      await container
          .read(localAccountControllerProvider.notifier)
          .create(displayName: 'Local User', secret: 'secret');

      expect(
        container.read(localAccountControllerProvider),
        isA<LocalAccountUnavailable>(),
      );
      expect(repository.created, isEmpty);
    });

    test('Given the core reports success but issues no recovery codes '
        'When it answers '
        'Then it is treated as a failure rather than an empty list', () async {
      final container = containerWith(
        FakeLocalAccounts(
          (_, _) => const Failure(
            message: 'The account was not created with recovery codes.',
            kind: FailureKind.serverError,
          ),
        ),
      );

      await container
          .read(localAccountControllerProvider.notifier)
          .create(displayName: 'Local User', secret: 'secret');

      expect(
        container.read(localAccountControllerProvider),
        isA<LocalAccountRefused>(),
      );
    });
  });

  group('LocalAccountController.confirmCodesKept', () {
    test('Given the codes are showing '
        'When the user confirms they kept them '
        'Then the flow proceeds to sign-in (UC-06 main flow step 6)', () async {
      final container = containerWith(FakeLocalAccounts((_, _) => createdOk()));
      final controller = container.read(
        localAccountControllerProvider.notifier,
      );

      await controller.create(displayName: 'Local User', secret: 'secret');
      controller.confirmCodesKept();

      expect(
        container.read(localAccountControllerProvider),
        isA<LocalAccountConfirmed>(),
      );
    });

    test('Given no codes have been issued '
        'When confirmation is attempted '
        'Then nothing happens', () {
      final container = containerWith(FakeLocalAccounts((_, _) => createdOk()));

      container
          .read(localAccountControllerProvider.notifier)
          .confirmCodesKept();

      expect(
        container.read(localAccountControllerProvider),
        isA<LocalAccountReady>(),
      );
    });
  });

  group('CreateLocalAccountScreen', () {
    testWidgets('Given the account is created '
        'When the core answers '
        'Then every recovery code is shown with what losing them costs '
        '(UC-06 main flow step 5)', (tester) async {
      await pumpScreen(tester, FakeLocalAccounts((_, _) => createdOk()));

      await tester.enterText(
        find.byKey(const Key('localAccount.name')),
        'Local User',
      );
      await tester.enterText(
        find.byKey(const Key('localAccount.secret')),
        'secret',
      );
      await tester.tap(find.byKey(const Key('localAccount.create')));
      await tester.pumpAndSettle();

      for (final code in _codes) {
        expect(find.textContaining(code), findsOneWidget);
      }
      expect(find.textContaining('shown once'), findsOneWidget);
    });

    testWidgets('Given the core sent its own warning '
        'When the codes are shown '
        'Then its wording is used rather than this client\'s', (tester) async {
      const warning = 'Lose these and the account is unrecoverable.';
      await pumpScreen(tester, FakeLocalAccounts((_, _) => createdOk(warning)));

      await tester.enterText(
        find.byKey(const Key('localAccount.name')),
        'Local User',
      );
      await tester.enterText(
        find.byKey(const Key('localAccount.secret')),
        'secret',
      );
      await tester.tap(find.byKey(const Key('localAccount.create')));
      await tester.pumpAndSettle();

      expect(find.text(warning), findsOneWidget);
    });

    testWidgets('Given the codes are showing '
        'When the user has not confirmed keeping them '
        'Then continuing is not possible', (tester) async {
      await pumpScreen(tester, FakeLocalAccounts((_, _) => createdOk()));

      await tester.enterText(
        find.byKey(const Key('localAccount.name')),
        'Local User',
      );
      await tester.enterText(
        find.byKey(const Key('localAccount.secret')),
        'secret',
      );
      await tester.tap(find.byKey(const Key('localAccount.create')));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.byKey(const Key('localAccount.continue')),
      );
      expect(button.onPressed, isNull);

      await tester.tap(find.byKey(const Key('localAccount.kept')));
      await tester.pumpAndSettle();

      final enabled = tester.widget<FilledButton>(
        find.byKey(const Key('localAccount.continue')),
      );
      expect(enabled.onPressed, isNotNull);
    });

    testWidgets('Given the codes are showing '
        'When the user confirms and continues '
        'Then the screen reports it is finished', (tester) async {
      var finished = false;
      await pumpScreen(
        tester,
        FakeLocalAccounts((_, _) => createdOk()),
        onFinished: () => finished = true,
      );

      await tester.enterText(
        find.byKey(const Key('localAccount.name')),
        'Local User',
      );
      await tester.enterText(
        find.byKey(const Key('localAccount.secret')),
        'secret',
      );
      await tester.tap(find.byKey(const Key('localAccount.create')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('localAccount.kept')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('localAccount.continue')));
      await tester.pumpAndSettle();

      expect(finished, isTrue);
    });

    testWidgets('Given the codes are showing '
        'When the user tries to leave '
        'Then they are warned the codes will not be shown again '
        '(UC-06 AF-04)', (tester) async {
      await pumpScreen(tester, FakeLocalAccounts((_, _) => createdOk()));

      await tester.enterText(
        find.byKey(const Key('localAccount.name')),
        'Local User',
      );
      await tester.enterText(
        find.byKey(const Key('localAccount.secret')),
        'secret',
      );
      await tester.tap(find.byKey(const Key('localAccount.create')));
      await tester.pumpAndSettle();

      // The system back gesture, which is what a user actually does.
      final popped = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(popped, isTrue);
      expect(find.textContaining('will not be shown again'), findsOneWidget);
      expect(find.byKey(const Key('localAccount.stay')), findsOneWidget);
    });

    testWidgets('Given the form is showing '
        'When the user leaves '
        'Then nothing warns them, because there is nothing to lose', (
      tester,
    ) async {
      await pumpScreen(tester, FakeLocalAccounts((_, _) => createdOk()));

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.textContaining('will not be shown again'), findsNothing);
    });
  });
}

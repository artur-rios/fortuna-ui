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
import 'package:fortuna_ui/features/auth/state/local_recovery_controller.dart';
import 'package:fortuna_ui/features/auth/ui/local_recovery_screen.dart';

import 'sign_in_controller_test.dart' show tokenFor;

class FakeLocalAccounts implements LocalAccountRepository {
  FakeLocalAccounts({this.onRecover, this.onRegenerate});

  Result<RecoveredLocalAccount> Function(
    String name,
    String code,
    String newSecret,
  )?
  onRecover;
  Result<CreatedLocalAccount> Function(String secret)? onRegenerate;

  final List<({String name, String code, String newSecret})> recoveries = [];
  final List<String> regenerations = [];

  @override
  Future<Result<CreatedLocalAccount>> create({
    required String displayName,
    required String secret,
  }) async => const Failure(message: 'n/a', kind: FailureKind.serverError);

  @override
  Future<Result<String>> authenticate({
    required String name,
    required String secret,
  }) async => const Failure(message: 'n/a', kind: FailureKind.serverError);

  @override
  Future<Result<RecoveredLocalAccount>> recover({
    required String name,
    required String recoveryCode,
    required String newSecret,
  }) async {
    recoveries.add((name: name, code: recoveryCode, newSecret: newSecret));
    return onRecover?.call(name, recoveryCode, newSecret) ??
        const Failure(message: 'n/a', kind: FailureKind.unauthenticated);
  }

  @override
  Future<Result<CreatedLocalAccount>> regenerateRecoveryCodes({
    required String secret,
  }) async {
    regenerations.add(secret);
    return onRegenerate?.call(secret) ??
        const Failure(message: 'n/a', kind: FailureKind.serverError);
  }
}

Result<RecoveredLocalAccount> recovered({int remaining = 4}) => Success(
  RecoveredLocalAccount(
    token: tokenFor(subject: 'local-1'),
    remainingRecoveryCodes: remaining,
  ),
);

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
  FakeLocalAccounts repository,
) async {
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
      child: const MaterialApp(home: LocalRecoveryScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> submitRecovery(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('recovery.name')), 'Local User');
  await tester.enterText(find.byKey(const Key('recovery.code')), 'AAAA-1111');
  await tester.enterText(
    find.byKey(const Key('recovery.secret')),
    'new-secret',
  );
  await tester.tap(find.byKey(const Key('recovery.submit')));
  await tester.pumpAndSettle();
}

void main() {
  group('LocalRecoveryController.recover', () {
    test('Given an empty field '
        'When recovery is attempted '
        'Then it is rejected and nothing reaches the core', () async {
      final repository = FakeLocalAccounts();
      final container = containerWith(repository);
      final controller = container.read(
        localRecoveryControllerProvider.notifier,
      );

      await controller.recover(name: '', recoveryCode: 'c', newSecret: 's');
      expect(
        container.read(localRecoveryControllerProvider),
        isA<LocalRecoveryInvalid>(),
      );

      await controller.recover(name: 'n', recoveryCode: ' ', newSecret: 's');
      expect(
        container.read(localRecoveryControllerProvider),
        isA<LocalRecoveryInvalid>(),
      );

      await controller.recover(name: 'n', recoveryCode: 'c', newSecret: '');
      expect(
        container.read(localRecoveryControllerProvider),
        isA<LocalRecoveryInvalid>(),
      );

      expect(repository.recoveries, isEmpty);
    });

    test('Given a valid recovery code '
        'When it is accepted '
        'Then a session is held and the remaining count is reported '
        '(UC-08 main flow, step 4)', () async {
      final container = containerWith(
        FakeLocalAccounts(onRecover: (_, _, _) => recovered(remaining: 4)),
      );

      await container
          .read(localRecoveryControllerProvider.notifier)
          .recover(
            name: 'Local User',
            recoveryCode: 'AAAA-1111',
            newSecret: 'new-secret',
          );

      final state = container.read(localRecoveryControllerProvider);
      expect(state, isA<LocalRecoveryRecovered>());
      expect((state as LocalRecoveryRecovered).remaining, 4);
      expect(state.isLastCode, isFalse);

      final session = container.read(sessionProvider);
      expect(session, isA<SignedIn>());
      expect((session as SignedIn).role, Role.accountOwner);
      expect(session.mode, AppMode.desktopOffline);
    });

    test('Given the last recovery code is spent '
        'When recovery succeeds '
        'Then that is stated without implying a path that does not exist '
        '(UC-08 AF-02)', () async {
      final container = containerWith(
        FakeLocalAccounts(onRecover: (_, _, _) => recovered(remaining: 0)),
      );

      await container
          .read(localRecoveryControllerProvider.notifier)
          .recover(
            name: 'Local User',
            recoveryCode: 'AAAA-1111',
            newSecret: 'new-secret',
          );

      final state = container.read(
        localRecoveryControllerProvider,
      ) as LocalRecoveryRecovered;
      expect(state.remaining, 0);
      expect(state.isLastCode, isTrue);
    });

    test('Given a wrong code, a spent code, or an account that does not exist '
        'When the core refuses '
        'Then the same message is shown for all three (UC-08 AF-01, AF-02, '
        'AF-03)', () async {
      const single = 'That name and recovery code do not match an account.';

      for (final kind in [
        FailureKind.unauthenticated,
        FailureKind.notFound,
        FailureKind.conflict,
      ]) {
        final container = containerWith(
          FakeLocalAccounts(
            onRecover: (_, _, _) => Failure(message: single, kind: kind),
          ),
        );

        await container
            .read(localRecoveryControllerProvider.notifier)
            .recover(
              name: 'Local User',
              recoveryCode: 'wrong',
              newSecret: 'new-secret',
            );

        final state = container.read(localRecoveryControllerProvider);
        expect(state, isA<LocalRecoveryRefused>());
        // The whole point: nothing about the failure distinguishes the causes,
        // so this screen cannot be used to discover which accounts exist.
        expect(state.message, single);
      }
    });
  });

  group('LocalRecoveryController.regenerateCodes', () {
    test('Given a recovered account '
        'When new codes are issued '
        'Then they are presented once (UC-08 step 6)', () async {
      final container = containerWith(
        FakeLocalAccounts(
          onRecover: (_, _, _) => recovered(),
          onRegenerate: (_) => const Success(
            CreatedLocalAccount(
              displayName: '',
              recoveryCodes: ['NEW-1', 'NEW-2'],
            ),
          ),
        ),
      );
      final controller = container.read(
        localRecoveryControllerProvider.notifier,
      );

      await controller.recover(
        name: 'Local User',
        recoveryCode: 'AAAA-1111',
        newSecret: 'new-secret',
      );
      await controller.regenerateCodes();

      final state = container.read(localRecoveryControllerProvider);
      expect(state, isA<LocalRecoveryCodesIssued>());
      expect((state as LocalRecoveryCodesIssued).account.recoveryCodes, [
        'NEW-1',
        'NEW-2',
      ]);
    });

    test('Given the new secret was just set '
        'When codes are regenerated '
        'Then it is reused rather than asked for again', () async {
      final repository = FakeLocalAccounts(
        onRecover: (_, _, _) => recovered(),
        onRegenerate: (_) => const Success(
          CreatedLocalAccount(displayName: '', recoveryCodes: ['NEW-1']),
        ),
      );
      final container = containerWith(repository);
      final controller = container.read(
        localRecoveryControllerProvider.notifier,
      );

      await controller.recover(
        name: 'Local User',
        recoveryCode: 'AAAA-1111',
        newSecret: 'the-new-secret',
      );
      await controller.regenerateCodes();

      expect(repository.regenerations, ['the-new-secret']);
    });

    test('Given regeneration fails '
        'When it is reported '
        'Then the old codes are said to still stand (UC-08 AF-05)', () async {
      final container = containerWith(
        FakeLocalAccounts(
          onRecover: (_, _, _) => recovered(remaining: 3),
          onRegenerate: (_) => const Failure(
            message: 'The credential store could not be written.',
            kind: FailureKind.serverError,
          ),
        ),
      );
      final controller = container.read(
        localRecoveryControllerProvider.notifier,
      );

      await controller.recover(
        name: 'Local User',
        recoveryCode: 'AAAA-1111',
        newSecret: 'new-secret',
      );
      await controller.regenerateCodes();

      final state = container.read(localRecoveryControllerProvider);
      expect(state, isA<LocalRecoveryRegenerationFailed>());
      // The count survives the failure, because the codes did.
      expect((state as LocalRecoveryRegenerationFailed).remaining, 3);
      expect(state.message, 'The credential store could not be written.');
    });

    test('Given the user declines to regenerate '
        'When they finish '
        'Then the remaining codes stand and the count is carried '
        '(UC-08 AF-04)', () async {
      final repository = FakeLocalAccounts(
        onRecover: (_, _, _) => recovered(remaining: 2),
      );
      final container = containerWith(repository);
      final controller = container.read(
        localRecoveryControllerProvider.notifier,
      );

      await controller.recover(
        name: 'Local User',
        recoveryCode: 'AAAA-1111',
        newSecret: 'new-secret',
      );
      controller.declineRegeneration();

      final state = container.read(localRecoveryControllerProvider);
      expect(state, isA<LocalRecoveryFinished>());
      expect((state as LocalRecoveryFinished).remaining, 2);
      expect(repository.regenerations, isEmpty);
    });
  });

  group('LocalRecoveryScreen', () {
    testWidgets('Given a successful recovery '
        'When it settles '
        'Then the code is said to be spent and the remainder counted '
        '(UC-08 step 4)', (tester) async {
      await pumpScreen(
        tester,
        FakeLocalAccounts(onRecover: (_, _, _) => recovered(remaining: 4)),
      );
      await submitRecovery(tester);

      expect(find.textContaining('now used up'), findsOneWidget);
      expect(find.textContaining('4 codes left'), findsOneWidget);
    });

    testWidgets('Given the last code was used '
        'When it settles '
        'Then the screen says there is no way back, and offers none '
        '(UC-08 AF-02)', (tester) async {
      await pumpScreen(
        tester,
        FakeLocalAccounts(onRecover: (_, _, _) => recovered(remaining: 0)),
      );
      await submitRecovery(tester);

      expect(find.textContaining('it was your last one'), findsOneWidget);
      expect(find.textContaining('no way back'), findsOneWidget);
    });

    testWidgets('Given regeneration fails '
        'When it is reported '
        'Then the screen says explicitly that the old codes are still valid '
        '(UC-08 AF-05)', (tester) async {
      await pumpScreen(
        tester,
        FakeLocalAccounts(
          onRecover: (_, _, _) => recovered(remaining: 3),
          onRegenerate: (_) => const Failure(
            message: 'The credential store could not be written.',
            kind: FailureKind.serverError,
          ),
        ),
      );
      await submitRecovery(tester);

      await tester.tap(find.byKey(const Key('recovery.regenerate')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Nothing changed'), findsOneWidget);
      expect(find.textContaining('still valid'), findsOneWidget);
    });

    testWidgets('Given new codes are issued '
        'When they are shown '
        'Then finishing is gated on confirming they were kept', (tester) async {
      await pumpScreen(
        tester,
        FakeLocalAccounts(
          onRecover: (_, _, _) => recovered(),
          onRegenerate: (_) => const Success(
            CreatedLocalAccount(
              displayName: '',
              recoveryCodes: ['NEW-1', 'NEW-2'],
            ),
          ),
        ),
      );
      await submitRecovery(tester);

      await tester.tap(find.byKey(const Key('recovery.regenerate')));
      await tester.pumpAndSettle();

      expect(find.textContaining('NEW-1'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('recovery.done')))
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const Key('recovery.kept')));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('recovery.done')))
            .onPressed,
        isNotNull,
      );
    });
  });
}

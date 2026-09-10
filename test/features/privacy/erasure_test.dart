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
import 'package:fortuna_ui/features/ingestion/data/connection_repository.dart';
import 'package:fortuna_ui/features/privacy/data/consent_repository.dart';
import 'package:fortuna_ui/features/privacy/data/erasure_repository.dart';
import 'package:fortuna_ui/features/privacy/state/erasure_controller.dart';
import 'package:fortuna_ui/features/privacy/ui/privacy_screen.dart';

import 'consent_test.dart' show FakeConnections, FakeConsents;

class FakeErasure implements ErasureRepository {
  FakeErasure({this.answer});

  Result<ErasureReport> Function(String confirmation)? answer;
  final List<String> attempts = [];

  @override
  Future<Result<ErasureReport>> erase(String confirmation) async {
    attempts.add(confirmation);
    return answer?.call(confirmation) ??
        const Success(
          ErasureReport(
            erased: {'transactions': 12, 'accounts': 2},
            revokedConnections: 1,
          ),
        );
  }
}

ProviderContainer containerWith({
  required FakeErasure erasure,
  FakeConnections? connections,
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
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      coreLibraryProbeProvider.overrideWithValue(
        const FixedCoreLibraryProbe(CoreLibraryAvailability.absent),
      ),
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      erasureRepositoryProvider.overrideWithValue(erasure),
      connectionRepositoryProvider.overrideWithValue(
        connections ?? FakeConnections(const Success([])),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpPrivacy(
  WidgetTester tester, {
  required FakeErasure erasure,
  FakeConnections? connections,
}) async {
  // The privacy screen is long and its ListView builds lazily, so a
  // phone-sized surface leaves the erasure section unbuilt. A tall window
  // tests the screen rather than the scroll physics.
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

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
        erasureRepositoryProvider.overrideWithValue(erasure),
        consentRepositoryProvider.overrideWithValue(
          FakeConsents(onList: () => const Success(<Consent>[])),
        ),
        connectionRepositoryProvider.overrideWithValue(
          connections ?? FakeConnections(const Success([])),
        ),
      ],
      child: const MaterialApp(home: PrivacyScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('ErasureController.isConfirmed', () {
    test('Given the exact word the API demands '
        'When it is checked '
        'Then it confirms', () {
      expect(ErasureController.isConfirmed('ERASE'), isTrue);
    });

    test('Given anything else, including a different case '
        'When it is checked '
        'Then it does not confirm', () {
      for (final typed in ['', 'erase', 'Erase', ' ERASE', 'ERASE ', 'yes']) {
        expect(
          ErasureController.isConfirmed(typed),
          isFalse,
          reason: '"$typed" must not confirm',
        );
      }
    });
  });

  group('ErasureController', () {
    test(
      'Given live connections '
      'When erasure begins '
      'Then they are named before anything is confirmed (UC-44 AF-04)',
      () async {
        final container = containerWith(
          erasure: FakeErasure(),
          connections: FakeConnections(
            Success([
              Connection(
                id: 'a',
                state: BankConnectionState.active,
                connectedAt: DateTime(2026),
                externalReference: 'Bank A',
              ),
              Connection(
                id: 'b',
                state: BankConnectionState.revoked,
                connectedAt: DateTime(2026),
              ),
            ]),
          ),
        );

        await container.read(erasureControllerProvider.notifier).begin();

        final state = container.read(erasureControllerProvider);
        expect(state, isA<ErasureConfirming>());
        expect((state as ErasureConfirming).liveConnections.map((c) => c.id), [
          'a',
        ]);
      },
    );

    test('Given the confirmation is not the required word '
        'When erasure is attempted '
        'Then nothing is sent (UC-44 AF-01)', () async {
      final erasure = FakeErasure();
      final container = containerWith(erasure: erasure);

      await container.read(erasureControllerProvider.notifier).erase('erase');

      expect(erasure.attempts, isEmpty);
      expect(container.read(erasureControllerProvider), isA<ErasureRefused>());
    });

    test('Given the user backs out '
        'When they cancel '
        'Then nothing was erased (UC-44 AF-01)', () async {
      final erasure = FakeErasure();
      final container = containerWith(erasure: erasure);
      final controller = container.read(erasureControllerProvider.notifier);

      await controller.begin();
      controller.cancel();

      expect(container.read(erasureControllerProvider), isA<ErasureIdle>());
      expect(erasure.attempts, isEmpty);
    });

    test('Given the exact confirmation '
        'When erasure succeeds '
        'Then what was erased is reported (UC-44 step 6)', () async {
      final erasure = FakeErasure();
      final container = containerWith(erasure: erasure);

      await container.read(erasureControllerProvider.notifier).erase('ERASE');

      final state = container.read(erasureControllerProvider);
      expect(state, isA<ErasureDone>());
      final report = (state as ErasureDone).report;
      expect(report.erased['transactions'], 12);
      expect(report.totalRecords, 14);
      expect(report.revokedConnections, 1);
      expect(erasure.attempts, ['ERASE']);
    });

    test('Given the erasure fails partway '
        'When it is reported '
        'Then the user is told the account is intact (UC-44 AF-02)', () async {
      final container = containerWith(
        erasure: FakeErasure(
          answer: (_) => const Failure(
            message: 'The erasure could not be completed.',
            kind: FailureKind.serverError,
          ),
        ),
      );

      await container.read(erasureControllerProvider.notifier).erase('ERASE');

      final state = container.read(erasureControllerProvider);
      expect(state, isA<ErasureRefused>());
      // The part that matters: not just that it failed, but where they stand.
      expect(state.message, contains('your account is intact'));
    });

    test('Given the API refuses the erasure '
        'When it answers '
        "Then the API's reason is presented (UC-44 AF-03)", () async {
      final container = containerWith(
        erasure: FakeErasure(
          answer: (_) => const Failure(
            message: 'This account cannot be erased while an import runs.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      await container.read(erasureControllerProvider.notifier).erase('ERASE');

      expect(
        container.read(erasureControllerProvider).message,
        contains('cannot be erased while an import runs'),
      );
    });

    test(
      'Given the erasure completed '
      'When the user closes it '
      'Then the session ends and the token is cleared (UC-44 step 6)',
      () async {
        final container = containerWith(erasure: FakeErasure());
        await container.read(tokenStoreProvider).write('a-token');
        final controller = container.read(erasureControllerProvider.notifier);

        await controller.erase('ERASE');
        await controller.finish();

        expect(container.read(sessionProvider).isAuthenticated, isFalse);
        expect(await container.read(tokenStoreProvider).read(), isNull);
      },
    );
  });

  group('Erasure on the privacy screen', () {
    testWidgets('Given erasure is begun '
        'When the consequences are shown '
        'Then it says it is irreversible and unlike a record deletion '
        '(UC-44 step 2, FR-PR-08)', (tester) async {
      await pumpPrivacy(tester, erasure: FakeErasure());

      await tester.tap(find.byKey(const Key('erasure.begin')));
      await tester.pumpAndSettle();

      expect(find.textContaining('irreversible'), findsOneWidget);
      expect(find.textContaining('restore a record from'), findsOneWidget);
      // FR-PR-08: the audit trail survives, without identifying them.
      expect(find.textContaining('no longer identify you'), findsOneWidget);
    });

    testWidgets('Given erasure is begun '
        'When the consequences are shown '
        'Then the export is offered first (UC-44 step 3)', (tester) async {
      await pumpPrivacy(tester, erasure: FakeErasure());

      await tester.tap(find.byKey(const Key('erasure.begin')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('erasure.exportFirst')), findsOneWidget);
    });

    testWidgets('Given the confirmation field is empty or wrong '
        'When it is inspected '
        'Then erasing is not possible (UC-44 step 4, FR-PR-07)', (
      tester,
    ) async {
      await pumpPrivacy(tester, erasure: FakeErasure());

      await tester.tap(find.byKey(const Key('erasure.begin')));
      await tester.pumpAndSettle();

      FilledButton confirm() =>
          tester.widget<FilledButton>(find.byKey(const Key('erasure.confirm')));

      expect(confirm().onPressed, isNull);

      await tester.enterText(
        find.byKey(const Key('erasure.confirmation')),
        'erase',
      );
      await tester.pumpAndSettle();
      expect(confirm().onPressed, isNull);

      await tester.enterText(
        find.byKey(const Key('erasure.confirmation')),
        'ERASE',
      );
      await tester.pumpAndSettle();
      expect(confirm().onPressed, isNotNull);
    });

    testWidgets('Given live connections '
        'When the confirmation is shown '
        'Then they are named (UC-44 AF-04)', (tester) async {
      await pumpPrivacy(
        tester,
        erasure: FakeErasure(),
        connections: FakeConnections(
          Success([
            Connection(
              id: 'a',
              state: BankConnectionState.active,
              connectedAt: DateTime(2026),
              externalReference: 'Bank A',
            ),
          ]),
        ),
      );

      await tester.tap(find.byKey(const Key('erasure.begin')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('erasure.connection.a')), findsOneWidget);
    });

    testWidgets('Given a completed erasure '
        'When it is reported '
        'Then what went is listed before the session ends (UC-44 step 6)', (
      tester,
    ) async {
      await pumpPrivacy(tester, erasure: FakeErasure());

      await tester.tap(find.byKey(const Key('erasure.begin')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('erasure.confirmation')),
        'ERASE',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('erasure.confirm')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('erasure.done')), findsOneWidget);
      expect(find.textContaining('12 transactions'), findsOneWidget);
    });
  });
}

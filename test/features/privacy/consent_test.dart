import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/ingestion/data/connection_repository.dart';
import 'package:fortuna_ui/features/privacy/data/consent_repository.dart';
import 'package:fortuna_ui/features/privacy/state/consent_controller.dart';
import 'package:fortuna_ui/features/privacy/ui/privacy_screen.dart';

class FakeConsents implements ConsentRepository {
  FakeConsents({this.onList, this.onGrant, this.onWithdraw});

  Result<List<Consent>> Function()? onList;
  Result<void> Function(String purpose, String version)? onGrant;
  Result<void> Function(String purpose)? onWithdraw;

  final List<({String purpose, String version})> grants = [];
  final List<String> withdrawals = [];

  @override
  Future<Result<List<Consent>>> list() async =>
      onList?.call() ?? const Success([]);

  @override
  Future<Result<void>> grant({
    required String purpose,
    required String version,
  }) async {
    grants.add((purpose: purpose, version: version));
    return onGrant?.call(purpose, version) ?? const Success(null);
  }

  @override
  Future<Result<void>> withdraw(String purpose) async {
    withdrawals.add(purpose);
    return onWithdraw?.call(purpose) ?? const Success(null);
  }
}

class FakeConnections implements ConnectionRepository {
  FakeConnections(this.connections);

  Result<List<Connection>> connections;

  @override
  Future<Result<List<Connection>>> list() async => connections;

  @override
  Future<Result<String?>> synchronize(String id) async => const Success(null);

  @override
  Future<Result<void>> reauthenticate(String id) async => const Success(null);

  @override
  Future<Result<void>> revoke(String id) async => const Success(null);
}

Consent granted({
  String purpose = 'open-banking',
  String version = 'v2',
  String grantedVersion = 'v2',
  bool isCurrent = true,
}) => Consent(
  purpose: purpose,
  currentVersion: version,
  grantedVersion: grantedVersion,
  grantedAt: DateTime(2026, 3, 4),
  isCurrent: isCurrent,
);

const _ungranted = Consent(purpose: 'open-banking', currentVersion: 'v2');

ProviderContainer containerWith({
  required FakeConsents consents,
  FakeConnections? connections,
  Transport transport = Transport.http,
  String apiBaseUrl = 'https://fortuna.example',
}) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        AppConfig(
          apiBaseUrl: apiBaseUrl,
          googleClientId: '',
          transport: transport,
          databasePath: '',
        ),
      ),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      coreLibraryProbeProvider.overrideWithValue(
        FixedCoreLibraryProbe(
          transport == Transport.ffi
              ? CoreLibraryAvailability.available
              : CoreLibraryAvailability.absent,
        ),
      ),
      consentRepositoryProvider.overrideWithValue(consents),
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
  required FakeConsents consents,
  FakeConnections? connections,
  Transport transport = Transport.http,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            apiBaseUrl: transport == Transport.ffi
                ? ''
                : 'https://fortuna.example',
            googleClientId: '',
            transport: transport,
            databasePath: '',
          ),
        ),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
        coreLibraryProbeProvider.overrideWithValue(
          FixedCoreLibraryProbe(
            transport == Transport.ffi
                ? CoreLibraryAvailability.available
                : CoreLibraryAvailability.absent,
          ),
        ),
        consentRepositoryProvider.overrideWithValue(consents),
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
  group('Consent', () {
    test('Given a consent agreed to at the current version '
        'When it is asked whether it permits '
        'Then it does', () {
      expect(granted().permits, isTrue);
      expect(granted().isOutdated, isFalse);
    });

    test(
      'Given a consent agreed to at an older version '
      'When it is asked whether it permits '
      'Then it does not, and it reads as outdated (UC-42 AF-01, FR-PR-05)',
      () {
        final consent = granted(
          version: 'v3',
          grantedVersion: 'v2',
          isCurrent: false,
        );

        expect(consent.isGranted, isTrue);
        // The point of AF-01: an old decision is not a weak new one.
        expect(consent.isOutdated, isTrue);
        expect(consent.permits, isFalse);
      },
    );

    test('Given a consent never given '
        'When it is asked whether it permits '
        'Then it does not (FR-PR-02)', () {
      expect(_ungranted.isGranted, isFalse);
      expect(_ungranted.permits, isFalse);
    });

    test('Given a purpose this build does not recognize '
        'When it is labelled '
        'Then it is shown as the API named it rather than hidden', () {
      const consent = Consent(purpose: 'something-new', currentVersion: 'v1');

      expect(consent.label, 'something-new');
    });
  });

  group('DataController', () {
    test('Given a shared instance '
        'When the controller is resolved '
        'Then it is the operator, with a notice to point at (FR-PR-10)', () {
      final controller = DataController.forMode(AppMode.connected);

      expect(controller, DataController.operator);
      expect(controller.hasOperatorNotice, isTrue);
    });

    test('Given a self-hosted or offline installation '
        'When the controller is resolved '
        'Then it is the user, and no operator notice is implied '
        '(UC-42 AF-05, FR-PR-09)', () {
      for (final mode in [AppMode.selfHosted, AppMode.desktopOffline]) {
        final controller = DataController.forMode(mode);

        expect(controller, DataController.theUser, reason: '$mode');
        expect(controller.hasOperatorNotice, isFalse);
      }
    });
  });

  group('ConsentController', () {
    test('Given the consent list can be read '
        'When it loads '
        'Then each consent is presented (UC-42 step 1)', () async {
      final container = containerWith(
        consents: FakeConsents(onList: () => Success([granted()])),
      );

      await container.read(consentControllerProvider.notifier).load();

      final state = container.read(consentControllerProvider);
      expect(state, isA<ConsentsReady>());
      expect((state as ConsentsReady).consents.single.purpose, 'open-banking');
    });

    test('Given the consent list cannot be read '
        'When a feature asks whether it may proceed '
        'Then the answer is no (UC-42 AF-06)', () async {
      final container = containerWith(
        consents: FakeConsents(
          onList: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );
      final controller = container.read(consentControllerProvider.notifier);

      await controller.load();

      expect(
        container.read(consentControllerProvider),
        isA<ConsentsUnavailable>(),
      );
      // Nothing proceeds on the assumption that a consent exists.
      expect(controller.permits('open-banking'), isFalse);
    });

    test('Given consents are still loading '
        'When a feature asks whether it may proceed '
        'Then the answer is no', () {
      final container = containerWith(consents: FakeConsents());

      expect(
        container.read(consentControllerProvider.notifier).permits('anything'),
        isFalse,
      );
    });

    test('Given an outdated consent '
        'When a feature asks whether it may proceed '
        'Then the answer is no (UC-42 AF-01)', () async {
      final container = containerWith(
        consents: FakeConsents(
          onList: () => Success([
            granted(version: 'v3', grantedVersion: 'v2', isCurrent: false),
          ]),
        ),
      );
      final controller = container.read(consentControllerProvider.notifier);

      await controller.load();

      expect(controller.permits('open-banking'), isFalse);
    });

    test('Given a disclosure the user agrees to '
        'When it is recorded '
        'Then the decision carries the version (UC-42 step 4)', () async {
      final consents = FakeConsents(onList: () => const Success([_ungranted]));
      final container = containerWith(consents: consents);
      final controller = container.read(consentControllerProvider.notifier);

      await controller.load();
      await controller.grant(purpose: 'open-banking', version: 'v2');

      expect(consents.grants.single, (purpose: 'open-banking', version: 'v2'));
    });

    test('Given an instance that names no version '
        'When a consent would be recorded '
        'Then nothing is recorded, because it would consent to nothing '
        'in particular', () async {
      final consents = FakeConsents(onList: () => const Success([_ungranted]));
      final container = containerWith(consents: consents);
      final controller = container.read(consentControllerProvider.notifier);

      await controller.load();
      await controller.grant(purpose: 'open-banking', version: '');

      expect(consents.grants, isEmpty);
    });

    test(
      'Given live connections '
      'When the cost of withdrawing is gathered '
      'Then they are named, and revoked ones are left out (UC-42 AF-02)',
      () async {
        final container = containerWith(
          consents: FakeConsents(onList: () => Success([granted()])),
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
        final controller = container.read(consentControllerProvider.notifier);
        await controller.load();

        final consequences = await controller.consequencesOfWithdrawing(
          'open-banking',
        );

        expect(consequences.revokesConnections, isTrue);
        expect(consequences.connections.map((c) => c.id), ['a']);
      },
    );

    test('Given a consent that was never given '
        'When it is withdrawn '
        "Then the API's not-found answer is presented (UC-42 AF-03)", () async {
      final container = containerWith(
        consents: FakeConsents(
          onList: () => const Success([_ungranted]),
          onWithdraw: (_) => const Failure(
            message: 'No such consent is recorded.',
            kind: FailureKind.notFound,
          ),
        ),
      );
      final controller = container.read(consentControllerProvider.notifier);

      await controller.load();
      await controller.withdraw('open-banking');

      final state = container.read(consentControllerProvider);
      expect(state, isA<ConsentsReady>());
      expect((state as ConsentsReady).notice, 'No such consent is recorded.');
    });

    test(
      'Given the user declines a disclosure '
      'When nothing is recorded '
      'Then the reason is said and no consent is written (UC-42 AF-04)',
      () async {
        final consents = FakeConsents(
          onList: () => const Success([_ungranted]),
        );
        final container = containerWith(consents: consents);
        final controller = container.read(consentControllerProvider.notifier);

        await controller.load();
        controller.decline('open-banking');

        expect(consents.grants, isEmpty);
        final state =
            container.read(consentControllerProvider) as ConsentsReady;
        expect(state.notice, contains('stay unavailable'));
      },
    );
  });

  group('PrivacyScreen', () {
    testWidgets('Given a shared instance '
        'When the screen settles '
        'Then the operator is named as controller (FR-PR-10)', (tester) async {
      await pumpPrivacy(tester, consents: FakeConsents());

      expect(find.textContaining('shared instance'), findsOneWidget);
      expect(find.byKey(const Key('privacy.operatorNotice')), findsOneWidget);
    });

    testWidgets('Given a desktop offline installation '
        'When the screen settles '
        'Then the user is the controller and no operator is implied '
        '(UC-42 AF-05)', (tester) async {
      await pumpPrivacy(
        tester,
        consents: FakeConsents(),
        transport: Transport.ffi,
      );

      expect(
        find.textContaining('you are the data controller'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('privacy.operatorNotice')), findsNothing);
    });

    testWidgets('Given an outdated consent '
        'When it is listed '
        'Then it says a fresh decision is needed (UC-42 AF-01)', (
      tester,
    ) async {
      await pumpPrivacy(
        tester,
        consents: FakeConsents(
          onList: () => Success([
            granted(version: 'v3', grantedVersion: 'v2', isCurrent: false),
          ]),
        ),
      );

      expect(
        find.byKey(const Key('privacy.outdated.open-banking')),
        findsOneWidget,
      );
      expect(find.text('Review again'), findsOneWidget);
    });

    testWidgets('Given the user declines the disclosure '
        'When the dialog closes '
        'Then nothing is recorded (UC-42 AF-04)', (tester) async {
      final consents = FakeConsents(onList: () => const Success([_ungranted]));
      await pumpPrivacy(tester, consents: consents);

      await tester.tap(find.byKey(const Key('privacy.give.open-banking')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('privacy.decline')));
      await tester.pumpAndSettle();

      expect(consents.grants, isEmpty);
      expect(find.byKey(const Key('privacy.notice')), findsOneWidget);
    });

    testWidgets('Given a consent connections depend on '
        'When withdrawal is started '
        'Then those connections are named before it is confirmed '
        '(UC-42 AF-02)', (tester) async {
      await pumpPrivacy(
        tester,
        consents: FakeConsents(onList: () => Success([granted()])),
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

      await tester.tap(find.byKey(const Key('privacy.withdraw.open-banking')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('privacy.revoked.a')), findsOneWidget);
      expect(find.textContaining('stays where it is'), findsOneWidget);
    });

    testWidgets('Given the consent list cannot be read '
        'When the screen settles '
        'Then it says nothing needing consent will run (UC-42 AF-06)', (
      tester,
    ) async {
      await pumpPrivacy(
        tester,
        consents: FakeConsents(
          onList: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      expect(find.byKey(const Key('privacy.unavailable')), findsOneWidget);
      expect(find.textContaining('will run until this can be read'), findsOne);
    });
  });
}

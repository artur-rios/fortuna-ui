import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/ingestion/data/connection_repository.dart';
import 'package:fortuna_ui/features/privacy/data/archive_saver.dart';
import 'package:fortuna_ui/features/privacy/data/consent_repository.dart';
import 'package:fortuna_ui/features/privacy/data/personal_export_repository.dart';
import 'package:fortuna_ui/features/privacy/state/consent_controller.dart';
import 'package:fortuna_ui/features/privacy/state/personal_export_controller.dart';
import 'package:fortuna_ui/features/privacy/ui/privacy_screen.dart';
import 'package:material_ui/material_ui.dart';

import 'personal_export_test.dart' show FakeExports, FakeSaver, completed;

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

  // UC-30 added this to the interface; UC-42 never connects anything.
  @override
  Future<Result<Connection>> connect({
    required String dataSource,
    required String externalReference,
  }) async => const Failure(
    message: 'Not used by these tests.',
    kind: FailureKind.serverError,
  );
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
  FakeExports? exports,
  FakeSaver? saver,
}) async {
  // The screen's ListView builds lazily; a tall window builds every section.
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

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
        personalExportRepositoryProvider.overrideWithValue(
          exports ?? FakeExports(),
        ),
        archiveSaverProvider.overrideWithValue(
          saver ?? FakeSaver((_) => const Success('/tmp/archive.zip')),
        ),
      ],
      child: const MaterialApp(home: PrivacyScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

/// One active connection that depends on the open-banking consent.
final _bankA = FakeConnections(
  Success([
    Connection(
      id: 'a',
      state: BankConnectionState.active,
      connectedAt: DateTime(2026),
      externalReference: 'Bank A',
    ),
  ]),
);

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

    test('Given a desktop offline installation '
        'When the controller asks who controls the data '
        'Then it is the user (UC-42 AF-05)', () {
      final container = containerWith(
        consents: FakeConsents(),
        transport: Transport.ffi,
        apiBaseUrl: '',
      );

      expect(
        container.read(consentControllerProvider.notifier).controller,
        DataController.theUser,
      );
    });

    test(
      'Given a disclosure the user agrees to '
      'When the API refuses to record it '
      'Then its reason is noted over the consents, which stay as they were',
      () async {
        final consents = FakeConsents(
          onList: () => const Success([_ungranted]),
          onGrant: (_, _) => const Failure(
            message: 'That version is no longer offered.',
            kind: FailureKind.conflict,
          ),
        );
        final container = containerWith(consents: consents);
        final controller = container.read(consentControllerProvider.notifier);

        await controller.load();
        await controller.grant(purpose: 'open-banking', version: 'v2');

        final state = container.read(consentControllerProvider);
        expect(state, isA<ConsentsReady>());
        expect(
          (state as ConsentsReady).notice,
          'That version is no longer offered.',
        );
        expect(state.consents.single.isGranted, isFalse);
        expect(controller.permits('open-banking'), isFalse);
      },
    );

    test('Given a recorded consent '
        'When it is withdrawn '
        'Then the consents are read again and it no longer permits '
        '(UC-42 step 6)', () async {
      var withdrawn = false;
      final consents = FakeConsents(
        onList: () => Success([withdrawn ? _ungranted : granted()]),
        onWithdraw: (_) {
          withdrawn = true;
          return const Success(null);
        },
      );
      final container = containerWith(consents: consents);
      final controller = container.read(consentControllerProvider.notifier);
      await controller.load();
      expect(controller.permits('open-banking'), isTrue);

      await controller.withdraw('open-banking');

      expect(consents.withdrawals, ['open-banking']);
      expect(controller.permits('open-banking'), isFalse);
    });

    test(
      'Given the connection list cannot be read '
      'When the cost of withdrawing is gathered '
      'Then no connection is claimed, rather than promising none exist',
      () async {
        final container = containerWith(
          consents: FakeConsents(onList: () => Success([granted()])),
          connections: FakeConnections(
            const Failure(
              message: 'The instance could not be reached.',
              kind: FailureKind.unreachable,
            ),
          ),
        );

        final consequences = await container
            .read(consentControllerProvider.notifier)
            .consequencesOfWithdrawing('open-banking');

        expect(consequences.purpose, 'open-banking');
        expect(consequences.revokesConnections, isFalse);
      },
    );

    test('Given the consents were never read '
        'When a decision is declined '
        'Then the note stands on its own rather than over a list', () {
      final container = containerWith(consents: FakeConsents());

      container
          .read(consentControllerProvider.notifier)
          .decline('open-banking');

      final state = container.read(consentControllerProvider);
      expect(state, isA<ConsentsUnavailable>());
      expect(
        (state as ConsentsUnavailable).reason,
        contains('Nothing was recorded.'),
      );
    });
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
    testWidgets('Given a disclosure '
        'When the user agrees '
        'Then the decision is recorded against the current version and the '
        'consent shows as given (UC-42 step 4)', (tester) async {
      var given = false;
      final consents = FakeConsents(
        onList: () => Success([given ? granted() : _ungranted]),
        onGrant: (_, _) {
          given = true;
          return const Success(null);
        },
      );
      await pumpPrivacy(tester, consents: consents);

      await tester.tap(find.byKey(const Key('privacy.give.open-banking')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Version v2.'), findsOneWidget);
      await tester.tap(find.byKey(const Key('privacy.agree')));
      await tester.pumpAndSettle();

      expect(consents.grants.single, (purpose: 'open-banking', version: 'v2'));
      expect(find.byKey(const Key('privacy.give.open-banking')), findsNothing);
      expect(
        find.byKey(const Key('privacy.withdraw.open-banking')),
        findsOneWidget,
      );
    });

    testWidgets(
      'Given no connection is known to depend on a consent '
      'When withdrawal is started '
      'Then the warning is general rather than promising nothing is revoked',
      (tester) async {
        await pumpPrivacy(
          tester,
          consents: FakeConsents(onList: () => Success([granted()])),
        );

        await tester.tap(
          find.byKey(const Key('privacy.withdraw.open-banking')),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Any connections that depend on this consent will be revoked.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('Given the withdrawal warning '
        'When the user keeps the consent '
        'Then nothing is withdrawn', (tester) async {
      final consents = FakeConsents(onList: () => Success([granted()]));
      await pumpPrivacy(tester, consents: consents, connections: _bankA);

      await tester.tap(find.byKey(const Key('privacy.withdraw.open-banking')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('privacy.cancelWithdraw')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(consents.withdrawals, isEmpty);
    });

    testWidgets('Given the withdrawal warning '
        'When the user confirms '
        'Then the consent is withdrawn and offered again (UC-42 step 6)', (
      tester,
    ) async {
      var withdrawn = false;
      final consents = FakeConsents(
        onList: () => Success([withdrawn ? _ungranted : granted()]),
        onWithdraw: (_) {
          withdrawn = true;
          return const Success(null);
        },
      );
      await pumpPrivacy(tester, consents: consents, connections: _bankA);

      await tester.tap(find.byKey(const Key('privacy.withdraw.open-banking')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('privacy.confirmWithdraw')));
      await tester.pumpAndSettle();

      expect(consents.withdrawals, ['open-banking']);
      expect(find.text('Not given.'), findsOneWidget);
      expect(
        find.byKey(const Key('privacy.give.open-banking')),
        findsOneWidget,
      );
    });

    testWidgets('Given the consent list could not be read '
        'When the user tries again and it can be '
        'Then the consents are shown', (tester) async {
      var reachable = false;
      await pumpPrivacy(
        tester,
        consents: FakeConsents(
          onList: () => reachable
              ? const Success(<Consent>[])
              : const Failure(
                  message: 'The instance could not be reached.',
                  kind: FailureKind.unreachable,
                ),
        ),
      );

      reachable = true;
      await tester.tap(find.byKey(const Key('privacy.retry')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('privacy.unavailable')), findsNothing);
      expect(find.text('This instance asks for no consents.'), findsOneWidget);
    });

    testWidgets('Given no archive has been asked for '
        'When the user asks for one '
        'Then the job is shown running, and leaving does not cancel it '
        '(UC-43 step 3, AF-04)', (tester) async {
      final exports = FakeExports(onRead: (_) => Success(completed()));
      await pumpPrivacy(tester, consents: FakeConsents(), exports: exports);

      await tester.tap(find.byKey(const Key('export.request')));
      await tester.pump();

      expect(exports.requests, 1);
      expect(find.byKey(const Key('export.progress')), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byKey(const Key('export.progress')),
            )
            .value,
        0.2,
      );
      expect(find.byKey(const Key('export.keepsRunning')), findsOneWidget);

      // The job is polled while it runs; this check finds it finished.
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();

      expect(exports.reads, ['job-1']);
      expect(find.byKey(const Key('export.save')), findsOneWidget);
    });

    testWidgets('Given a running job with no progress yet '
        'When it is shown '
        'Then the progress bar is indeterminate rather than at zero', (
      tester,
    ) async {
      await pumpPrivacy(
        tester,
        consents: FakeConsents(),
        exports: FakeExports(
          onRequest: () => const Success(
            PersonalExport(
              jobId: 'job-1',
              status: PersonalExportStatus.pending,
              progress: 0,
            ),
          ),
          onRead: (_) => Success(completed()),
        ),
      );

      await tester.tap(find.byKey(const Key('export.request')));
      await tester.pump();

      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byKey(const Key('export.progress')),
            )
            .value,
        isNull,
      );

      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('Given a ready archive '
        'When it is saved '
        'Then where it went and its size are stated (UC-43 step 4, AF-05)', (
      tester,
    ) async {
      await pumpPrivacy(
        tester,
        consents: FakeConsents(),
        exports: FakeExports(onRead: (_) => Success(completed())),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PrivacyScreen)),
      );
      await container
          .read(personalExportControllerProvider.notifier)
          .refresh('job-1');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('export.save')));
      await tester.pumpAndSettle();

      expect(find.text('Saved to /tmp/archive.zip (3 bytes).'), findsOneWidget);
    });

    testWidgets('Given the platform refuses the location '
        'When the archive is saved '
        'Then the reason is shown, the archive is still ready and saving can '
        'be tried again (UC-43 AF-03)', (tester) async {
      var refuse = true;
      final saver = FakeSaver(
        (_) => refuse
            ? const Failure(
                message: 'That location could not be written to.',
                kind: FailureKind.forbidden,
              )
            : const Success('/elsewhere/archive.zip'),
      );
      await pumpPrivacy(
        tester,
        consents: FakeConsents(),
        exports: FakeExports(onRead: (_) => Success(completed())),
        saver: saver,
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PrivacyScreen)),
      );
      await container
          .read(personalExportControllerProvider.notifier)
          .refresh('job-1');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('export.save')));
      await tester.pumpAndSettle();

      expect(
        find.text('That location could not be written to.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('export.stillReady')), findsOneWidget);

      refuse = false;
      await tester.tap(find.byKey(const Key('export.saveAgain')));
      await tester.pumpAndSettle();

      expect(saver.saves, 2);
      expect(find.byKey(const Key('export.saved')), findsOneWidget);
    });

    testWidgets('Given the archive expired before it was fetched '
        'When the user asks for a new one '
        'Then a new job is started (UC-43 AF-02)', (tester) async {
      final exports = FakeExports(
        onRead: (_) => Success(completed(expiresAt: DateTime.utc(2000))),
      );
      await pumpPrivacy(tester, consents: FakeConsents(), exports: exports);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PrivacyScreen)),
      );
      await container
          .read(personalExportControllerProvider.notifier)
          .refresh('job-1');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('export.expired')), findsOneWidget);

      exports.onRead = (_) => Success(completed());
      await tester.tap(find.byKey(const Key('export.requestAgain')));
      await tester.pump();

      expect(exports.requests, 1);
      expect(find.byKey(const Key('export.progress')), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('Given the export cannot be started '
        'When the user asks for it '
        "Then the API's reason is shown with a retry (UC-43 AF-01)", (
      tester,
    ) async {
      var refuse = true;
      final exports = FakeExports(
        onRequest: () => refuse
            ? const Failure(
                message: 'Exports are paused on this instance.',
                kind: FailureKind.serverError,
              )
            : Success(completed()),
      );
      await pumpPrivacy(tester, consents: FakeConsents(), exports: exports);

      await tester.tap(find.byKey(const Key('export.request')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('export.failed')), findsOneWidget);
      expect(find.text('Exports are paused on this instance.'), findsOneWidget);

      refuse = false;
      exports.onRead = (_) => Success(completed());
      await tester.tap(find.byKey(const Key('export.retry')));
      await tester.pump();

      expect(exports.requests, 2);
      expect(find.byKey(const Key('export.failed')), findsNothing);

      await tester.pump(const Duration(seconds: 3));
    });
  });
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/ingestion/data/connection_repository.dart';
import 'package:fortuna_ui/features/ingestion/data/data_source_repository.dart';
import 'package:fortuna_ui/features/ingestion/state/data_source_providers.dart';
import 'package:fortuna_ui/features/ingestion/ui/data_sources_screen.dart';
import 'package:fortuna_ui/features/privacy/data/consent_repository.dart';

class FakeDataSources implements DataSourceRepository {
  FakeDataSources({this.onList});

  Result<List<DataSource>> Function()? onList;

  @override
  Future<Result<List<DataSource>>> list() async =>
      onList?.call() ?? Success([source()]);
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowDataSources implements DataSourceRepository {
  SlowDataSources(this._pending);

  final Future<Result<List<DataSource>>> _pending;

  @override
  Future<Result<List<DataSource>>> list() => _pending;
}

class ConnectableConnections implements ConnectionRepository {
  ConnectableConnections({this.existing = const [], this.onConnect});

  List<Connection> existing;
  Result<Connection> Function()? onConnect;

  final List<Map<String, Object?>> connected = [];

  @override
  Future<Result<List<Connection>>> list() async => Success(existing);

  @override
  Future<Result<Connection>> connect({
    required String dataSource,
    required String externalReference,
  }) async {
    connected.add({
      'dataSource': dataSource,
      'externalReference': externalReference,
    });
    return onConnect?.call() ??
        Success(connection(externalReference: externalReference));
  }

  @override
  Future<Result<String?>> synchronize(String id) async => const Success(null);

  @override
  Future<Result<void>> reauthenticate(String id) async => const Success(null);

  @override
  Future<Result<void>> revoke(String id) async => const Success(null);
}

class FakeConsents implements ConsentRepository {
  FakeConsents({this.consents = const [], this.grantFails = false});

  List<Consent> consents;
  bool grantFails;

  final List<Map<String, String>> granted = [];

  @override
  Future<Result<List<Consent>>> list() async => Success(consents);

  @override
  Future<Result<void>> grant({
    required String purpose,
    required String version,
  }) async {
    granted.add({'purpose': purpose, 'version': version});

    if (grantFails) {
      return const Failure(
        message: 'The decision could not be recorded.',
        kind: FailureKind.serverError,
      );
    }

    // A granted consent becomes current, which is what the screen then reads.
    consents = [
      for (final consent in consents)
        if (consent.purpose == purpose)
          Consent(
            purpose: consent.purpose,
            currentVersion: consent.currentVersion,
            grantedVersion: version,
            grantedAt: DateTime(2026, 9, 11),
            isCurrent: true,
          )
        else
          consent,
    ];
    return const Success(null);
  }

  @override
  Future<Result<void>> withdraw(String purpose) async => const Success(null);
}

DataSource source({
  String name = 'pluggy',
  String displayName = 'Open banking',
  SourceKind kind = SourceKind.network,
  bool isAvailable = true,
  bool isNetworkBacked = true,
  String? unavailableReason,
  List<String> requiredInputs = const [],
}) => DataSource(
  name: name,
  displayName: displayName,
  kind: kind,
  isAvailable: isAvailable,
  isNetworkBacked: isNetworkBacked,
  unavailableReason: unavailableReason,
  requiredInputs: requiredInputs,
);

Connection connection({
  String id = 'c1',
  String externalReference = 'A Bank',
  BankConnectionState state = BankConnectionState.active,
}) => Connection(
  id: id,
  state: state,
  connectedAt: DateTime(2026, 9, 11),
  externalReference: externalReference,
);

Consent consent({
  String purpose = externalProcessingPurpose,
  String version = 'v2',
  String? grantedVersion,
  bool isCurrent = false,
}) => Consent(
  purpose: purpose,
  currentVersion: version,
  grantedVersion: grantedVersion,
  grantedAt: grantedVersion == null ? null : DateTime(2026),
  isCurrent: isCurrent,
);

ProviderContainer containerWith({
  FakeDataSources? sources,
  ConnectableConnections? connections,
}) {
  final container = ProviderContainer(
    overrides: [
      dataSourceRepositoryProvider.overrideWithValue(
        sources ?? FakeDataSources(),
      ),
      connectionRepositoryProvider.overrideWithValue(
        connections ?? ConnectableConnections(),
      ),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpSources(
  WidgetTester tester, {
  FakeDataSources? sources,
  ConnectableConnections? connections,
  FakeConsents? consents,
}) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dataSourceRepositoryProvider.overrideWithValue(
          sources ?? FakeDataSources(),
        ),
        connectionRepositoryProvider.overrideWithValue(
          connections ?? ConnectableConnections(),
        ),
        consentRepositoryProvider.overrideWithValue(
          consents ?? FakeConsents(consents: [consent()]),
        ),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: DataSourcesScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('DataSource', () {
    test('Given a network-backed source '
        'When it is asked '
        'Then connecting to it needs consent first (FR-IN-02)', () {
      expect(source().needsExternalConsent, isTrue);
    });

    test('Given a file source '
        'When it is asked '
        'Then no external consent is needed', () {
      // Nothing leaves the instance, so asking permission for an external
      // disclosure would be asking about something that is not happening.
      expect(
        source(
          kind: SourceKind.file,
          isNetworkBacked: false,
        ).needsExternalConsent,
        isFalse,
      );
    });

    test('Given the kinds the contract specifies '
        'When they are mapped '
        'Then each keeps its own meaning', () {
      expect(SourceKind.network.wire, 1);
      expect(SourceKind.file.wire, 2);
      expect(SourceKind.from(null), SourceKind.network);
    });
  });

  group('ConnectActions', () {
    test('Given no existing connection '
        'When an institution is connected '
        'Then the source and the reference reach the API (step 5)', () async {
      final connections = ConnectableConnections();

      final outcome = await containerWith(connections: connections)
          .read(connectActionsProvider)
          .connect(dataSource: 'pluggy', externalReference: 'A Bank');

      expect(outcome, isA<Connected>());
      expect(connections.connected.single['dataSource'], 'pluggy');
      expect(connections.connected.single['externalReference'], 'A Bank');
    });

    test(
      'Given a connection already covers the institution '
      'When it is connected again '
      'Then the existing one is returned and nothing is created (AF-07)',
      () async {
        final connections = ConnectableConnections(
          existing: [connection(externalReference: 'A Bank')],
        );

        final outcome = await containerWith(connections: connections)
            .read(connectActionsProvider)
            .connect(dataSource: 'pluggy', externalReference: 'A Bank');

        expect(outcome, isA<AlreadyConnected>());
        expect(connections.connected, isEmpty);
      },
    );

    test(
      'Given only a revoked connection for the institution '
      'When it is connected again '
      'Then a new one is created, since a revoked one is a closed door',
      () async {
        final connections = ConnectableConnections(
          existing: [
            connection(
              externalReference: 'A Bank',
              state: BankConnectionState.revoked,
            ),
          ],
        );

        final outcome = await containerWith(connections: connections)
            .read(connectActionsProvider)
            .connect(dataSource: 'pluggy', externalReference: 'A Bank');

        expect(outcome, isA<Connected>());
        expect(connections.connected, hasLength(1));
      },
    );

    test('Given the API refuses for want of a consent '
        'When it is connected '
        'Then that is distinguished from a plain failure (AF-03)', () async {
      final connections = ConnectableConnections(
        onConnect: () => const Failure(
          message: 'No current consent for external processing.',
          kind: FailureKind.forbidden,
        ),
      );

      final outcome = await containerWith(connections: connections)
          .read(connectActionsProvider)
          .connect(dataSource: 'pluggy', externalReference: 'A Bank');

      expect(outcome, isA<ConsentMissing>());
      expect(
        (outcome as ConsentMissing).reason,
        'No current consent for external processing.',
      );
    });

    test('Given the API reports the aggregator unavailable '
        'When it is connected '
        'Then the failure is retryable (AF-05)', () async {
      final connections = ConnectableConnections(
        onConnect: () => const Failure(
          message: 'The aggregator could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      final outcome = await containerWith(connections: connections)
          .read(connectActionsProvider)
          .connect(dataSource: 'pluggy', externalReference: 'A Bank');

      expect(outcome, isA<ConnectFailed>());
      expect((outcome as ConnectFailed).isRetryable, isTrue);
    });

    test('Given the API rejects the request itself '
        'When it is connected '
        'Then retrying is not offered, since it could not help', () async {
      final connections = ConnectableConnections(
        onConnect: () => const Failure(
          message: 'That institution is not supported.',
          kind: FailureKind.invalidInput,
        ),
      );

      final outcome = await containerWith(connections: connections)
          .read(connectActionsProvider)
          .connect(dataSource: 'pluggy', externalReference: 'A Bank');

      expect((outcome as ConnectFailed).isRetryable, isFalse);
    });
  });

  group('DataSourcesScreen', () {
    testWidgets('Given the sources are still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<DataSource>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dataSourceRepositoryProvider.overrideWithValue(
              SlowDataSources(pending.future),
            ),
            connectionRepositoryProvider.overrideWithValue(
              ConnectableConnections(),
            ),
            consentRepositoryProvider.overrideWithValue(FakeConsents()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: DataSourcesScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(Success([source()]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sources.item.pluggy')), findsOneWidget);
    });

    testWidgets('Given the sources cannot be read '
        'When the screen settles '
        'Then a failure with a retry is shown', (tester) async {
      var attempts = 0;
      final sources = FakeDataSources(
        onList: () {
          attempts++;
          return const Failure(
            message: 'Data sources could not be read.',
            kind: FailureKind.serverError,
          );
        },
      );

      await pumpSources(tester, sources: sources);

      expect(find.text('Data sources could not be read.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('sources.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given a source unavailable in this mode '
        'When it is listed '
        'Then it is shown with the reason, not hidden (AF-06, FR-IN-01)', (
      tester,
    ) async {
      await pumpSources(
        tester,
        sources: FakeDataSources(
          onList: () => Success([
            source(
              isAvailable: false,
              unavailableReason:
                  'External sources are unavailable in offline mode.',
            ),
          ]),
        ),
      );

      // Listed, not hidden.
      expect(find.byKey(const Key('sources.item.pluggy')), findsOneWidget);
      expect(
        find.byKey(const Key('sources.unavailable.pluggy')),
        findsOneWidget,
      );
      expect(
        find.text('External sources are unavailable in offline mode.'),
        findsOneWidget,
      );
      // And connection is not offered.
      expect(find.byKey(const Key('sources.connect.pluggy')), findsNothing);
    });

    testWidgets('Given an available network source '
        'When it is listed '
        'Then connecting is offered (step 1)', (tester) async {
      await pumpSources(tester);

      expect(find.byKey(const Key('sources.connect.pluggy')), findsOneWidget);
    });

    testWidgets('Given no current consent '
        'When connecting is chosen '
        'Then the disclosure is presented first (step 4, FR-IN-02)', (
      tester,
    ) async {
      await pumpSources(tester);
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sources.disclosure')), findsOneWidget);
      expect(find.textContaining('What is shared'), findsOneWidget);
      expect(find.textContaining('Who with'), findsOneWidget);
      expect(find.textContaining('Why'), findsOneWidget);
    });

    testWidgets('Given the disclosure is declined '
        'When the dialog closes '
        'Then no connection is initiated (AF-01)', (tester) async {
      final connections = ConnectableConnections();

      await pumpSources(tester, connections: connections);
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sources.disclosure.decline')));
      await tester.pumpAndSettle();

      expect(connections.connected, isEmpty);
      expect(find.byKey(const Key('sources.connect.reference')), findsNothing);
    });

    testWidgets('Given the disclosure is agreed to '
        'When it is recorded '
        'Then the decision carries the version that was shown', (tester) async {
      final consents = FakeConsents(consents: [consent(version: 'v2')]);

      await pumpSources(tester, consents: consents);
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sources.disclosure.agree')));
      await tester.pumpAndSettle();

      expect(consents.granted.single['version'], 'v2');
      expect(consents.granted.single['purpose'], externalProcessingPurpose);
      // And the connect form follows.
      expect(
        find.byKey(const Key('sources.connect.reference')),
        findsOneWidget,
      );
    });

    testWidgets('Given a consent for an outdated version '
        'When connecting is chosen '
        'Then the new text is presented and the decision asked again (AF-02)', (
      tester,
    ) async {
      await pumpSources(
        tester,
        consents: FakeConsents(
          consents: [consent(version: 'v2', grantedVersion: 'v1')],
        ),
      );
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('sources.disclosure.outdated')),
        findsOneWidget,
      );
      expect(find.textContaining('It has changed'), findsOneWidget);
    });

    testWidgets('Given a current consent '
        'When connecting is chosen '
        'Then the disclosure is not asked again', (tester) async {
      await pumpSources(
        tester,
        consents: FakeConsents(
          consents: [
            consent(version: 'v2', grantedVersion: 'v2', isCurrent: true),
          ],
        ),
      );
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sources.disclosure')), findsNothing);
      expect(
        find.byKey(const Key('sources.connect.reference')),
        findsOneWidget,
      );
    });

    testWidgets('Given the instance states no disclosure version '
        'When the user agrees '
        'Then nothing is recorded and the reason is shown', (tester) async {
      final consents = FakeConsents(consents: [consent(version: '')]);

      await pumpSources(tester, consents: consents);
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sources.disclosure.agree')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sources.disclosure.error')), findsOneWidget);
      expect(consents.granted, isEmpty);
    });

    testWidgets('Given consent is in place '
        'When an institution is submitted '
        'Then it is connected and shown (steps 5 and 6)', (tester) async {
      final connections = ConnectableConnections();

      await pumpSources(
        tester,
        connections: connections,
        consents: FakeConsents(
          consents: [
            consent(version: 'v2', grantedVersion: 'v2', isCurrent: true),
          ],
        ),
      );
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('sources.connect.reference')),
        'A Bank',
      );
      await tester.tap(find.byKey(const Key('sources.connect.submit')));
      await tester.pumpAndSettle();

      expect(connections.connected.single['externalReference'], 'A Bank');
      expect(find.byKey(const Key('sources.connected')), findsOneWidget);
      expect(find.byKey(const Key('sources.connected.state')), findsOneWidget);
    });

    testWidgets('Given the institution is already connected '
        'When it is submitted '
        'Then the existing connection is shown rather than a duplicate '
        '(AF-07)', (tester) async {
      final connections = ConnectableConnections(
        existing: [connection(externalReference: 'A Bank')],
      );

      await pumpSources(
        tester,
        connections: connections,
        consents: FakeConsents(
          consents: [
            consent(version: 'v2', grantedVersion: 'v2', isCurrent: true),
          ],
        ),
      );
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('sources.connect.reference')),
        'A Bank',
      );
      await tester.tap(find.byKey(const Key('sources.connect.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sources.alreadyConnected')), findsOneWidget);
      expect(connections.connected, isEmpty);
    });

    testWidgets('Given the user abandons the form '
        'When it is cancelled '
        'Then no connection is created (AF-04)', (tester) async {
      final connections = ConnectableConnections();

      await pumpSources(
        tester,
        connections: connections,
        consents: FakeConsents(
          consents: [
            consent(version: 'v2', grantedVersion: 'v2', isCurrent: true),
          ],
        ),
      );
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sources.connect.cancel')));
      await tester.pumpAndSettle();

      expect(connections.connected, isEmpty);
      expect(find.byKey(const Key('sources.connected')), findsNothing);
    });

    testWidgets('Given the aggregator is unavailable '
        'When connecting is attempted '
        'Then the failure is shown with a retry (AF-05)', (tester) async {
      await pumpSources(
        tester,
        connections: ConnectableConnections(
          onConnect: () => const Failure(
            message: 'The aggregator could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
        consents: FakeConsents(
          consents: [
            consent(version: 'v2', grantedVersion: 'v2', isCurrent: true),
          ],
        ),
      );
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('sources.connect.reference')),
        'A Bank',
      );
      await tester.tap(find.byKey(const Key('sources.connect.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sources.connectFailed')), findsOneWidget);
      expect(
        find.byKey(const Key('sources.connectFailed.retry')),
        findsOneWidget,
      );
    });

    testWidgets('Given the API refuses naming a missing consent '
        'When connecting is attempted '
        'Then the disclosure is offered rather than a bare error (AF-03)', (
      tester,
    ) async {
      await pumpSources(
        tester,
        connections: ConnectableConnections(
          onConnect: () => const Failure(
            message: 'No current consent for external processing.',
            kind: FailureKind.forbidden,
          ),
        ),
        consents: FakeConsents(
          consents: [
            consent(version: 'v2', grantedVersion: 'v2', isCurrent: true),
          ],
        ),
      );
      await tester.tap(find.byKey(const Key('sources.connect.pluggy')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('sources.connect.reference')),
        'A Bank',
      );
      await tester.tap(find.byKey(const Key('sources.connect.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sources.consentMissing')), findsOneWidget);
      expect(
        find.byKey(const Key('sources.consentMissing.review')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('sources.connectFailed')), findsNothing);
    });
  });
}

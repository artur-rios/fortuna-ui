import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/ingestion/data/connection_repository.dart';
import 'package:fortuna_ui/features/ingestion/data/import_job_repository.dart';
import 'package:fortuna_ui/features/ingestion/state/connection_providers.dart';
import 'package:fortuna_ui/features/ingestion/state/import_job_providers.dart';
import 'package:fortuna_ui/features/ingestion/ui/connections_screen.dart';

class FakeConnections implements ConnectionRepository {
  FakeConnections(this.connections);

  Result<List<Connection>> connections;
  Result<String?> syncResult = const Success('job-1');
  Failure<void>? writeFailure;

  final List<String> calls = [];

  @override
  Future<Result<List<Connection>>> list() async => connections;

  @override
  Future<Result<String?>> synchronize(String id) async {
    calls.add('sync:$id');
    return syncResult;
  }

  @override
  Future<Result<void>> reauthenticate(String id) async {
    calls.add('reauth:$id');
    return writeFailure ?? const Success(null);
  }

  @override
  Future<Result<void>> revoke(String id) async {
    calls.add('revoke:$id');
    return writeFailure ?? const Success(null);
  }

  // UC-30 added this to the interface. Defaulted here so the UC-31 tests stay
  // about UC-31; `ConnectableConnections` in data_sources_test.dart is where
  // it is actually exercised.
  @override
  Future<Result<Connection>> connect({
    required String dataSource,
    required String externalReference,
  }) async => Success(
    Connection(
      id: 'new',
      state: BankConnectionState.active,
      connectedAt: DateTime(2026, 9, 11),
      externalReference: externalReference,
    ),
  );
}

class FakeJobs implements ImportJobRepository {
  FakeJobs(this.jobs);

  List<ImportJob> jobs;

  @override
  Future<Result<List<ImportJob>>> list() async => Success(jobs);

  @override
  Future<Result<ImportJob>> read(String id) async =>
      const Failure(message: 'unused', kind: FailureKind.notFound);

  @override
  Future<Result<void>> retry(String id) async => const Success(null);
}

Connection connection({
  String id = 'conn-1',
  BankConnectionState state = BankConnectionState.active,
}) => Connection(
  id: id,
  state: state,
  connectedAt: DateTime(2026, 8, 1),
  externalReference: 'item-abc',
);

ImportJob runningJobFor(String connectionId) => ImportJob(
  id: 'job-running',
  state: JobState.running,
  processed: 42,
  imported: 0,
  duplicates: 0,
  rejected: 0,
  startedAt: DateTime(2026, 9, 8),
  connectionId: connectionId,
);

/// Waits for the jobs stream to emit its first value.
///
/// `StreamProvider.future` waits for the stream to *complete*, and a polling
/// stream never does — so this listens and waits for the first value instead.
Future<void> awaitJobs(ProviderContainer container) async {
  container.listen(importJobsProvider, (_, _) {});

  for (var attempt = 0; attempt < 50; attempt++) {
    if (container.read(importJobsProvider).value != null) return;
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  fail('The jobs stream emitted nothing.');
}

({ProviderContainer container, FakeConnections repo}) harness({
  List<Connection> connections = const [],
  List<ImportJob> jobs = const [],
}) {
  final repo = FakeConnections(Success(connections));
  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      connectionRepositoryProvider.overrideWithValue(repo),
      importJobRepositoryProvider.overrideWithValue(FakeJobs(jobs)),
    ],
  );
  addTearDown(container.dispose);
  return (container: container, repo: repo);
}

void main() {
  group('ConnectionActions.synchronize', () {
    test('Given an active connection '
        'When it is synchronized '
        'Then a job is started (UC-31 main flow)', () async {
      final h = harness(connections: [connection()]);

      final outcome = await h.container
          .read(connectionActionsProvider)
          .synchronize(connection());

      expect(outcome, isA<SyncStarted>());
      expect(h.repo.calls, ['sync:conn-1']);
    });

    test('Given a connection needing reauthentication '
        'When synchronization is attempted '
        'Then no job is started and reauthentication is offered instead '
        '(UC-31 AF-01)', () async {
      final h = harness();

      final outcome = await h.container
          .read(connectionActionsProvider)
          .synchronize(
            connection(state: BankConnectionState.requiresReauthentication),
          );

      expect(outcome, isA<SyncNotAttempted>());
      expect((outcome as SyncNotAttempted).reason, contains('reauthenticated'));
      // A job that would only fail is not started.
      expect(h.repo.calls, isEmpty);
    });

    test('Given a revoked connection '
        'When synchronization is attempted '
        'Then nothing is sent (UC-31 AF-04)', () async {
      final h = harness();

      final outcome = await h.container
          .read(connectionActionsProvider)
          .synchronize(connection(state: BankConnectionState.revoked));

      expect(outcome, isA<SyncNotAttempted>());
      expect(h.repo.calls, isEmpty);
    });

    test('Given a synchronization already running for that connection '
        'When another is asked for '
        'Then the running one is returned and no second is started '
        '(UC-31 AF-06)', () async {
      final h = harness(
        connections: [connection()],
        jobs: [runningJobFor('conn-1')],
      );
      // The jobs list has to have loaded before the check can see it.
      await awaitJobs(h.container);

      final outcome = await h.container
          .read(connectionActionsProvider)
          .synchronize(connection());

      expect(outcome, isA<SyncStarted>());
      expect((outcome as SyncStarted).jobId, 'job-running');
      expect(h.repo.calls, isEmpty);
    });

    test('Given a job running for a DIFFERENT connection '
        'When this one is synchronized '
        'Then it still starts — the check is per connection', () async {
      final h = harness(
        connections: [connection()],
        jobs: [runningJobFor('conn-other')],
      );
      await awaitJobs(h.container);

      await h.container
          .read(connectionActionsProvider)
          .synchronize(connection());

      expect(h.repo.calls, ['sync:conn-1']);
    });

    test('Given the aggregator is unavailable '
        'When synchronization is attempted '
        "Then the API's reason is presented (UC-31 AF-03)", () async {
      final h = harness(connections: [connection()]);
      h.repo.syncResult = const Failure(
        message: 'The aggregator is not responding.',
        kind: FailureKind.unreachable,
      );

      final outcome = await h.container
          .read(connectionActionsProvider)
          .synchronize(connection());

      expect(outcome, isA<SyncFailed>());
      expect(
        (outcome as SyncFailed).reason,
        'The aggregator is not responding.',
      );
    });
  });

  group('ConnectionsScreen', () {
    Future<FakeConnections> pump(
      WidgetTester tester, {
      List<Connection> connections = const [],
      List<ImportJob> jobs = const [],
    }) async {
      tester.view.physicalSize = const Size(1000, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final h = harness(connections: connections, jobs: jobs);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: h.container,
          child: const MaterialApp(home: ConnectionsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      return h.repo;
    }

    testWidgets('Given a connection needing reauthentication '
        'When it is shown '
        'Then that is surfaced prominently and sync is not offered '
        '(UC-31 step 3, AF-01)', (tester) async {
      await pump(
        tester,
        connections: [
          connection(state: BankConnectionState.requiresReauthentication),
        ],
      );

      expect(find.text('Needs reauthentication'), findsOneWidget);
      expect(find.textContaining('stopped bringing data in'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Reauthenticate'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(FilledButton, 'Synchronize now'),
        findsNothing,
      );
    });

    testWidgets(
      'Given a revoked connection '
      'When it is shown '
      'Then only its history appears and no action is offered (UC-31 AF-04)',
      (tester) async {
        await pump(
          tester,
          connections: [connection(state: BankConnectionState.revoked)],
        );

        expect(find.text('Revoked'), findsOneWidget);
        expect(
          find.textContaining('already imported is still here'),
          findsOneWidget,
        );
        expect(find.byType(FilledButton), findsNothing);
        expect(find.widgetWithText(TextButton, 'Revoke'), findsNothing);
      },
    );

    testWidgets('Given revocation is confirmed '
        'When the dialog is read '
        'Then it says imported data is kept (UC-31 step 5, BR-29)', (
      tester,
    ) async {
      final repo = await pump(tester, connections: [connection()]);

      await tester.tap(find.widgetWithText(TextButton, 'Revoke'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Everything it has already imported stays'),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Revoke'));
      await tester.pumpAndSettle();

      expect(repo.calls, ['revoke:conn-1']);
    });

    testWidgets('Given the revoke confirmation '
        'When it is cancelled '
        'Then nothing is revoked', (tester) async {
      final repo = await pump(tester, connections: [connection()]);

      await tester.tap(find.widgetWithText(TextButton, 'Revoke'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(repo.calls, isEmpty);
    });

    testWidgets('Given reauthentication is abandoned '
        'When the dialog is cancelled '
        'Then the connection stays as it was (UC-31 AF-02)', (tester) async {
      final repo = await pump(
        tester,
        connections: [
          connection(state: BankConnectionState.requiresReauthentication),
        ],
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Reauthenticate'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(repo.calls, isEmpty);
      expect(find.text('Needs reauthentication'), findsOneWidget);
    });

    testWidgets(
      'Given no connections '
      'When the screen settles '
      'Then it explains what a connection is and that credentials stay away',
      (tester) async {
        await pump(tester);

        expect(find.text('No connections'), findsOneWidget);
        expect(
          find.textContaining('never holds the credentials'),
          findsOneWidget,
        );
      },
    );
  });

  group('BankConnectionState', () {
    test('Given a status this build does not recognize '
        'When it is mapped '
        'Then it is unknown rather than assumed to be working', () {
      expect(BankConnectionState.from(null), BankConnectionState.unknown);
    });
  });
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_api_client/export.dart' show AuditOutcome;
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/audit/data/audit_repository.dart';
import 'package:fortuna_ui/features/audit/state/audit_providers.dart';
import 'package:fortuna_ui/features/audit/ui/audit_trail_screen.dart';
import 'package:material_ui/material_ui.dart';

class FakeAudit implements AuditRepository {
  FakeAudit(this.next);

  Result<List<AuditEntry>> Function() next;
  final List<AuditFilter> requested = [];

  @override
  Future<Result<List<AuditEntry>>> read(AuditFilter filter) async {
    requested.add(filter);
    return next();
  }
}

AuditEntry entry({
  required DateTime at,
  String operation = 'Update',
  String entityType = 'Transaction',
  AuditResult result = AuditResult.succeeded,
  String? entityId,
  String? reason,
}) => AuditEntry(
  occurredAt: at,
  operation: operation,
  entityType: entityType,
  result: result,
  entityId: entityId,
  reason: reason,
);

Future<FakeAudit> pumpAudit(
  WidgetTester tester,
  Result<List<AuditEntry>> Function() next,
) async {
  tester.view.physicalSize = const Size(1100, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final repository = FakeAudit(next);
  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      auditRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: AuditTrailScreen()),
    ),
  );
  await tester.pumpAndSettle();

  return repository;
}

/// Answers from memory, so no test reaches the network.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, this.status);

  final Object body;
  final int status;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

Dio dioAnswering(Object body, {int status = 200}) =>
    Dio(BaseOptions(baseUrl: 'https://fortuna.example'))
      ..httpClientAdapter = _Adapter(body, status);

Map<String, Object?> auditJson(
  String occurredAt,
  String operation, {
  int outcome = 1,
  String? reason,
}) => {
  'occurredAt': occurredAt,
  'operation': operation,
  'entityType': 'Transaction',
  'outcome': outcome,
  'reason': reason,
};

void main() {
  group('HttpAuditRepository', () {
    test('Given the API returns entries out of order '
        'When they are read '
        'Then the repository puts them newest first (UC-41 step 4)', () async {
      // Sorted by the client rather than trusted from the API: the order a
      // reader depends on should not rest on an undocumented default. This
      // answers deliberately oldest-first to prove the repository sorts.
      final repository = HttpAuditRepository.fromDio(
        dioAnswering({
          'data': [
            auditJson('2026-01-01T00:00:00Z', 'Create'),
            auditJson('2026-09-01T00:00:00Z', 'Delete'),
            auditJson('2026-05-01T00:00:00Z', 'Update'),
          ],
        }),
      );

      final result = await repository.read(const AuditFilter());

      final entries = (result as Success<List<AuditEntry>>).value;
      expect(entries.map((e) => e.operation), ['Delete', 'Update', 'Create']);
    });

    test(
      'Given a refused attempt '
      'When it is read '
      'Then the refusal survives — the trail records attempts, not successes',
      () async {
        final repository = HttpAuditRepository.fromDio(
          dioAnswering({
            'data': [
              auditJson(
                '2026-09-01T00:00:00Z',
                'Delete',
                outcome: 2,
                reason: 'Still referenced.',
              ),
            ],
          }),
        );

        final entries = ((await repository.read(
          const AuditFilter(),
        )) as Success<List<AuditEntry>>).value;

        expect(entries.single.result, AuditResult.refused);
        expect(entries.single.reason, 'Still referenced.');
      },
    );

    test('Given the trail cannot be read '
        'When it is requested '
        "Then the API's reason is carried (UC-41 AF-02)", () async {
      final repository = HttpAuditRepository.fromDio(
        dioAnswering({
          'messages': ['Not available.'],
        }, status: 503),
      );

      final result = await repository.read(const AuditFilter());

      expect(result, isA<Failure<List<AuditEntry>>>());
      expect((result as Failure<List<AuditEntry>>).message, 'Not available.');
    });
  });

  group('AuditResult', () {
    test('Given each outcome the API records '
        'When it is mapped '
        'Then success and refusal are distinguished, and anything else is '
        'unknown rather than assumed to have worked', () {
      expect(AuditResult.from(AuditOutcome.value1), AuditResult.succeeded);
      expect(AuditResult.from(AuditOutcome.value2), AuditResult.refused);
      expect(AuditResult.from(null), AuditResult.unknown);
    });
  });

  group('AuditFilterController', () {
    ProviderContainer containerWith(FakeAudit repository) {
      final container = ProviderContainer(
        overrides: [auditRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('Given a period and an action '
        'When they are set and then the action is cleared '
        'Then the period stays and the action is gone', () {
      final container = containerWith(FakeAudit(() => const Success([])));
      final controller = container.read(auditFilterProvider.notifier);

      controller
        ..setPeriod(from: DateTime(2026), to: DateTime(2026, 2))
        ..setOperation('Delete');
      expect(container.read(auditFilterProvider).operation, 'Delete');

      controller.setOperation(null);

      final filter = container.read(auditFilterProvider);
      expect(filter.operation, isNull);
      expect(filter.from, DateTime(2026));
      expect(filter.to, DateTime(2026, 2));
    });

    test(
      'Given a period and an action '
      'When a period with no start is set '
      'Then the start is gone, the end is the new one and the action stays',
      () {
        final container = containerWith(FakeAudit(() => const Success([])));
        final controller = container.read(auditFilterProvider.notifier)
          ..setPeriod(from: DateTime(2026), to: DateTime(2026, 2))
          ..setOperation('Delete');

        controller.setPeriod(to: DateTime(2026, 3));

        final filter = container.read(auditFilterProvider);
        expect(filter.from, isNull);
        expect(filter.to, DateTime(2026, 3));
        expect(filter.operation, 'Delete');
      },
    );

    test('Given filters are set '
        'When they are cleared '
        'Then nothing is filtered', () {
      final container = containerWith(FakeAudit(() => const Success([])));
      final controller = container.read(auditFilterProvider.notifier)
        ..setPeriod(from: DateTime(2026), to: DateTime(2026, 2))
        ..setOperation('Delete');

      controller.clear();

      expect(container.read(auditFilterProvider).isEmpty, isTrue);
    });

    test('Given a period is set '
        'When the entries are read '
        'Then the request carries it', () async {
      final repository = FakeAudit(() => const Success([]));
      final container = containerWith(repository);

      container
          .read(auditFilterProvider.notifier)
          .setPeriod(from: DateTime(2026), to: DateTime(2026, 2));
      await container.read(auditEntriesProvider.future);

      expect(repository.requested.last.from, DateTime(2026));
      expect(repository.requested.last.to, DateTime(2026, 2));
    });

    test('Given the trail cannot be read '
        'When the entries are asked for '
        "Then it fails with the repository's message (UC-41 AF-02)", () async {
      final container = containerWith(
        FakeAudit(
          () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );
      final subscription = container.listen(auditEntriesProvider, (_, _) {});
      addTearDown(subscription.close);

      await expectLater(
        container.read(auditEntriesProvider.future),
        throwsA(
          isA<AuditUnavailable>().having(
            (error) => error.toString(),
            'toString',
            'The instance could not be reached.',
          ),
        ),
      );
    });
  });

  group('AuditTrailScreen', () {
    testWidgets('Given entries exist '
        'When the screen settles '
        'Then each is shown with what it was and when (UC-41 main flow)', (
      tester,
    ) async {
      await pumpAudit(
        tester,
        () => Success([
          entry(at: DateTime(2026, 9, 1), operation: 'Delete'),
          entry(at: DateTime(2026, 8, 1), operation: 'Create'),
        ]),
      );

      expect(find.text('Delete · Transaction'), findsOneWidget);
      expect(find.text('Create · Transaction'), findsOneWidget);
    });

    testWidgets('Given a refused attempt '
        'When it is shown '
        'Then the refusal and its reason appear', (tester) async {
      await pumpAudit(
        tester,
        () => Success([
          entry(
            at: DateTime(2026, 9, 1),
            operation: 'Delete',
            result: AuditResult.refused,
            reason: 'Live records still reference it.',
          ),
        ]),
      );

      expect(find.byIcon(Icons.block_outlined), findsOneWidget);
      expect(find.text('Live records still reference it.'), findsOneWidget);
    });

    testWidgets('Given an entry about a record since removed '
        'When it is shown '
        'Then it says what it recorded without offering to open it '
        '(UC-41 AF-04)', (tester) async {
      await pumpAudit(
        tester,
        () => Success([entry(at: DateTime(2026, 9, 1), entityId: 'abc-123')]),
      );

      // The identifier is a reference, not a link: the record may be gone,
      // and a tappable row would imply otherwise.
      expect(find.text('Record abc-123'), findsOneWidget);
      final tile = tester.widget<ListTile>(find.byType(ListTile).first);
      expect(tile.onTap, isNull);
    });

    testWidgets('Given the trail '
        'When it is shown at all '
        'Then it says it is append-only and offers no edit or delete '
        '(UC-41 AF-03)', (tester) async {
      await pumpAudit(tester, () => Success([entry(at: DateTime(2026, 9, 1))]));

      expect(find.textContaining('append-only'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsNothing);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('Given no entries and no filters '
        'When the screen settles '
        'Then it says nothing is recorded yet (UC-41 AF-01)', (tester) async {
      await pumpAudit(tester, () => const Success([]));

      expect(find.text('Nothing recorded yet'), findsOneWidget);
      // No "clear filters" offered when none are set.
      expect(find.widgetWithText(FilledButton, 'Clear filters'), findsNothing);
    });

    testWidgets('Given filters that match nothing '
        'When the screen settles '
        'Then it distinguishes that from an empty trail and offers to clear '
        '(UC-41 AF-01)', (tester) async {
      await pumpAudit(tester, () => const Success([]));

      // Tapped by widget rather than by label: a DropdownMenu renders its
      // label in both the field and the menu, so a text finder matches two.
      await tester.tap(find.byType(DropdownMenu<String?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deleted').last);
      await tester.pumpAndSettle();

      expect(find.text('Nothing in that period'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Clear filters'),
        findsOneWidget,
      );
    });

    testWidgets('Given an action filter '
        'When it is chosen '
        'Then the request carries it', (tester) async {
      final repository = await pumpAudit(tester, () => const Success([]));

      // Tapped by widget rather than by label: a DropdownMenu renders its
      // label in both the field and the menu, so a text finder matches two.
      await tester.tap(find.byType(DropdownMenu<String?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deleted').last);
      await tester.pumpAndSettle();

      expect(repository.requested.last.operation, 'Delete');
    });

    testWidgets('Given the trail cannot be read '
        'When the screen settles '
        'Then the reason is shown with a retry (UC-41 AF-02)', (tester) async {
      await pumpAudit(
        tester,
        () => const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });
    testWidgets('Given the trail could not be read '
        'When the user retries and it can be '
        'Then the entries are shown', (tester) async {
      var reachable = false;
      final repository = await pumpAudit(
        tester,
        () => reachable
            ? Success([entry(at: DateTime.utc(2026, 9, 1, 12))])
            : const Failure(
                message: 'The instance could not be reached.',
                kind: FailureKind.unreachable,
              ),
      );

      reachable = true;
      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(repository.requested, hasLength(2));
      expect(find.text('Update · Transaction'), findsOneWidget);
    });

    testWidgets('Given the trail is showing '
        'When it is refreshed '
        'Then it is read again', (tester) async {
      final repository = await pumpAudit(
        tester,
        () => Success([entry(at: DateTime.utc(2026, 9, 1, 12))]),
      );

      await tester.tap(find.byTooltip('Refresh'));
      await tester.pumpAndSettle();

      expect(repository.requested, hasLength(2));
    });

    testWidgets('Given an entry whose outcome this build does not know '
        'When it is listed '
        'Then it is marked as unknown rather than as a success', (
      tester,
    ) async {
      await pumpAudit(
        tester,
        () => Success([
          entry(at: DateTime.utc(2026, 9, 1, 12), result: AuditResult.unknown),
        ]),
      );

      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });

    testWidgets('Given the period filter '
        'When a range is chosen '
        'Then the request carries it and the button no longer says any '
        'period', (tester) async {
      final repository = await pumpAudit(tester, () => const Success([]));

      await tester.tap(find.text('Any period'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      final fields = find.descendant(
        of: find.byType(DateRangePickerDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(0), '01/01/2020');
      await tester.enterText(fields.at(1), '01/31/2020');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(repository.requested.last.from, DateTime(2020));
      expect(repository.requested.last.to, DateTime(2020, 1, 31));
      expect(find.text('Any period'), findsNothing);
    });

    testWidgets('Given the period picker '
        'When it is dismissed '
        'Then no period is set and nothing is read again', (tester) async {
      final repository = await pumpAudit(tester, () => const Success([]));

      await tester.tap(find.text('Any period'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(repository.requested, hasLength(1));
      expect(find.text('Any period'), findsOneWidget);
    });
  });
}

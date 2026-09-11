import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/lifecycle/data/deleted_record_repository.dart';
import 'package:fortuna_ui/features/lifecycle/state/deleted_record_providers.dart';
import 'package:fortuna_ui/features/lifecycle/ui/deleted_records_screen.dart';

class FakeDeletedRecords implements DeletedRecordRepository {
  FakeDeletedRecords({this.onList, this.onRestore, this.onPurge});

  Result<List<DeletedRecord>> Function()? onList;
  Result<void> Function()? onRestore;
  Result<void> Function()? onPurge;

  final List<String> restored = [];
  final List<String> purged = [];

  @override
  Future<Result<List<DeletedRecord>>> list() async =>
      onList?.call() ?? Success([record()]);

  @override
  Future<Result<void>> restore(DeletedRecord record) async {
    restored.add(record.id);
    return onRestore?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> purge(DeletedRecord record) async {
    purged.add(record.id);
    return onPurge?.call() ?? const Success(null);
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowDeletedRecords implements DeletedRecordRepository {
  SlowDeletedRecords(this._pending);

  final Future<Result<List<DeletedRecord>>> _pending;

  @override
  Future<Result<List<DeletedRecord>>> list() => _pending;

  @override
  Future<Result<void>> restore(DeletedRecord record) async =>
      const Success(null);

  @override
  Future<Result<void>> purge(DeletedRecord record) async => const Success(null);
}

DeletedRecord record({
  String id = 'r1',
  RecordKind kind = RecordKind.transaction,
  String label = 'Weekly shop',
  String? detail = 'BRL 125.50',
  int? stillUsedBy,
}) => DeletedRecord(
  id: id,
  kind: kind,
  label: label,
  detail: detail,
  stillUsedBy: stillUsedBy,
);

ProviderContainer containerWith(FakeDeletedRecords fake) {
  final container = ProviderContainer(
    overrides: [
      deletedRecordRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpDeleted(
  WidgetTester tester,
  DeletedRecordRepository fake,
) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        deletedRecordRepositoryProvider.overrideWithValue(fake),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: DeletedRecordsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('DeletedRecord', () {
    test('Given a record nothing points at '
        'When it is asked '
        'Then it is not still referenced', () {
      expect(record().isStillReferenced, isFalse);
      expect(record(stillUsedBy: 0).isStillReferenced, isFalse);
    });

    test('Given live records still pointing at it '
        'When it is asked '
        'Then it reports them (AF-06)', () {
      expect(record(stillUsedBy: 3).isStillReferenced, isTrue);
    });

    test('Given the instance reports no count for this kind '
        'When it is asked '
        'Then that is not the same as a count of zero', () {
      // Null means "not reported"; zero means "reported as none". The screen
      // shows the first as silence and the second as a fact.
      expect(record().stillUsedBy, isNull);
      expect(record(stillUsedBy: 0).stillUsedBy, 0);
    });

    test('Given each kind '
        'When it is labelled '
        'Then it names what it is', () {
      expect(RecordKind.transaction.label, 'Transaction');
      expect(RecordKind.account.label, 'Account');
      expect(RecordKind.category.label, 'Category');
    });
  });

  group('deletedRecordsProvider', () {
    test('Given deleted records '
        'When they are read '
        'Then they come back as the API listed them', () async {
      final fake = FakeDeletedRecords(
        onList: () => Success([
          record(id: 'r1'),
          record(id: 'r2', kind: RecordKind.account),
        ]),
      );

      final list = await containerWith(fake)
          .read(deletedRecordsProvider.future);

      expect(list.map((r) => r.id), ['r1', 'r2']);
    });

    test('Given the list cannot be read '
        'When it is requested '
        "Then the API's reason surfaces (AF-03)", () async {
      final fake = FakeDeletedRecords(
        onList: () => const Failure(
          message: 'Deleted records could not be read.',
          kind: FailureKind.serverError,
        ),
      );

      await expectLater(
        containerWith(fake).read(deletedRecordsProvider.future),
        throwsA(
          isA<DeletedRecordsUnavailable>().having(
            (e) => e.message,
            'message',
            'Deleted records could not be read.',
          ),
        ),
      );
    });
  });

  group('DeletedRecordActions', () {
    test('Given a deleted record '
        'When it is restored '
        'Then the restore reaches the repository (step 2)', () async {
      final fake = FakeDeletedRecords();

      final result = await containerWith(fake)
          .read(deletedRecordActionsProvider)
          .restore(record());

      expect(result.isSuccess, isTrue);
      expect(fake.restored, ['r1']);
    });

    test('Given restoration is refused '
        'When it is attempted '
        "Then the API's reason is carried back unchanged (AF-02)", () async {
      final fake = FakeDeletedRecords(
        onRestore: () => const Failure(
          message:
              'That account cannot be restored while its currency is '
              'no longer supported.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(deletedRecordActionsProvider)
          .restore(record());

      expect(
        result,
        const Failure<void>(
          message:
              'That account cannot be restored while its currency is '
              'no longer supported.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given a deleted record '
        'When it is permanently removed '
        'Then the removal reaches the repository (step 5)', () async {
      final fake = FakeDeletedRecords();

      await containerWith(fake)
          .read(deletedRecordActionsProvider)
          .purge(record());

      expect(fake.purged, ['r1']);
    });

    test('Given live records still reference it '
        'When permanent removal is refused '
        "Then the API's reason names them (AF-01, FR-LC-05)", () async {
      final fake = FakeDeletedRecords(
        onPurge: () => const Failure(
          message: '12 transactions still use this category.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(deletedRecordActionsProvider)
          .purge(record());

      expect(
        result,
        const Failure<void>(
          message: '12 transactions still use this category.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('DeletedRecordsScreen', () {
    testWidgets('Given the records are still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<DeletedRecord>>>();

      await pumpDeletedSlow(tester, pending);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(Success([record()]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('deleted.item.r1')), findsOneWidget);
    });

    testWidgets('Given nothing is deleted '
        'When the screen settles '
        'Then an empty state says so (AF-04)', (tester) async {
      await pumpDeleted(
        tester,
        FakeDeletedRecords(onList: () => const Success([])),
      );

      expect(find.byKey(const Key('deleted.empty')), findsOneWidget);
      expect(find.text('Nothing is deleted'), findsOneWidget);
    });

    testWidgets('Given the list cannot be read '
        'When the screen settles '
        'Then a failure with a retry is shown, not an empty state (AF-03)', (
      tester,
    ) async {
      var attempts = 0;
      final fake = FakeDeletedRecords(
        onList: () {
          attempts++;
          return const Failure(
            message: 'Deleted records could not be read.',
            kind: FailureKind.serverError,
          );
        },
      );

      await pumpDeleted(tester, fake);

      expect(find.byKey(const Key('deleted.empty')), findsNothing);
      expect(find.text('Deleted records could not be read.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('deleted.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given a deleted record '
        'When it is listed '
        'Then it is marked as deleted and names its kind (step 1)', (
      tester,
    ) async {
      await pumpDeleted(tester, FakeDeletedRecords());

      expect(find.byKey(const Key('deleted.badge.r1')), findsOneWidget);
      expect(find.text('Deleted transaction'), findsOneWidget);
    });

    testWidgets('Given a deleted record '
        'When it is listed '
        'Then both actions are offered, kept apart (FR-LC-01)', (tester) async {
      await pumpDeleted(tester, FakeDeletedRecords());

      expect(find.byKey(const Key('deleted.restore.r1')), findsOneWidget);
      expect(find.byKey(const Key('deleted.purge.r1')), findsOneWidget);
    });

    testWidgets('Given a record is restored '
        'When the action is taken '
        'Then it happens without a confirmation, since it can be undone '
        '(step 2)', (tester) async {
      final fake = FakeDeletedRecords();

      await pumpDeleted(tester, fake);
      await tester.tap(find.byKey(const Key('deleted.restore.r1')));
      await tester.pumpAndSettle();

      expect(fake.restored, ['r1']);
    });

    testWidgets('Given restoration is refused '
        'When it returns '
        "Then the API's reason is shown on the record (AF-02)", (tester) async {
      await pumpDeleted(
        tester,
        FakeDeletedRecords(
          onRestore: () => const Failure(
            message: 'That record cannot be restored.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('deleted.restore.r1')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('deleted.reason.r1')), findsOneWidget);
      expect(find.text('That record cannot be restored.'), findsOneWidget);
    });

    testWidgets('Given permanent removal is chosen '
        'When it is confirmed '
        'Then the confirmation says it cannot be undone (step 4, FR-LC-03)', (
      tester,
    ) async {
      await pumpDeleted(tester, FakeDeletedRecords());

      await tester.tap(find.byKey(const Key('deleted.purge.r1')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('deleted.purge.confirm')), findsOneWidget);
      expect(
        find.byKey(const Key('deleted.purge.cannotBeUndone')),
        findsOneWidget,
      );
      expect(find.textContaining('cannot be undone'), findsOneWidget);
    });

    testWidgets('Given the confirmation is declined '
        'When it closes '
        'Then nothing is removed', (tester) async {
      final fake = FakeDeletedRecords();

      await pumpDeleted(tester, fake);
      await tester.tap(find.byKey(const Key('deleted.purge.r1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('deleted.purge.cancel')));
      await tester.pumpAndSettle();

      expect(fake.purged, isEmpty);
    });

    testWidgets('Given the confirmation is accepted '
        'When it proceeds '
        'Then the record is permanently removed (step 5)', (tester) async {
      final fake = FakeDeletedRecords();

      await pumpDeleted(tester, fake);
      await tester.tap(find.byKey(const Key('deleted.purge.r1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('deleted.purge.proceed')));
      await tester.pumpAndSettle();

      expect(fake.purged, ['r1']);
    });

    testWidgets('Given other records still reference it '
        'When removal is confirmed '
        'Then that is said before the decision, not after (AF-06)', (
      tester,
    ) async {
      await pumpDeleted(
        tester,
        FakeDeletedRecords(
          onList: () => Success([
            record(
              kind: RecordKind.category,
              label: 'Groceries',
              stillUsedBy: 12,
            ),
          ]),
        ),
      );

      // Shown on the record itself…
      expect(find.byKey(const Key('deleted.referenced.r1')), findsOneWidget);

      await tester.tap(find.byKey(const Key('deleted.purge.r1')));
      await tester.pumpAndSettle();

      // …and again in the confirmation, before the button is pressed.
      expect(
        find.byKey(const Key('deleted.purge.stillReferenced')),
        findsOneWidget,
      );
      expect(find.textContaining('12 other records'), findsWidgets);
    });

    testWidgets('Given the API refuses the removal '
        'When it returns '
        'Then its reason is shown rather than the control being hidden '
        '(AF-01, FR-LC-05)', (tester) async {
      await pumpDeleted(
        tester,
        FakeDeletedRecords(
          onList: () => Success([record(stillUsedBy: 12)]),
          onPurge: () => const Failure(
            message: '12 transactions still use this category.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      // The control is offered even though something references it: whether
      // the removal is allowed is the API's to decide.
      expect(find.byKey(const Key('deleted.purge.r1')), findsOneWidget);

      await tester.tap(find.byKey(const Key('deleted.purge.r1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('deleted.purge.proceed')));
      await tester.pumpAndSettle();

      expect(
        find.text('12 transactions still use this category.'),
        findsOneWidget,
      );
    });

    testWidgets('Given a record nothing references '
        'When removal is confirmed '
        'Then no cascade warning is invented', (tester) async {
      await pumpDeleted(tester, FakeDeletedRecords());

      await tester.tap(find.byKey(const Key('deleted.purge.r1')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('deleted.purge.stillReferenced')),
        findsNothing,
      );
    });
  });
}

Future<void> pumpDeletedSlow(
  WidgetTester tester,
  Completer<Result<List<DeletedRecord>>> pending,
) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        deletedRecordRepositoryProvider.overrideWithValue(
          SlowDeletedRecords(pending.future),
        ),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: DeletedRecordsScreen()),
    ),
  );
  await tester.pump();
}

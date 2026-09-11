import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/ingestion/data/imported_record_repository.dart';
import 'package:fortuna_ui/features/ingestion/state/imported_record_providers.dart';
import 'package:fortuna_ui/features/ingestion/ui/imported_records_screen.dart';

class FakeImportedRecords implements ImportedRecordRepository {
  FakeImportedRecords({this.onForJob});

  Result<ImportedRecordPage> Function(int pageNumber)? onForJob;

  final List<int> pagesAsked = [];

  @override
  Future<Result<ImportedRecordPage>> forJob(
    String jobId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    pagesAsked.add(pageNumber);
    return onForJob?.call(pageNumber) ?? Success(page());
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowImportedRecords implements ImportedRecordRepository {
  SlowImportedRecords(this._pending);

  final Future<Result<ImportedRecordPage>> _pending;

  @override
  Future<Result<ImportedRecordPage>> forJob(
    String jobId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) => _pending;
}

ImportedRecord record({
  RecordOutcome outcome = RecordOutcome.imported,
  bool hasLiveTransaction = true,
  String? transactionId = 't1',
  String? amount = '125.50',
  String? rawPayload,
  String? rejectionReason,
  String? externalId,
}) => ImportedRecord(
  outcome: outcome,
  hasLiveTransaction: hasLiveTransaction,
  externalId: externalId,
  amount: amount,
  occurredOn: DateTime(2026, 9, 10),
  rawPayload: rawPayload,
  rejectionReason: rejectionReason,
  transactionId: transactionId,
);

ImportedRecordPage page({
  List<ImportedRecord>? items,
  int pageNumber = 1,
  int totalPages = 1,
}) => ImportedRecordPage(
  items: items ?? [record()],
  pageNumber: pageNumber,
  totalPages: totalPages,
);

ProviderContainer containerWith(FakeImportedRecords fake) {
  final container = ProviderContainer(
    overrides: [
      importedRecordRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpRecords(
  WidgetTester tester,
  ImportedRecordRepository fake,
) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        importedRecordRepositoryProvider.overrideWithValue(fake),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: ImportedRecordsScreen(jobId: 'job1')),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('RecordOutcome', () {
    test('Given the numbers the contract specifies '
        'When they are mapped '
        'Then each outcome keeps its own meaning (AF-02)', () {
      expect(RecordOutcome.imported.wire, 1);
      expect(RecordOutcome.duplicate.wire, 2);
      expect(RecordOutcome.rejected.wire, 3);
    });

    test('Given an outcome this build does not recognize '
        'When it is mapped '
        'Then it reads as unknown rather than as imported', () {
      // Guessing "imported" would claim a transaction exists that may not.
      expect(RecordOutcome.from(null), RecordOutcome.unknown);
      expect(RecordOutcome.unknown.producedTransaction, isFalse);
    });

    test('Given each outcome '
        'When asked whether it produced a transaction '
        'Then only an import did', () {
      expect(RecordOutcome.imported.producedTransaction, isTrue);
      expect(RecordOutcome.duplicate.producedTransaction, isFalse);
      expect(RecordOutcome.rejected.producedTransaction, isFalse);
    });
  });

  group('ImportedRecord', () {
    test('Given an imported record with a live transaction '
        'When it is asked '
        'Then the transaction can be opened (step 3)', () {
      expect(record().canOpenTransaction, isTrue);
      expect(record().producedNothing, isFalse);
    });

    test('Given a record whose transaction has been deleted '
        'When it is asked '
        'Then it cannot be opened', () {
      // Offering a link to something that is gone is worse than saying so.
      expect(record(hasLiveTransaction: false).canOpenTransaction, isFalse);
    });

    test('Given a record naming no transaction at all '
        'When it is asked '
        'Then it cannot be opened', () {
      expect(record(transactionId: null).canOpenTransaction, isFalse);
      expect(record(transactionId: '').canOpenTransaction, isFalse);
    });

    test('Given a duplicate or rejected record '
        'When it is asked '
        'Then it produced nothing, and there is a reason to show (AF-02)', () {
      expect(record(outcome: RecordOutcome.duplicate).producedNothing, isTrue);
      expect(record(outcome: RecordOutcome.rejected).producedNothing, isTrue);
    });
  });

  group('ImportedRecordPage', () {
    test('Given a page in the middle '
        'When it is asked '
        'Then both neighbours exist', () {
      final middle = page(pageNumber: 2, totalPages: 3);

      expect(middle.hasPrevious, isTrue);
      expect(middle.hasNext, isTrue);
    });

    test('Given no records '
        'When it is asked '
        'Then it is empty (AF-03)', () {
      expect(page(items: []).isEmpty, isTrue);
    });
  });

  group('importedRecordsProvider', () {
    test('Given a job '
        'When its records are read '
        'Then the page asked for is the one requested', () async {
      final fake = FakeImportedRecords();

      await containerWith(fake).read(
        importedRecordsProvider(
          const RecordPageRequest(jobId: 'job1', pageNumber: 3),
        ).future,
      );

      expect(fake.pagesAsked, [3]);
    });

    test('Given the job does not exist '
        'When its records are read '
        "Then the API's reason surfaces (AF-04)", () async {
      final fake = FakeImportedRecords(
        onForJob: (_) => const Failure(
          message: 'That import job was not found.',
          kind: FailureKind.notFound,
        ),
      );

      await expectLater(
        containerWith(fake).read(
          importedRecordsProvider(const RecordPageRequest(jobId: 'job1'))
              .future,
        ),
        throwsA(
          isA<ImportedRecordsUnavailable>().having(
            (e) => e.message,
            'message',
            'That import job was not found.',
          ),
        ),
      );
    });
  });

  group('RecordPageRequest', () {
    test('Given a request '
        'When a page below one is asked for '
        'Then it clamps to the first', () {
      const request = RecordPageRequest(jobId: 'job1', pageNumber: 2);

      expect(request.atPage(0).pageNumber, 1);
      expect(request.atPage(-5).pageNumber, 1);
      expect(request.atPage(4).pageNumber, 4);
    });

    test('Given two requests for the same page of the same job '
        'When they are compared '
        'Then they are equal, so the page is not re-fetched', () {
      expect(
        const RecordPageRequest(jobId: 'job1', pageNumber: 2),
        const RecordPageRequest(jobId: 'job1', pageNumber: 2),
      );
      expect(
        const RecordPageRequest(jobId: 'job1', pageNumber: 2),
        isNot(const RecordPageRequest(jobId: 'job2', pageNumber: 2)),
      );
    });
  });

  group('ImportedRecordsScreen', () {
    testWidgets('Given the records are still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<ImportedRecordPage>>();

      await pumpRecordsSlow(tester, pending);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(Success(page()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('records.item.1')), findsOneWidget);
    });

    testWidgets('Given the job produced no records '
        'When the screen settles '
        'Then an empty state says so (AF-03)', (tester) async {
      await pumpRecords(
        tester,
        FakeImportedRecords(onForJob: (_) => Success(page(items: []))),
      );

      expect(find.byKey(const Key('records.empty')), findsOneWidget);
      expect(find.text('This import took in no records.'), findsOneWidget);
    });

    testWidgets('Given the job does not exist '
        'When the screen settles '
        'Then it is presented as not found, with a retry (AF-04)', (
      tester,
    ) async {
      await pumpRecords(
        tester,
        FakeImportedRecords(
          onForJob: (_) => const Failure(
            message: 'That import job was not found.',
            kind: FailureKind.notFound,
          ),
        ),
      );

      expect(find.text('That import job was not found.'), findsOneWidget);
      expect(find.byKey(const Key('records.retry')), findsOneWidget);
    });

    testWidgets('Given records '
        'When they are listed '
        'Then they are read-only and the notice says where to correct '
        '(step 4, AF-01)', (tester) async {
      await pumpRecords(tester, FakeImportedRecords());

      expect(find.byKey(const Key('records.readOnlyNotice')), findsOneWidget);
      expect(find.textContaining('cannot be changed'), findsOneWidget);
      expect(
        find.textContaining('open the transaction a record produced'),
        findsOneWidget,
      );

      // Read-only is a property of the screen, not a promise: nothing here
      // accepts input.
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Given a record with a live transaction '
        'When it is listed '
        'Then opening the transaction is offered (step 3)', (tester) async {
      await pumpRecords(tester, FakeImportedRecords());

      expect(
        find.byKey(const Key('records.openTransaction.1')),
        findsOneWidget,
      );
    });

    testWidgets('Given a record whose transaction was deleted '
        'When it is listed '
        'Then it says so rather than offering a broken link', (tester) async {
      await pumpRecords(
        tester,
        FakeImportedRecords(
          onForJob: (_) =>
              Success(page(items: [record(hasLiveTransaction: false)])),
        ),
      );

      expect(find.byKey(const Key('records.openTransaction.1')), findsNothing);
      expect(
        find.byKey(const Key('records.transactionGone.1')),
        findsOneWidget,
      );
    });

    testWidgets('Given a duplicate record '
        'When it is listed '
        'Then the reason no transaction was created is shown (AF-02)', (
      tester,
    ) async {
      await pumpRecords(
        tester,
        FakeImportedRecords(
          onForJob: (_) => Success(
            page(
              items: [
                record(
                  outcome: RecordOutcome.duplicate,
                  hasLiveTransaction: false,
                  transactionId: null,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('records.noTransaction.1')), findsOneWidget);
      expect(find.text('Already present'), findsOneWidget);
      expect(find.textContaining('already present'), findsWidgets);
    });

    testWidgets('Given a rejected record with a reason '
        'When it is listed '
        "Then the API's reason is shown rather than a generic one (AF-02)", (
      tester,
    ) async {
      await pumpRecords(
        tester,
        FakeImportedRecords(
          onForJob: (_) => Success(
            page(
              items: [
                record(
                  outcome: RecordOutcome.rejected,
                  hasLiveTransaction: false,
                  transactionId: null,
                  rejectionReason: 'The amount column could not be read.',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('The amount column could not be read.'), findsOneWidget);
      expect(find.text('Rejected'), findsOneWidget);
    });

    testWidgets('Given a record carrying its raw row '
        'When it is expanded '
        'Then the row is shown verbatim and cannot be edited', (tester) async {
      await pumpRecords(
        tester,
        FakeImportedRecords(
          onForJob: (_) => Success(
            page(items: [record(rawPayload: '2026-09-10;125.50;A MARKET')]),
          ),
        ),
      );

      await tester.tap(find.text('The row as it arrived'));
      await tester.pumpAndSettle();

      expect(find.text('2026-09-10;125.50;A MARKET'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Given more than one page '
        'When the next page is requested '
        'Then the API is asked for it', (tester) async {
      final fake = FakeImportedRecords(
        onForJob: (number) => Success(page(pageNumber: number, totalPages: 3)),
      );

      await pumpRecords(tester, fake);
      await tester.tap(find.byKey(const Key('records.next')));
      await tester.pumpAndSettle();

      expect(fake.pagesAsked.last, 2);
    });

    testWidgets('Given a single page '
        'When it is shown '
        'Then no pager is offered', (tester) async {
      await pumpRecords(tester, FakeImportedRecords());

      expect(find.byKey(const Key('records.pageNumber')), findsNothing);
    });
  });
}

Future<void> pumpRecordsSlow(
  WidgetTester tester,
  Completer<Result<ImportedRecordPage>> pending,
) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        importedRecordRepositoryProvider.overrideWithValue(
          SlowImportedRecords(pending.future),
        ),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: ImportedRecordsScreen(jobId: 'job1')),
    ),
  );
  await tester.pump();
}

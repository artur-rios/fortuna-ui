import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';
import 'package:fortuna_ui/features/transactions/state/transaction_providers.dart';
import 'package:fortuna_ui/features/transactions/ui/transaction_screen.dart';

import '../holdings/accounts_test.dart'
    show FakeAccounts, FakeCurrencies, account;
import 'record_transaction_test.dart' show FakeCards, FakeCategories, treeWith;
import 'transaction_detail_test.dart'
    show EditableTransactions, importedRecord, stored;

/// Extends the UC-20 fake with the reconcile call UC-24 adds.
class ReconcilableTransactions extends EditableTransactions {
  ReconcilableTransactions({super.onRead, this.onReconcile});

  Result<Transaction> Function()? onReconcile;

  final List<Map<String, Object?>> reconciled = [];

  @override
  Future<Result<Transaction>> reconcile({
    required String id,
    int? importedRecordId,
    String? importJobId,
  }) async {
    reconciled.add({
      'id': id,
      'importedRecordId': importedRecordId,
      'importJobId': importJobId,
    });
    return onReconcile?.call() ?? Success(stored(isReconciled: true));
  }
}

ProviderContainer containerWith(ReconcilableTransactions fake) {
  final container = ProviderContainer(
    overrides: [
      transactionRepositoryProvider.overrideWithValue(fake),
      accountRepositoryProvider.overrideWithValue(
        FakeAccounts(onList: () => Success([account()])),
      ),
      creditCardRepositoryProvider.overrideWithValue(FakeCards()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpTransaction(
  WidgetTester tester,
  ReconcilableTransactions fake,
) async {
  tester.view.physicalSize = const Size(1000, 2800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transactionRepositoryProvider.overrideWithValue(fake),
        accountRepositoryProvider.overrideWithValue(
          FakeAccounts(onList: () => Success([account()])),
        ),
        creditCardRepositoryProvider.overrideWithValue(FakeCards()),
        categoryRepositoryProvider.overrideWithValue(
          FakeCategories(tree: treeWith(['Groceries'])),
        ),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: TransactionScreen(transactionId: 't1')),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Transaction.canReconcile', () {
    test('Given an unreconciled transaction '
        'When it is asked '
        'Then reconciling is offered (step 1)', () {
      expect(stored().canReconcile, isTrue);
    });

    test('Given an already-reconciled transaction '
        'When it is asked '
        'Then reconciling is not offered (AF-01)', () {
      expect(stored(isReconciled: true).canReconcile, isFalse);
    });

    test('Given a deleted transaction '
        'When it is asked '
        'Then reconciling is not offered either', () {
      // Vouching for a record that appears in no view would be confirming
      // something the user cannot see.
      expect(stored(isDeleted: true).canReconcile, isFalse);
    });
  });

  group('Transaction.reconciliationKind', () {
    test('Given a transaction that is not reconciled '
        'When its kind is asked '
        'Then there is none', () {
      expect(stored().reconciliationKind, isNull);
    });

    test('Given a reconciliation backed by an imported record '
        'When its kind is asked '
        'Then it reports a match (AF-02)', () {
      final matched = stored(
        isReconciled: true,
        source: TransactionSource.spreadsheet,
        importedRecord: importedRecord(),
      );

      expect(matched.reconciliationKind, ReconciliationKind.matchedToRecord);
    });

    test('Given a reconciliation with no imported record behind it '
        'When its kind is asked '
        "Then it reports the user's own confirmation (AF-02)", () {
      expect(
        stored(isReconciled: true).reconciliationKind,
        ReconciliationKind.selfConfirmed,
      );
    });

    test('Given the two kinds '
        'When their labels are read '
        'Then they say different things', () {
      expect(
        ReconciliationKind.matchedToRecord.label,
        isNot(ReconciliationKind.selfConfirmed.label),
      );
      expect(ReconciliationKind.matchedToRecord.label, isNotEmpty);
      expect(ReconciliationKind.selfConfirmed.label, isNotEmpty);
    });
  });

  group('TransactionActions.reconcile', () {
    test('Given an imported record the API proposed '
        'When the transaction is reconciled '
        'Then the record is what it reconciles against', () async {
      final fake = ReconcilableTransactions();

      await containerWith(fake)
          .read(transactionActionsProvider)
          .reconcile(id: 't1', importedRecordId: 42, importJobId: 'job1');

      expect(fake.reconciled.single['importedRecordId'], 42);
      expect(fake.reconciled.single['importJobId'], 'job1');
    });

    test('Given no imported record '
        'When the user confirms the transaction themselves '
        'Then nothing is sent to match against (AF-02)', () async {
      final fake = ReconcilableTransactions();

      await containerWith(fake)
          .read(transactionActionsProvider)
          .reconcile(id: 't1');

      expect(fake.reconciled.single['importedRecordId'], isNull);
      expect(fake.reconciled.single['importJobId'], isNull);
    });

    test('Given the API refuses the reconciliation '
        'When it is attempted '
        "Then the API's reason is carried back unchanged (AF-03)", () async {
      final fake = ReconcilableTransactions(
        onReconcile: () => const Failure(
          message: 'That imported record is already reconciled elsewhere.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(transactionActionsProvider)
          .reconcile(id: 't1');

      expect(
        result,
        const Failure<Transaction>(
          message: 'That imported record is already reconciled elsewhere.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('Reconciliation on the transaction screen', () {
    testWidgets('Given an unreconciled transaction with no imported record '
        'When it is opened '
        'Then confirming it oneself is offered, and described as that '
        '(AF-02)', (tester) async {
      await pumpTransaction(tester, ReconcilableTransactions());

      expect(find.byKey(const Key('transaction.reconcile')), findsOneWidget);
      expect(find.text('Confirm it myself'), findsOneWidget);
      expect(
        find.textContaining('your own confirmation rather than as a match'),
        findsOneWidget,
      );
    });

    testWidgets('Given an unreconciled transaction with a proposed record '
        'When it is opened '
        'Then the record is shown as the proposed match (step 2)', (
      tester,
    ) async {
      await pumpTransaction(
        tester,
        ReconcilableTransactions(
          onRead: () => Success(
            stored(
              source: TransactionSource.spreadsheet,
              importedRecord: importedRecord(),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('transaction.reconcile')), findsOneWidget);
      expect(find.text('Reconcile'), findsOneWidget);
      expect(
        find.textContaining('proposes the imported record below'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('transaction.importedRecord')),
        findsOneWidget,
      );
    });

    testWidgets('Given a proposed record '
        'When the transaction is reconciled '
        'Then it reconciles against that record (step 3)', (tester) async {
      final fake = ReconcilableTransactions(
        onRead: () => Success(
          stored(
            source: TransactionSource.spreadsheet,
            importedRecord: importedRecord(),
          ),
        ),
      );

      await pumpTransaction(tester, fake);
      await tester.tap(find.byKey(const Key('transaction.reconcile.confirm')));
      await tester.pumpAndSettle();

      expect(fake.reconciled.single['importedRecordId'], 42);
      expect(fake.reconciled.single['importJobId'], 'job1');
    });

    testWidgets('Given no proposed record '
        'When the user confirms it themselves '
        'Then nothing is matched against (AF-02)', (tester) async {
      final fake = ReconcilableTransactions();

      await pumpTransaction(tester, fake);
      await tester.tap(find.byKey(const Key('transaction.reconcile.confirm')));
      await tester.pumpAndSettle();

      expect(fake.reconciled.single['importedRecordId'], isNull);
    });

    testWidgets('Given an already-reconciled transaction '
        'When it is opened '
        'Then the action is not offered and the state is shown (AF-01)', (
      tester,
    ) async {
      await pumpTransaction(
        tester,
        ReconcilableTransactions(
          onRead: () => Success(stored(isReconciled: true)),
        ),
      );

      expect(find.byKey(const Key('transaction.reconcile')), findsNothing);
      expect(find.byKey(const Key('transaction.reconciled')), findsOneWidget);
      expect(find.text('Reconciled'), findsOneWidget);
    });

    testWidgets('Given a transaction reconciled against a record '
        'When it is opened '
        'Then it says it was matched (AF-02)', (tester) async {
      await pumpTransaction(
        tester,
        ReconcilableTransactions(
          onRead: () => Success(
            stored(
              isReconciled: true,
              source: TransactionSource.spreadsheet,
              importedRecord: importedRecord(),
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('transaction.reconciliationKind')),
        findsOneWidget,
      );
      expect(
        find.text(ReconciliationKind.matchedToRecord.label),
        findsOneWidget,
      );
    });

    testWidgets('Given a transaction the user confirmed themselves '
        'When it is opened '
        'Then it says so rather than claiming a match (AF-02)', (tester) async {
      await pumpTransaction(
        tester,
        ReconcilableTransactions(
          onRead: () => Success(stored(isReconciled: true)),
        ),
      );

      expect(find.text(ReconciliationKind.selfConfirmed.label), findsOneWidget);
      expect(find.text(ReconciliationKind.matchedToRecord.label), findsNothing);
    });

    testWidgets('Given the API refuses the reconciliation '
        'When it is attempted '
        "Then the API's reason is shown (AF-03)", (tester) async {
      await pumpTransaction(
        tester,
        ReconcilableTransactions(
          onReconcile: () => const Failure(
            message: 'That imported record is already reconciled elsewhere.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('transaction.reconcile.confirm')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('transaction.reconcile.error')),
        findsOneWidget,
      );
      expect(
        find.text('That imported record is already reconciled elsewhere.'),
        findsOneWidget,
      );
    });

    testWidgets('Given the transaction does not exist '
        'When the screen settles '
        'Then reconciling is not offered (AF-04)', (tester) async {
      await pumpTransaction(
        tester,
        ReconcilableTransactions(
          onRead: () => const Failure(
            message: 'That transaction was not found.',
            kind: FailureKind.notFound,
          ),
        ),
      );

      expect(find.byKey(const Key('transaction.reconcile')), findsNothing);
      expect(find.text('That transaction was not found.'), findsOneWidget);
    });

    testWidgets('Given a deleted transaction '
        'When it is opened '
        'Then reconciling is not offered', (tester) async {
      await pumpTransaction(
        tester,
        ReconcilableTransactions(
          onRead: () => Success(stored(isDeleted: true)),
        ),
      );

      expect(find.byKey(const Key('transaction.reconcile')), findsNothing);
    });
  });
}

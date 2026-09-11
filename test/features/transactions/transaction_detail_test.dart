import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';
import 'package:fortuna_ui/features/transactions/state/transaction_form.dart';
import 'package:fortuna_ui/features/transactions/state/transaction_providers.dart';
import 'package:fortuna_ui/features/transactions/ui/transaction_screen.dart';

import '../holdings/accounts_test.dart'
    show FakeAccounts, FakeCurrencies, account;
import 'record_transaction_test.dart'
    show FakeCards, FakeCategories, FakeTransactions, treeWith;

/// Extends the UC-19 fake with the three calls UC-20 adds, so both use cases
/// exercise one double rather than two that could drift apart.
class EditableTransactions extends FakeTransactions {
  EditableTransactions({this.onRead, this.onUpdate, this.onDelete});

  Result<Transaction> Function()? onRead;
  Result<Transaction> Function()? onUpdate;
  Result<void> Function()? onDelete;

  final List<Map<String, Object?>> updated = [];
  final List<String> deleted = [];

  @override
  Future<Result<Transaction>> read(String id) async =>
      onRead?.call() ?? Success(stored());

  @override
  Future<Result<Transaction>> update({
    required String id,
    required DateTime occurredOn,
    required String amount,
    required Direction direction,
    required String categoryId,
    required String currencyCode,
    String? financialAccountId,
    String? creditCardId,
    String? description,
    String? counterparty,
    List<String> tags = const [],
  }) async {
    updated.add({
      'id': id,
      'occurredOn': occurredOn,
      'amount': amount,
      'direction': direction,
      'categoryId': categoryId,
      'financialAccountId': financialAccountId,
      'creditCardId': creditCardId,
      'description': description,
      'counterparty': counterparty,
      'tags': tags,
    });
    return onUpdate?.call() ?? Success(stored(amount: amount));
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return onDelete?.call() ?? const Success(null);
  }

  // UC-24 added this to the interface. Defaulted here so the UC-20 tests stay
  // about UC-20; `ReconcilableTransactions` in reconcile_transaction_test.dart
  // is where it is actually exercised.
  @override
  Future<Result<Transaction>> reconcile({
    required String id,
    int? importedRecordId,
    String? importJobId,
  }) async => Success(stored(isReconciled: true));

  // UC-25 added this to the interface. Defaulted here so these tests stay
  // about their own use case; `SearchableTransactions` in
  // transactions_table_test.dart is where it is actually exercised.
  @override
  Future<Result<TransactionPage>> search({
    DateTime? from,
    DateTime? to,
    String? financialAccountId,
    String? creditCardId,
    String? categoryId,
    String? tagId,
    String? counterpartyId,
    Direction? direction,
    String? minimumAmount,
    String? maximumAmount,
    String? text,
    String? sortBy,
    bool descending = true,
    int pageNumber = 1,
    int pageSize = 25,
  }) async => const Success(
    TransactionPage(
      items: [],
      pageNumber: 1,
      pageSize: 25,
      totalItems: 0,
      totalPages: 0,
    ),
  );
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowTransactions extends EditableTransactions {
  SlowTransactions(this._pending);

  final Future<Result<Transaction>> _pending;

  @override
  Future<Result<Transaction>> read(String id) => _pending;
}

Transaction stored({
  String id = 't1',
  String amount = '125.50',
  Direction direction = Direction.expense,
  bool isDeleted = false,
  bool isReconciled = false,
  bool isTransfer = false,
  bool isManuallyCorrected = false,
  TransactionSource source = TransactionSource.manual,
  ImportedRecord? importedRecord,
  List<String> tags = const [],
  String? description,
  String? counterparty,
}) => Transaction(
  id: id,
  occurredOn: DateTime(2026, 9, 10),
  amount: Money.parse(amount, 'BRL'),
  direction: direction,
  categoryId: 'cat1',
  categoryName: 'Groceries',
  financialAccountId: 'a1',
  financialAccountName: 'Everyday',
  description: description,
  counterpartyName: counterparty,
  isTransfer: isTransfer,
  isReconciled: isReconciled,
  isDeleted: isDeleted,
  isManuallyCorrected: isManuallyCorrected,
  source: source,
  importedRecord: importedRecord,
  tags: tags,
);

ImportedRecord importedRecord({
  int recordId = 42,
  String? amount = '130.00',
  DateTime? occurredOn,
}) => ImportedRecord(
  recordId: recordId,
  importJobId: 'job1',
  amount: amount == null ? null : Money.parse(amount, 'BRL'),
  occurredOn: occurredOn ?? DateTime(2026, 9, 9),
);

ProviderContainer containerWith(EditableTransactions fake) {
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
  EditableTransactions fake, {
  FakeCategories? categories,
}) async {
  tester.view.physicalSize = const Size(1000, 2600);
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
          categories ?? FakeCategories(tree: treeWith(['Groceries'])),
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
  group('TransactionSource', () {
    test('Given the numbers the contract specifies '
        'When they are mapped '
        'Then each source keeps its own meaning', () {
      expect(TransactionSource.manual.wire, 1);
      expect(TransactionSource.connection.wire, 2);
      expect(TransactionSource.spreadsheet.wire, 3);
      expect(TransactionSource.statementFile.wire, 4);
    });

    test('Given a hand-entered transaction '
        'When its source is asked '
        'Then it is not imported and has no evidence behind it', () {
      expect(TransactionSource.manual.isImported, isFalse);
      expect(TransactionSource.connection.isImported, isTrue);
      expect(TransactionSource.spreadsheet.isImported, isTrue);
      expect(TransactionSource.statementFile.isImported, isTrue);
    });

    test('Given a source the client does not recognize '
        'When it is mapped '
        'Then it reads as manual rather than failing', () {
      expect(TransactionSource.from(null), TransactionSource.manual);
    });
  });

  group('Transaction', () {
    test('Given a live transaction '
        'When it is asked '
        'Then editing is offered', () {
      expect(stored().isEditable, isTrue);
    });

    test('Given a deleted transaction '
        'When it is asked '
        'Then editing is not offered (AF-05)', () {
      expect(stored(isDeleted: true).isEditable, isFalse);
    });
  });

  group('transactionProvider', () {
    test('Given a transaction that does not exist '
        'When it is read '
        "Then the API's not-found reason surfaces (AF-02)", () async {
      final fake = EditableTransactions(
        onRead: () => const Failure(
          message: 'That transaction was not found.',
          kind: FailureKind.notFound,
        ),
      );

      await expectLater(
        containerWith(fake).read(transactionProvider('t1').future),
        throwsA(
          isA<TransactionUnavailable>().having(
            (e) => e.message,
            'message',
            'That transaction was not found.',
          ),
        ),
      );
    });

    test('Given a deleted transaction '
        'When it is read '
        'Then it is returned rather than reported missing (AF-05)', () async {
      final fake = EditableTransactions(
        onRead: () => Success(stored(isDeleted: true)),
      );

      final transaction = await containerWith(fake)
          .read(transactionProvider('t1').future);

      expect(transaction.isDeleted, isTrue);
      expect(transaction.isEditable, isFalse);
    });
  });

  group('TransactionActions', () {
    test('Given a corrected amount '
        'When it is saved '
        'Then the exact decimal reaches the repository as a string', () async {
      final fake = EditableTransactions();

      await containerWith(fake)
          .read(transactionActionsProvider)
          .update(
            id: 't1',
            occurredOn: DateTime(2026, 9, 10),
            amount: Decimal.parse('1234567.89'),
            direction: Direction.expense,
            categoryId: 'cat1',
            currencyCode: 'BRL',
            holdingKind: HoldingKind.account,
            holdingId: 'a1',
          );

      expect(fake.updated.single['amount'], '1234567.89');
    });

    test('Given a change the API refuses '
        'When it is saved '
        "Then the API's reason is carried back unchanged (AF-03)", () async {
      final fake = EditableTransactions(
        onUpdate: () => const Failure(
          message: 'This transaction is on a settled statement.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(transactionActionsProvider)
          .update(
            id: 't1',
            occurredOn: DateTime(2026, 9, 10),
            amount: Decimal.parse('125.50'),
            direction: Direction.expense,
            categoryId: 'cat1',
            currencyCode: 'BRL',
            holdingKind: HoldingKind.account,
            holdingId: 'a1',
          );

      expect(
        result,
        const Failure<Transaction>(
          message: 'This transaction is on a settled statement.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given a transaction '
        'When it is deleted '
        'Then the deletion reaches the repository', () async {
      final fake = EditableTransactions();

      final result = await containerWith(fake)
          .read(transactionActionsProvider)
          .delete('t1');

      expect(result.isSuccess, isTrue);
      expect(fake.deleted, ['t1']);
    });

    test('Given the holding is switched to a card '
        'When it is saved '
        'Then the card id is sent and the account id is not', () async {
      final fake = EditableTransactions();

      await containerWith(fake)
          .read(transactionActionsProvider)
          .update(
            id: 't1',
            occurredOn: DateTime(2026, 9, 10),
            amount: Decimal.parse('125.50'),
            direction: Direction.expense,
            categoryId: 'cat1',
            currencyCode: 'BRL',
            holdingKind: HoldingKind.creditCard,
            holdingId: 'cc1',
          );

      expect(fake.updated.single['creditCardId'], 'cc1');
      expect(fake.updated.single['financialAccountId'], isNull);
    });
  });

  group('TransactionScreen', () {
    testWidgets('Given the transaction is still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<Transaction>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(
              SlowTransactions(pending.future),
            ),
            accountRepositoryProvider.overrideWithValue(FakeAccounts()),
            creditCardRepositoryProvider.overrideWithValue(FakeCards()),
            categoryRepositoryProvider.overrideWithValue(FakeCategories()),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(
            home: TransactionScreen(transactionId: 't1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(Success(stored()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('transaction.amount')), findsOneWidget);
    });

    testWidgets('Given a transaction '
        'When it is opened '
        'Then its fields and its source are shown (step 1, FR-MM-13)', (
      tester,
    ) async {
      await pumpTransaction(
        tester,
        EditableTransactions(
          onRead: () => Success(
            stored(description: 'Weekly shop', tags: ['weekly', 'essentials']),
          ),
        ),
      );

      expect(find.byKey(const Key('transaction.amount')), findsOneWidget);
      expect(find.byKey(const Key('transaction.source')), findsOneWidget);
      expect(find.text('Entered by hand'), findsOneWidget);
      expect(find.text('Weekly shop'), findsOneWidget);
      expect(find.text('weekly, essentials'), findsOneWidget);
    });

    testWidgets('Given the transaction does not exist '
        'When the screen settles '
        'Then it is presented as not found and editing is not offered '
        '(AF-02)', (tester) async {
      await pumpTransaction(
        tester,
        EditableTransactions(
          onRead: () => const Failure(
            message: 'That transaction was not found.',
            kind: FailureKind.notFound,
          ),
        ),
      );

      expect(find.text('That transaction was not found.'), findsOneWidget);
      expect(find.byKey(const Key('transaction.edit')), findsNothing);
    });

    testWidgets('Given a deleted transaction '
        'When it is opened '
        'Then it says so and editing is not offered (AF-05)', (tester) async {
      await pumpTransaction(
        tester,
        EditableTransactions(onRead: () => Success(stored(isDeleted: true))),
      );

      expect(find.byKey(const Key('transaction.deleted')), findsOneWidget);
      expect(find.byKey(const Key('transaction.edit')), findsNothing);
      expect(find.textContaining('can be restored'), findsOneWidget);
    });

    testWidgets('Given an imported transaction '
        'When it is opened '
        'Then the raw record is shown read-only, with the reason (AF-04)', (
      tester,
    ) async {
      await pumpTransaction(
        tester,
        EditableTransactions(
          onRead: () => Success(
            stored(
              source: TransactionSource.spreadsheet,
              importedRecord: importedRecord(),
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('transaction.importedRecord')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('transaction.importedRecord.reason')),
        findsOneWidget,
      );
      expect(find.textContaining('evidence'), findsOneWidget);

      // Read-only: no field of it is editable.
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Given an imported transaction that was corrected '
        'When it is opened '
        'Then the original amount is kept beside the corrected one (AF-04)', (
      tester,
    ) async {
      await pumpTransaction(
        tester,
        EditableTransactions(
          onRead: () => Success(
            stored(
              amount: '125.50',
              source: TransactionSource.spreadsheet,
              isManuallyCorrected: true,
              importedRecord: importedRecord(amount: '130.00'),
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('transaction.manuallyCorrected')),
        findsOneWidget,
      );
      expect(find.textContaining('130.00'), findsWidgets);
      expect(find.textContaining('125.50'), findsWidgets);
    });

    testWidgets('Given a hand-entered transaction '
        'When it is opened '
        'Then there is no imported record to show', (tester) async {
      await pumpTransaction(tester, EditableTransactions());

      expect(find.byKey(const Key('transaction.importedRecord')), findsNothing);
    });

    testWidgets('Given a transfer '
        'When it is opened '
        'Then it is named a transfer rather than an expense (FR-MM-08)', (
      tester,
    ) async {
      await pumpTransaction(
        tester,
        EditableTransactions(onRead: () => Success(stored(isTransfer: true))),
      );

      expect(find.text('Transfer'), findsOneWidget);
      expect(find.text('Expense'), findsNothing);
    });

    testWidgets('Given a reconciled transaction '
        'When it is opened '
        'Then it says so', (tester) async {
      await pumpTransaction(
        tester,
        EditableTransactions(onRead: () => Success(stored(isReconciled: true))),
      );

      expect(find.byKey(const Key('transaction.reconciled')), findsOneWidget);
    });
  });

  group('TransactionEditor', () {
    Future<void> openEditor(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('transaction.edit')));
      await tester.pumpAndSettle();
    }

    testWidgets('Given the editor is opened '
        'When it is shown '
        "Then it carries the transaction's current values", (tester) async {
      await pumpTransaction(
        tester,
        EditableTransactions(
          onRead: () => Success(stored(description: 'Weekly shop')),
        ),
      );
      await openEditor(tester);

      expect(find.text('125.5'), findsOneWidget);
      expect(find.text('Weekly shop'), findsWidgets);
    });

    testWidgets('Given an amount corrected to zero '
        'When it is saved '
        'Then it is rejected in the form and nothing is sent (AF-01)', (
      tester,
    ) async {
      final fake = EditableTransactions();

      await pumpTransaction(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('transactionEditor.amount')),
        '0',
      );
      await tester.tap(find.byKey(const Key('transactionEditor.save')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('transactionEditor.error')), findsOneWidget);
      expect(fake.updated, isEmpty);
    });

    testWidgets('Given a corrected amount '
        'When it is saved '
        'Then the change reaches the repository', (tester) async {
      final fake = EditableTransactions();

      await pumpTransaction(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('transactionEditor.amount')),
        '99.99',
      );
      await tester.tap(find.byKey(const Key('transactionEditor.save')));
      await tester.pumpAndSettle();

      expect(fake.updated.single['amount'], '99.99');
      expect(fake.updated.single['id'], 't1');
    });

    testWidgets('Given the API refuses the change '
        'When it is saved '
        "Then the API's reason is shown and the entry is kept (AF-03)", (
      tester,
    ) async {
      await pumpTransaction(
        tester,
        EditableTransactions(
          onUpdate: () => const Failure(
            message: 'This transaction is on a settled statement.',
            kind: FailureKind.conflict,
          ),
        ),
      );
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('transactionEditor.amount')),
        '99.99',
      );
      await tester.tap(find.byKey(const Key('transactionEditor.save')));
      await tester.pumpAndSettle();

      expect(
        find.text('This transaction is on a settled statement.'),
        findsOneWidget,
      );
      expect(find.text('99.99'), findsOneWidget);
    });

    testWidgets('Given deletion is confirmed '
        'When the user accepts '
        'Then the transaction is deleted (step 4)', (tester) async {
      final fake = EditableTransactions();

      await pumpTransaction(tester, fake);
      await openEditor(tester);
      await tester.tap(find.byKey(const Key('transactionEditor.delete')));
      await tester.pumpAndSettle();

      expect(find.textContaining('can be restored'), findsOneWidget);

      await tester.tap(
        find.byKey(const Key('transactionEditor.delete.confirm')),
      );
      await tester.pumpAndSettle();

      expect(fake.deleted, ['t1']);
    });

    testWidgets('Given deletion is offered '
        'When the user declines '
        'Then nothing is deleted', (tester) async {
      final fake = EditableTransactions();

      await pumpTransaction(tester, fake);
      await openEditor(tester);
      await tester.tap(find.byKey(const Key('transactionEditor.delete')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('transactionEditor.delete.cancel')),
      );
      await tester.pumpAndSettle();

      expect(fake.deleted, isEmpty);
    });

    testWidgets('Given the API refuses the deletion '
        'When it is attempted '
        "Then the API's reason is shown", (tester) async {
      await pumpTransaction(
        tester,
        EditableTransactions(
          onDelete: () => const Failure(
            message: 'This transaction is reconciled and cannot be deleted.',
            kind: FailureKind.conflict,
          ),
        ),
      );
      await openEditor(tester);
      await tester.tap(find.byKey(const Key('transactionEditor.delete')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('transactionEditor.delete.confirm')),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('This transaction is reconciled and cannot be deleted.'),
        findsOneWidget,
      );
    });
  });
}

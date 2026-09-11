import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/format/money_parser.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';
import 'package:fortuna_ui/features/transactions/state/transaction_form.dart';
import 'package:fortuna_ui/features/transactions/ui/record_transaction_screen.dart';

import '../holdings/accounts_test.dart'
    show FakeAccounts, FakeCurrencies, account;

class FakeTransactions implements TransactionRepository {
  FakeTransactions({this.onRecord});

  Result<Transaction> Function()? onRecord;

  final List<Map<String, Object?>> recorded = [];

  @override
  Future<Result<Transaction>> record({
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
    recorded.add({
      'occurredOn': occurredOn,
      'amount': amount,
      'direction': direction,
      'categoryId': categoryId,
      'currencyCode': currencyCode,
      'financialAccountId': financialAccountId,
      'creditCardId': creditCardId,
      'description': description,
      'counterparty': counterparty,
      'tags': tags,
    });
    return onRecord?.call() ?? Success(transaction(amount: amount));
  }
}

class FakeCards implements CreditCardRepository {
  FakeCards({this.cards = const []});

  final List<CreditCard> cards;

  @override
  Future<Result<List<CreditCard>>> list() async => Success(cards);

  @override
  Future<Result<CreditCard>> read(String id) async =>
      const Failure(message: 'not found', kind: FailureKind.notFound);

  @override
  Future<Result<void>> create({
    required String name,
    required String currencyCode,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
    String? lastFourDigits,
  }) async => const Success(null);

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
  }) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);
}

class FakeCategories implements CategoryRepository {
  FakeCategories({this.tree});

  final CategoryTree? tree;

  @override
  Future<Result<CategoryTree>> readTree() async =>
      Success(tree ?? const CategoryTree(roots: []));

  @override
  Future<Result<void>> create({required String name, String? parentId}) async =>
      const Success(null);

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    String? parentId,
  }) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<void>> reassign({
    required String fromId,
    required String toId,
    bool includeDescendants = false,
  }) async => const Success(null);
}

/// Answers only when the test lets it, so the loading state is observable at
/// all — a fake that answers in a microtask has already resolved by the first
/// pump.
class SlowAccounts extends FakeAccounts {
  SlowAccounts(this._pending);

  final Future<Result<List<FinancialAccount>>> _pending;

  @override
  Future<Result<List<FinancialAccount>>> list() => _pending;
}

CreditCard card({String id = 'cc1', String name = 'Everyday card'}) =>
    CreditCard(
      id: id,
      name: name,
      currencyCode: 'BRL',
      creditLimit: Money.parse('5000.00', 'BRL'),
      usedAmount: Money.parse('0', 'BRL'),
      availableAmount: Money.parse('5000.00', 'BRL'),
      overageAmount: Money.parse('0', 'BRL'),
      closingDay: 20,
      dueDay: 28,
    );

Transaction transaction({
  String id = 't1',
  String amount = '125.50',
  Direction direction = Direction.expense,
  String? categoryName = 'Groceries',
}) => Transaction(
  id: id,
  occurredOn: DateTime(2026, 9, 10),
  amount: Money.parse(amount, 'BRL'),
  direction: direction,
  categoryId: 'cat1',
  categoryName: categoryName,
  financialAccountId: 'a1',
);

CategoryTree treeWith(List<String> names) => CategoryTree(
  roots: [
    for (var i = 0; i < names.length; i++)
      Category(id: 'cat${i + 1}', name: names[i], children: const []),
  ],
);

ProviderContainer containerWith(FakeTransactions fake) {
  final container = ProviderContainer(
    overrides: [
      transactionRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpRecord(
  WidgetTester tester, {
  FakeTransactions? transactions,
  FakeAccounts? accounts,
  FakeCards? cards,
  FakeCategories? categories,
}) async {
  tester.view.physicalSize = const Size(1000, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transactionRepositoryProvider.overrideWithValue(
          transactions ?? FakeTransactions(),
        ),
        accountRepositoryProvider.overrideWithValue(
          accounts ?? FakeAccounts(onList: () => Success([account()])),
        ),
        creditCardRepositoryProvider.overrideWithValue(cards ?? FakeCards()),
        categoryRepositoryProvider.overrideWithValue(
          categories ?? FakeCategories(tree: treeWith(['Groceries'])),
        ),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: RecordTransactionScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Fills the three required fields with something valid.
Future<void> fillValidForm(
  WidgetTester tester, {
  String amount = '125.50',
}) async {
  await tester.enterText(
    find.byKey(const Key('recordTransaction.amount')),
    amount,
  );
  await tester.tap(find.byKey(const Key('recordTransaction.holding')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Everyday · BRL').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('recordTransaction.category')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Groceries').last);
  await tester.pumpAndSettle();
}

void main() {
  final parser = MoneyParser('en_US');
  final now = DateTime(2026, 9, 10, 12);

  group('TransactionRules.isWithinDateLimit', () {
    test('Given today or the past '
        'When it is checked '
        'Then it is accepted', () {
      expect(
        TransactionRules.isWithinDateLimit(DateTime(2026, 9, 10), now: now),
        isTrue,
      );
      expect(
        TransactionRules.isWithinDateLimit(DateTime(2020), now: now),
        isTrue,
      );
    });

    test('Given tomorrow '
        'When it is checked '
        'Then it is accepted, at any hour of it (FR-MM-04)', () {
      expect(
        TransactionRules.isWithinDateLimit(DateTime(2026, 9, 11), now: now),
        isTrue,
      );
      expect(
        TransactionRules.isWithinDateLimit(
          DateTime(2026, 9, 11, 23, 59),
          now: now,
        ),
        isTrue,
      );
    });

    test('Given the day after tomorrow '
        'When it is checked '
        'Then it is refused (AF-02)', () {
      expect(
        TransactionRules.isWithinDateLimit(DateTime(2026, 9, 12), now: now),
        isFalse,
      );
    });
  });

  group('TransactionRules.validate', () {
    FormProblem? validate({
      String amountText = '125.50',
      DateTime? occurredOn,
      String? categoryId = 'cat1',
      String? holdingId = 'a1',
      MoneyParser? withParser,
    }) => TransactionRules.validate(
      amountText: amountText,
      occurredOn: occurredOn ?? DateTime(2026, 9, 10),
      categoryId: categoryId,
      holdingId: holdingId,
      parser: withParser ?? parser,
      now: now,
    );

    test('Given a complete, valid entry '
        'When it is validated '
        'Then nothing is refused', () {
      expect(validate(), isNull);
    });

    test('Given an amount that is not a number '
        'When it is validated '
        'Then it is refused as unreadable (AF-01)', () {
      expect(validate(amountText: 'abc'), FormProblem.amountUnreadable);
      expect(validate(amountText: ''), FormProblem.amountUnreadable);
    });

    test('Given zero or a negative amount '
        'When it is validated '
        'Then it is refused as not positive (AF-01)', () {
      expect(validate(amountText: '0'), FormProblem.amountNotPositive);
      expect(validate(amountText: '-5.00'), FormProblem.amountNotPositive);
    });

    test('Given a date more than one day ahead '
        'When it is validated '
        'Then it is refused (AF-02)', () {
      expect(
        validate(occurredOn: DateTime(2026, 9, 20)),
        FormProblem.dateTooFarAhead,
      );
    });

    test('Given no category '
        'When it is validated '
        'Then it is refused (AF-03)', () {
      expect(validate(categoryId: null), FormProblem.missingCategory);
      expect(validate(categoryId: ''), FormProblem.missingCategory);
    });

    test('Given no account or card '
        'When it is validated '
        'Then it is refused (AF-03)', () {
      expect(validate(holdingId: null), FormProblem.missingHolding);
    });

    test('Given an amount written for another locale '
        'When it is validated in that locale '
        'Then it is accepted (AF-08)', () {
      expect(
        validate(amountText: '1.234,56', withParser: MoneyParser('pt_BR')),
        isNull,
      );
    });

    test('Given the date is refused and the category is also missing '
        'When it is validated '
        'Then the amount and date are reported before the selections', () {
      expect(
        validate(occurredOn: DateTime(2026, 9, 20), categoryId: null),
        FormProblem.dateTooFarAhead,
      );
    });
  });

  group('FormProblem messages', () {
    test('Given the future-date refusal '
        'When its message is read '
        'Then it explains what a future movement is instead (FR-MM-04)', () {
      expect(
        FormProblem.dateTooFarAhead.message,
        contains('recurring commitment or a projection'),
      );
    });

    test('Given every problem '
        'When its message is read '
        'Then none is empty', () {
      for (final problem in FormProblem.values) {
        expect(problem.message, isNotEmpty);
      }
    });
  });

  group('TransactionFormActions', () {
    test('Given an account was chosen '
        'When the transaction is submitted '
        'Then the account id is sent and the card id is not', () async {
      final fake = FakeTransactions();

      await containerWith(fake)
          .read(transactionFormActionsProvider)
          .submit(
            occurredOn: DateTime(2026, 9, 10),
            amount: Decimal.parse('125.50'),
            direction: Direction.expense,
            categoryId: 'cat1',
            currencyCode: 'BRL',
            holdingKind: HoldingKind.account,
            holdingId: 'a1',
          );

      expect(fake.recorded.single['financialAccountId'], 'a1');
      expect(fake.recorded.single['creditCardId'], isNull);
    });

    test('Given a card was chosen '
        'When the transaction is submitted '
        'Then the card id is sent and the account id is not', () async {
      final fake = FakeTransactions();

      await containerWith(fake)
          .read(transactionFormActionsProvider)
          .submit(
            occurredOn: DateTime(2026, 9, 10),
            amount: Decimal.parse('125.50'),
            direction: Direction.expense,
            categoryId: 'cat1',
            currencyCode: 'BRL',
            holdingKind: HoldingKind.creditCard,
            holdingId: 'cc1',
          );

      expect(fake.recorded.single['creditCardId'], 'cc1');
      expect(fake.recorded.single['financialAccountId'], isNull);
    });

    test('Given an amount a double would corrupt '
        'When it is submitted '
        'Then the exact decimal reaches the repository as a string', () async {
      final fake = FakeTransactions();

      await containerWith(fake)
          .read(transactionFormActionsProvider)
          .submit(
            occurredOn: DateTime(2026, 9, 10),
            amount: Decimal.parse('1234567.89'),
            direction: Direction.expense,
            categoryId: 'cat1',
            currencyCode: 'BRL',
            holdingKind: HoldingKind.account,
            holdingId: 'a1',
          );

      expect(fake.recorded.single['amount'], '1234567.89');
    });
  });

  group('RecordTransactionScreen', () {
    testWidgets('Given the form is still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<FinancialAccount>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(FakeTransactions()),
            accountRepositoryProvider.overrideWithValue(
              SlowAccounts(pending.future),
            ),
            creditCardRepositoryProvider.overrideWithValue(FakeCards()),
            categoryRepositoryProvider.overrideWithValue(
              FakeCategories(tree: treeWith(['Groceries'])),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: RecordTransactionScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(Success([account()]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordTransaction.amount')), findsOneWidget);
    });

    testWidgets('Given no account and no card '
        'When the form is opened '
        'Then it directs the user to create one rather than showing empty '
        'pickers (AF-07)', (tester) async {
      await pumpRecord(
        tester,
        accounts: FakeAccounts(onList: () => const Success([])),
      );

      expect(
        find.byKey(const Key('recordTransaction.nothingToRecordAgainst')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('recordTransaction.amount')), findsNothing);
      expect(
        find.byKey(const Key('recordTransaction.createAccount')),
        findsOneWidget,
      );
    });

    testWidgets('Given no category '
        'When the form is opened '
        'Then it directs the user to create one (AF-07)', (tester) async {
      await pumpRecord(tester, categories: FakeCategories());

      expect(
        find.byKey(const Key('recordTransaction.nothingToRecordAgainst')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('recordTransaction.createCategory')),
        findsOneWidget,
      );
    });

    testWidgets('Given an account and a category exist '
        'When the form is opened '
        'Then the form is shown', (tester) async {
      await pumpRecord(tester);

      expect(find.byKey(const Key('recordTransaction.amount')), findsOneWidget);
      expect(
        find.byKey(const Key('recordTransaction.nothingToRecordAgainst')),
        findsNothing,
      );
    });

    testWidgets('Given an amount of zero '
        'When it is submitted '
        'Then it is refused in the form and nothing is sent (AF-01)', (
      tester,
    ) async {
      final fake = FakeTransactions();

      await pumpRecord(tester, transactions: fake);
      await fillValidForm(tester, amount: '0');
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordTransaction.error')), findsOneWidget);
      expect(find.text(FormProblem.amountNotPositive.message), findsOneWidget);
      expect(fake.recorded, isEmpty);
    });

    testWidgets('Given an amount that is not a number '
        'When it is submitted '
        'Then it is refused with the reason (AF-01)', (tester) async {
      final fake = FakeTransactions();

      await pumpRecord(tester, transactions: fake);
      await fillValidForm(tester, amount: 'not a number');
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(find.text(FormProblem.amountUnreadable.message), findsOneWidget);
      expect(fake.recorded, isEmpty);
    });

    testWidgets('Given no category is chosen '
        'When it is submitted '
        'Then it is refused (AF-03)', (tester) async {
      final fake = FakeTransactions();

      await pumpRecord(tester, transactions: fake);
      await tester.enterText(
        find.byKey(const Key('recordTransaction.amount')),
        '125.50',
      );
      await tester.tap(find.byKey(const Key('recordTransaction.holding')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Everyday · BRL').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(find.text(FormProblem.missingCategory.message), findsOneWidget);
      expect(fake.recorded, isEmpty);
    });

    testWidgets('Given a complete entry '
        'When it is submitted '
        'Then the amount is sent as an exact decimal string (FR-MM-02)', (
      tester,
    ) async {
      final fake = FakeTransactions();

      await pumpRecord(tester, transactions: fake);
      await fillValidForm(tester, amount: '125.50');
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(fake.recorded.single['amount'], '125.5');
      expect(fake.recorded.single['financialAccountId'], 'a1');
      expect(fake.recorded.single['categoryId'], 'cat1');
      expect(fake.recorded.single['currencyCode'], 'BRL');
    });

    testWidgets('Given the API accepted the transaction '
        'When the response returns '
        'Then the confirmation shows what the API stored (step 6)', (
      tester,
    ) async {
      await pumpRecord(
        tester,
        transactions: FakeTransactions(
          // Deliberately different from what the form submitted: the screen
          // must show the API's record, not its own copy.
          onRecord: () => Success(transaction(amount: '999.99')),
        ),
      );
      await fillValidForm(tester, amount: '125.50');
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('recordTransaction.confirmation')),
        findsOneWidget,
      );
      expect(find.textContaining('999.99'), findsWidgets);
    });

    testWidgets('Given the API refuses for a rule the client does not enforce '
        'When the refusal returns '
        'Then its reason is shown and the entry is kept (AF-05)', (
      tester,
    ) async {
      await pumpRecord(
        tester,
        transactions: FakeTransactions(
          onRecord: () => const Failure(
            message: 'This account is closed and cannot take transactions.',
            kind: FailureKind.conflict,
          ),
        ),
      );
      await fillValidForm(tester, amount: '125.50');
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('This account is closed and cannot take transactions.'),
        findsOneWidget,
      );

      // The entry survived the refusal.
      expect(find.text('125.50'), findsOneWidget);
      expect(
        find.byKey(const Key('recordTransaction.confirmation')),
        findsNothing,
      );
    });

    testWidgets('Given the submission fails at the transport '
        'When the failure returns '
        'Then nothing is reported as recorded and the entry is preserved '
        '(AF-06)', (tester) async {
      await pumpRecord(
        tester,
        transactions: FakeTransactions(
          onRecord: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );
      await fillValidForm(tester, amount: '125.50');
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(
        find.byKey(const Key('recordTransaction.confirmation')),
        findsNothing,
      );
      expect(find.text('125.50'), findsOneWidget);

      // And the retry is still available.
      expect(find.byKey(const Key('recordTransaction.submit')), findsOneWidget);
    });

    testWidgets('Given a transport failure then a success '
        'When the user retries with the preserved entry '
        'Then the transaction is recorded (AF-06)', (tester) async {
      var attempts = 0;
      final fake = FakeTransactions(
        onRecord: () {
          attempts++;
          return attempts == 1
              ? const Failure<Transaction>(
                  message: 'The instance could not be reached.',
                  kind: FailureKind.unreachable,
                )
              : Success(transaction());
        },
      );

      await pumpRecord(tester, transactions: fake);
      await fillValidForm(tester, amount: '125.50');
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
      expect(fake.recorded.length, 2);
      expect(fake.recorded.last['amount'], '125.5');
      expect(
        find.byKey(const Key('recordTransaction.confirmation')),
        findsOneWidget,
      );
    });

    testWidgets('Given a card is chosen instead of an account '
        'When it is submitted '
        'Then the card id is sent', (tester) async {
      final fake = FakeTransactions();

      await pumpRecord(
        tester,
        transactions: fake,
        accounts: FakeAccounts(onList: () => const Success([])),
        cards: FakeCards(cards: [card()]),
      );

      await tester.enterText(
        find.byKey(const Key('recordTransaction.amount')),
        '125.50',
      );
      await tester.tap(find.byKey(const Key('recordTransaction.holding')));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Everyday card').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('recordTransaction.category')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Groceries').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(fake.recorded.single['creditCardId'], 'cc1');
      expect(fake.recorded.single['financialAccountId'], isNull);
    });

    testWidgets('Given the direction is switched to earning '
        'When it is submitted '
        'Then an earning is recorded', (tester) async {
      final fake = FakeTransactions();

      await pumpRecord(tester, transactions: fake);
      await tester.tap(find.text('Earning'));
      await tester.pumpAndSettle();
      await fillValidForm(tester);
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(fake.recorded.single['direction'], Direction.earning);
    });

    testWidgets('Given tags and a counterparty '
        'When the transaction is submitted '
        'Then both reach the repository (FR-MM-05)', (tester) async {
      final fake = FakeTransactions();

      await pumpRecord(tester, transactions: fake);
      await fillValidForm(tester);
      await tester.enterText(
        find.byKey(const Key('recordTransaction.tags')),
        'weekly, essentials',
      );
      await tester.enterText(
        find.byKey(const Key('recordTransaction.counterparty')),
        'A Market',
      );
      await tester.tap(find.byKey(const Key('recordTransaction.submit')));
      await tester.pumpAndSettle();

      expect(fake.recorded.single['tags'], ['weekly', 'essentials']);
      expect(fake.recorded.single['counterparty'], 'A Market');
    });

    testWidgets('Given an account is chosen '
        'When the amount field is shown '
        "Then it carries the account's currency (FR-PS-04)", (tester) async {
      await pumpRecord(tester);
      await tester.tap(find.byKey(const Key('recordTransaction.holding')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Everyday · BRL').last);
      await tester.pumpAndSettle();

      expect(find.text('BRL'), findsWidgets);
    });
  });
}

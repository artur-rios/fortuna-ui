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
import 'package:fortuna_ui/features/planning/data/budget_repository.dart';
import 'package:fortuna_ui/features/planning/state/budget_providers.dart';
import 'package:fortuna_ui/features/planning/ui/budgets_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

import '../holdings/accounts_test.dart' show FakeCurrencies;
import '../transactions/record_transaction_test.dart'
    show FakeCategories, treeWith;

class FakeBudgets implements BudgetRepository {
  FakeBudgets({this.onList, this.onCreate, this.onUpdate, this.onDelete});

  Result<List<Budget>> Function()? onList;
  Result<void> Function()? onCreate;
  Result<void> Function()? onUpdate;
  Result<void> Function()? onDelete;

  final List<Map<String, Object?>> created = [];
  final List<Map<String, Object?>> updated = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<Budget>>> list() async =>
      onList?.call() ?? const Success([]);

  @override
  Future<Result<Budget>> read(String id) async => const Failure(
    message: 'That budget was not found.',
    kind: FailureKind.notFound,
  );

  @override
  Future<Result<void>> create({
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants = false,
  }) async {
    created.add({
      'categoryIds': categoryIds,
      'amount': amount,
      'currencyCode': currencyCode,
      'period': period,
      'periodStart': periodStart,
      'includeDescendants': includeDescendants,
    });
    return onCreate?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> update({
    required String id,
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants = false,
  }) async {
    updated.add({'id': id, 'amount': amount, 'period': period});
    return onUpdate?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return onDelete?.call() ?? const Success(null);
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowBudgets extends FakeBudgets {
  SlowBudgets(this._pending);

  final Future<Result<List<Budget>>> _pending;

  @override
  Future<Result<List<Budget>>> list() => _pending;
}

Budget budget({
  String id = 'b1',
  String amount = '800.00',
  String? spent = '550.25',
  String? remaining = '249.75',
  String? overage,
  bool? isExceeded = false,
  BudgetPeriod period = BudgetPeriod.monthly,
  List<String> categoryNames = const ['Groceries'],
  bool includeDescendants = false,
  bool withConsumption = true,
}) => Budget(
  id: id,
  amount: Money.parse(amount, 'BRL'),
  period: period,
  periodStart: DateTime(2026, 9),
  categoryNames: categoryNames,
  includeDescendants: includeDescendants,
  consumption: withConsumption
      ? BudgetConsumption(
          periodStart: DateTime(2026, 9),
          periodEnd: DateTime(2026, 9, 30),
          spent: spent == null ? null : Money.parse(spent, 'BRL'),
          remaining: remaining == null ? null : Money.parse(remaining, 'BRL'),
          overage: overage == null ? null : Money.parse(overage, 'BRL'),
          isExceeded: isExceeded,
        )
      : null,
);

ProviderContainer containerWith(FakeBudgets fake) {
  final container = ProviderContainer(
    overrides: [
      budgetRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpBudgets(
  WidgetTester tester,
  FakeBudgets fake, {
  FakeCategories? categories,
}) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        budgetRepositoryProvider.overrideWithValue(fake),
        categoryRepositoryProvider.overrideWithValue(
          categories ?? FakeCategories(tree: treeWith(['Groceries'])),
        ),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: BudgetsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Chooses a period start through the date picker, which the form requires
/// before anything else about the period can be judged.
Future<void> choosePeriodStart(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('budgetEditor.periodStart')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  final parser = MoneyParser('en_US');

  group('BudgetPeriod', () {
    test('Given the numbers the contract specifies '
        'When they are mapped '
        'Then each period keeps its own number', () {
      expect(BudgetPeriod.monthly.wire, 1);
      expect(BudgetPeriod.quarterly.wire, 2);
      expect(BudgetPeriod.yearly.wire, 3);
    });

    test('Given a period the client does not recognize '
        'When it is mapped '
        'Then it reads as monthly rather than failing', () {
      expect(BudgetPeriod.from(null), BudgetPeriod.monthly);
    });
  });

  group('Budget consumption', () {
    test('Given consumption the API computed '
        'When it is read '
        'Then every figure is the API\'s, not derived (FR-OR-07)', () {
      final within = budget(
        amount: '800.00',
        spent: '550.25',
        // Deliberately not 800 - 550.25: the API's figure stands even where
        // the obvious arithmetic disagrees.
        remaining: '249.00',
      );

      expect(within.consumption!.spent!.amount, Decimal.parse('550.25'));
      expect(within.consumption!.remaining!.amount, Decimal.parse('249.00'));
      expect(within.amount.amount, Decimal.parse('800.00'));
    });

    test('Given the API reports the budget exceeded '
        'When it is asked '
        'Then its verdict is used rather than a local comparison', () {
      final over = budget(
        amount: '800.00',
        spent: '900.00',
        remaining: '0',
        overage: '100.00',
        isExceeded: true,
      );

      expect(over.isExceeded, isTrue);
      expect(over.consumption!.overage!.amount, Decimal.parse('100.00'));
    });

    test('Given spending above the ceiling but no verdict from the API '
        'When it is asked '
        'Then nothing is concluded locally', () {
      // The figures alone would suggest "exceeded". Without the API saying
      // so, the client does not decide.
      final unclear = budget(
        amount: '800.00',
        spent: '900.00',
        remaining: '0',
        isExceeded: null,
      );

      expect(unclear.isExceeded, isFalse);
    });

    test('Given no consumption at all '
        'When it is asked '
        'Then the absence is reported rather than a zero (AF-04)', () {
      expect(budget(withConsumption: false).hasNoConsumption, isTrue);
      expect(budget(spent: null, remaining: null).hasNoConsumption, isTrue);
      expect(budget().hasNoConsumption, isFalse);
    });

    test('Given an amount a double would not represent exactly '
        'When it is held '
        'Then it survives unchanged', () {
      expect(
        budget(amount: '1234567.89').amount.amount,
        Decimal.parse('1234567.89'),
      );
    });
  });

  group('BudgetRules.validate', () {
    BudgetProblem? validate({
      String amountText = '800.00',
      DateTime? periodStart,
      List<String> categoryIds = const ['cat1'],
    }) => BudgetRules.validate(
      amountText: amountText,
      periodStart: periodStart ?? DateTime(2026, 9),
      categoryIds: categoryIds,
      isReadableAmount: (text) => parser.parse(text) != null,
      isPositiveAmount: parser.isPositive,
    );

    test('Given a complete, valid entry '
        'When it is validated '
        'Then nothing is refused', () {
      expect(validate(), isNull);
    });

    test('Given an amount that is not greater than zero '
        'When it is validated '
        'Then it is refused (AF-01)', () {
      expect(validate(amountText: '0'), BudgetProblem.amountNotPositive);
      expect(validate(amountText: '-5'), BudgetProblem.amountNotPositive);
    });

    test('Given an amount that is not a number '
        'When it is validated '
        'Then it is refused as unreadable (AF-01)', () {
      expect(validate(amountText: 'abc'), BudgetProblem.amountUnreadable);
      expect(validate(amountText: ''), BudgetProblem.amountUnreadable);
    });

    test('Given no period start '
        'When it is validated '
        'Then the period is refused as malformed (AF-02)', () {
      expect(
        BudgetRules.validate(
          amountText: '800.00',
          periodStart: null,
          categoryIds: const ['cat1'],
          isReadableAmount: (text) => parser.parse(text) != null,
          isPositiveAmount: parser.isPositive,
        ),
        BudgetProblem.missingPeriodStart,
      );
    });

    test('Given no category '
        'When it is validated '
        'Then it is refused', () {
      expect(validate(categoryIds: const []), BudgetProblem.missingCategory);
    });

    test('Given every problem '
        'When its message is read '
        'Then none is empty', () {
      for (final problem in BudgetProblem.values) {
        expect(problem.message, isNotEmpty);
      }
    });
  });

  group('budgetsProvider', () {
    test('Given budgets '
        'When they are read '
        'Then they are returned in the order the API sent them', () async {
      final fake = FakeBudgets(
        onList: () => Success([budget(id: 'b1'), budget(id: 'b2')]),
      );

      final list = await containerWith(fake).read(budgetsProvider.future);

      expect(list.map((b) => b.id), ['b1', 'b2']);
    });

    test('Given the list cannot be read '
        'When it is requested '
        "Then the API's reason surfaces", () async {
      final fake = FakeBudgets(
        onList: () => const Failure(
          message: 'Budgets could not be read.',
          kind: FailureKind.serverError,
        ),
      );

      await expectLater(
        containerWith(fake).read(budgetsProvider.future),
        throwsA(
          isA<BudgetsUnavailable>().having(
            (e) => e.message,
            'message',
            'Budgets could not be read.',
          ),
        ),
      );
    });
  });

  group('BudgetActions', () {
    test('Given a new budget '
        'When it is created '
        'Then the exact amount reaches the repository as a string', () async {
      final fake = FakeBudgets();

      await containerWith(fake)
          .read(budgetActionsProvider)
          .create(
            categoryIds: const ['cat1'],
            amount: '1234567.89',
            currencyCode: 'BRL',
            period: BudgetPeriod.monthly,
            periodStart: DateTime(2026, 9),
          );

      expect(fake.created.single['amount'], '1234567.89');
      expect(fake.created.single['categoryIds'], ['cat1']);
    });

    test('Given a budget already covers that category and period '
        'When one is created '
        "Then the API's refusal is carried back unchanged (AF-03)", () async {
      final fake = FakeBudgets(
        onCreate: () => const Failure(
          message: 'A budget already covers Groceries for September.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(budgetActionsProvider)
          .create(
            categoryIds: const ['cat1'],
            amount: '800.00',
            currencyCode: 'BRL',
            period: BudgetPeriod.monthly,
            periodStart: DateTime(2026, 9),
          );

      expect(
        result,
        const Failure<void>(
          message: 'A budget already covers Groceries for September.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given a budget '
        'When it is deleted '
        'Then the deletion reaches the repository', () async {
      final fake = FakeBudgets();

      await containerWith(fake).read(budgetActionsProvider).delete('b1');

      expect(fake.deleted, ['b1']);
    });
  });

  group('BudgetsScreen', () {
    testWidgets('Given the budgets are still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<Budget>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            budgetRepositoryProvider.overrideWithValue(
              SlowBudgets(pending.future),
            ),
            categoryRepositoryProvider.overrideWithValue(
              FakeCategories(tree: treeWith(['Groceries'])),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: BudgetsScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(const Success([]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('budgets.empty')), findsOneWidget);
    });

    testWidgets('Given no categories exist '
        'When the screen opens '
        'Then it directs the user to create one first (AF-06)', (tester) async {
      await pumpBudgets(tester, FakeBudgets(), categories: FakeCategories());

      expect(find.byKey(const Key('budgets.noCategories')), findsOneWidget);
      expect(find.byKey(const Key('budgets.createCategory')), findsOneWidget);
      // And no way to start a budget that cannot be completed.
      expect(find.byKey(const Key('budgets.add')), findsNothing);
    });

    testWidgets('Given no budgets '
        'When the screen settles '
        'Then an empty state offers creation', (tester) async {
      await pumpBudgets(tester, FakeBudgets(onList: () => const Success([])));

      expect(find.byKey(const Key('budgets.empty')), findsOneWidget);
      expect(find.byKey(const Key('budgets.emptyAdd')), findsOneWidget);
    });

    testWidgets('Given the list cannot be read '
        'When the screen settles '
        'Then a failure with a retry is shown, not an empty state', (
      tester,
    ) async {
      var attempts = 0;
      final fake = FakeBudgets(
        onList: () {
          attempts++;
          return const Failure(
            message: 'Budgets could not be read.',
            kind: FailureKind.serverError,
          );
        },
      );

      await pumpBudgets(tester, fake);

      expect(find.byKey(const Key('budgets.empty')), findsNothing);
      expect(find.text('Budgets could not be read.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('budgets.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given a budget with consumption '
        'When it is listed '
        'Then spent, remaining and the ceiling are all shown (step 5)', (
      tester,
    ) async {
      await pumpBudgets(
        tester,
        FakeBudgets(
          onList: () => Success([
            budget(amount: '800.00', spent: '550.25', remaining: '249.75'),
          ]),
        ),
      );

      expect(find.byKey(const Key('budgets.spent.b1')), findsOneWidget);
      expect(find.byKey(const Key('budgets.remaining.b1')), findsOneWidget);
      expect(find.byKey(const Key('budgets.amount.b1')), findsOneWidget);
      expect(find.textContaining('550.25'), findsOneWidget);
      expect(find.textContaining('249.75'), findsOneWidget);
    });

    testWidgets('Given consumption cannot be obtained '
        'When the budget is listed '
        'Then it is shown without it and the failure is reported (AF-04)', (
      tester,
    ) async {
      await pumpBudgets(
        tester,
        FakeBudgets(onList: () => Success([budget(withConsumption: false)])),
      );

      expect(find.byKey(const Key('budgets.noConsumption.b1')), findsOneWidget);
      expect(find.byKey(const Key('budgets.spent.b1')), findsNothing);
      // The ceiling is still shown — the budget itself is not in doubt.
      expect(find.byKey(const Key('budgets.amount.b1')), findsOneWidget);
      expect(find.textContaining('could not be read'), findsOneWidget);
    });

    testWidgets('Given the API reports the budget exceeded '
        'When it is listed '
        'Then the overage is named rather than shown as a negative remainder', (
      tester,
    ) async {
      await pumpBudgets(
        tester,
        FakeBudgets(
          onList: () => Success([
            budget(
              amount: '800.00',
              spent: '900.00',
              remaining: '0',
              overage: '100.00',
              isExceeded: true,
            ),
          ]),
        ),
      );

      expect(find.byKey(const Key('budgets.exceeded.b1')), findsOneWidget);
      expect(find.text('Over by'), findsOneWidget);
      expect(find.textContaining('100.00'), findsOneWidget);
    });

    testWidgets('Given a budget within its ceiling '
        'When it is listed '
        'Then no overage is claimed', (tester) async {
      await pumpBudgets(tester, FakeBudgets(onList: () => Success([budget()])));

      expect(find.byKey(const Key('budgets.exceeded.b1')), findsNothing);
      expect(find.text('Remaining'), findsOneWidget);
    });
  });

  group('BudgetEditor', () {
    Future<void> openEditor(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('budgets.emptyAdd')));
      await tester.pumpAndSettle();
    }

    testWidgets('Given an amount of zero '
        'When it is submitted '
        'Then it is refused in the form and nothing is sent (AF-01)', (
      tester,
    ) async {
      final fake = FakeBudgets(onList: () => const Success([]));

      await pumpBudgets(tester, fake);
      await openEditor(tester);
      await tester.enterText(find.byKey(const Key('budgetEditor.amount')), '0');
      await tester.tap(find.byKey(const Key('budgetEditor.save')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('budgetEditor.error')), findsOneWidget);
      expect(
        find.text(BudgetProblem.amountNotPositive.message),
        findsOneWidget,
      );
      expect(fake.created, isEmpty);
    });

    testWidgets('Given no category is chosen '
        'When it is submitted '
        'Then it is refused in the form', (tester) async {
      final fake = FakeBudgets(onList: () => const Success([]));

      await pumpBudgets(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('budgetEditor.amount')),
        '800.00',
      );
      await choosePeriodStart(tester);
      await tester.tap(find.byKey(const Key('budgetEditor.save')));
      await tester.pumpAndSettle();

      expect(find.text(BudgetProblem.missingCategory.message), findsOneWidget);
      expect(fake.created, isEmpty);
    });

    testWidgets('Given no period start is chosen '
        'When it is submitted '
        'Then the period is refused before the categories are (AF-02)', (
      tester,
    ) async {
      final fake = FakeBudgets(onList: () => const Success([]));

      await pumpBudgets(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('budgetEditor.amount')),
        '800.00',
      );
      await tester.tap(find.byKey(const Key('budgetEditor.save')));
      await tester.pumpAndSettle();

      expect(
        find.text(BudgetProblem.missingPeriodStart.message),
        findsOneWidget,
      );
      expect(fake.created, isEmpty);
    });

    testWidgets('Given a complete form '
        'When it is submitted '
        'Then the budget is created with the typed amount', (tester) async {
      final fake = FakeBudgets(onList: () => const Success([]));

      await pumpBudgets(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('budgetEditor.amount')),
        '800.00',
      );
      await tester.tap(find.byKey(const Key('budgetEditor.currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BRL').last);
      await tester.pumpAndSettle();
      await choosePeriodStart(tester);
      await tester.tap(find.byKey(const Key('budgetEditor.category.cat1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('budgetEditor.save')));
      await tester.pumpAndSettle();

      expect(fake.created.single['amount'], '800');
      expect(fake.created.single['categoryIds'], ['cat1']);
      expect(fake.created.single['currencyCode'], 'BRL');
    });

    testWidgets('Given the API refuses an overlapping budget '
        'When it is submitted '
        "Then the API's reason is shown in the form (AF-03)", (tester) async {
      final fake = FakeBudgets(
        onList: () => const Success([]),
        onCreate: () => const Failure(
          message: 'A budget already covers Groceries for September.',
          kind: FailureKind.conflict,
        ),
      );

      await pumpBudgets(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('budgetEditor.amount')),
        '800.00',
      );
      await tester.tap(find.byKey(const Key('budgetEditor.currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BRL').last);
      await tester.pumpAndSettle();
      await choosePeriodStart(tester);
      await tester.tap(find.byKey(const Key('budgetEditor.category.cat1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('budgetEditor.save')));
      await tester.pumpAndSettle();

      expect(
        find.text('A budget already covers Groceries for September.'),
        findsOneWidget,
      );
    });

    testWidgets('Given an existing budget '
        'When it is opened for editing '
        'Then its categories are already ticked', (tester) async {
      await pumpBudgets(tester, FakeBudgets(onList: () => Success([budget()])));

      await tester.tap(find.byKey(const Key('budgets.item.b1')));
      await tester.pumpAndSettle();

      final checkbox = tester.widget<CheckboxListTile>(
        find.byKey(const Key('budgetEditor.category.cat1')),
      );
      expect(checkbox.value, isTrue);
      // And the currency is fixed after creation.
      expect(find.byKey(const Key('budgetEditor.currency')), findsNothing);
    });
  });
}

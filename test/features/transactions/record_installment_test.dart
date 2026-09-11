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
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/installment_repository.dart';
import 'package:fortuna_ui/features/transactions/state/installment_form.dart';
import 'package:fortuna_ui/features/transactions/ui/record_installment_screen.dart';

import '../holdings/accounts_test.dart' show FakeCurrencies;
import 'record_transaction_test.dart'
    show FakeCards, FakeCategories, card, treeWith;

class FakeInstallments implements InstallmentRepository {
  FakeInstallments({this.onRecord});

  Result<InstallmentPlan> Function()? onRecord;

  final List<Map<String, Object?>> recorded = [];

  @override
  Future<Result<InstallmentPlan>> record({
    required String creditCardId,
    required String categoryId,
    required String totalAmount,
    required int installmentCount,
    required DateTime purchasedOn,
    required String currencyCode,
    String? counterparty,
  }) async {
    recorded.add({
      'creditCardId': creditCardId,
      'categoryId': categoryId,
      'totalAmount': totalAmount,
      'installmentCount': installmentCount,
      'purchasedOn': purchasedOn,
      'currencyCode': currencyCode,
      'counterparty': counterparty,
    });
    return onRecord?.call() ??
        Success(plan(total: totalAmount, amounts: const ['50', '50']));
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowCards extends FakeCards {
  SlowCards(this._pending);

  final Future<Result<List<CreditCard>>> _pending;

  @override
  Future<Result<List<CreditCard>>> list() => _pending;
}

InstallmentPlan plan({
  String id = 'p1',
  String total = '100.00',
  required List<String> amounts,
}) => InstallmentPlan(
  id: id,
  creditCardId: 'cc1',
  totalAmount: Money.parse(total, 'BRL'),
  installmentCount: amounts.length,
  purchasedOn: DateTime(2026, 9, 10),
  installments: [
    for (var i = 0; i < amounts.length; i++)
      Installment(
        number: i + 1,
        transactionId: 't${i + 1}',
        amount: Money.parse(amounts[i], 'BRL'),
        occurredOn: DateTime(2026, 9 + i, 10),
      ),
  ],
);

ProviderContainer containerWith(FakeInstallments fake) {
  final container = ProviderContainer(
    overrides: [
      installmentRepositoryProvider.overrideWithValue(fake),
      creditCardRepositoryProvider.overrideWithValue(
        FakeCards(cards: [card()]),
      ),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpInstallment(
  WidgetTester tester, {
  FakeInstallments? installments,
  FakeCards? cards,
  FakeCategories? categories,
}) async {
  tester.view.physicalSize = const Size(1000, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        installmentRepositoryProvider.overrideWithValue(
          installments ?? FakeInstallments(),
        ),
        creditCardRepositoryProvider.overrideWithValue(
          cards ?? FakeCards(cards: [card()]),
        ),
        categoryRepositoryProvider.overrideWithValue(
          categories ?? FakeCategories(tree: treeWith(['Electronics'])),
        ),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: RecordInstallmentScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> fillValidPlan(
  WidgetTester tester, {
  String total = '100.00',
  String count = '3',
}) async {
  await tester.enterText(
    find.byKey(const Key('recordInstallment.total')),
    total,
  );
  await tester.enterText(
    find.byKey(const Key('recordInstallment.count')),
    count,
  );
  await tester.tap(find.byKey(const Key('recordInstallment.card')));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('Everyday card').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('recordInstallment.category')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Electronics').last);
  await tester.pumpAndSettle();
}

void main() {
  final parser = MoneyParser('en_US');

  group('InstallmentPlan.isUneven', () {
    test('Given installments that are all equal '
        'When it is asked '
        'Then nothing is uneven', () {
      expect(plan(amounts: const ['50.00', '50.00']).isUneven, isFalse);
    });

    test('Given a total that does not divide evenly '
        'When the API assigns the remainder to one charge '
        'Then the plan reports itself uneven (AF-04)', () {
      // 100 / 3 leaves a remainder the API puts on the first charge.
      final uneven = plan(
        total: '100.00',
        amounts: const ['33.34', '33.33', '33.33'],
      );

      expect(uneven.isUneven, isTrue);
    });

    test('Given the uneven installments '
        'When they are read '
        'Then the amounts are exactly what the API sent, not recomputed '
        '(AF-04)', () {
      final uneven = plan(
        total: '100.00',
        amounts: const ['33.34', '33.33', '33.33'],
      );

      expect(uneven.installments.map((i) => i.amount.amount), [
        Decimal.parse('33.34'),
        Decimal.parse('33.33'),
        Decimal.parse('33.33'),
      ]);

      // And they sum to the total, which an evenly-split guess would not.
      final sum = uneven.installments
          .map((i) => i.amount.amount)
          .reduce((a, b) => a + b);
      expect(sum, Decimal.parse('100.00'));
    });

    test('Given a single installment '
        'When it is asked '
        'Then nothing is uneven', () {
      expect(plan(amounts: const ['100.00']).isUneven, isFalse);
    });
  });

  group('InstallmentRules.validate', () {
    InstallmentProblem? validate({
      String totalText = '100.00',
      int? count = 3,
      String? cardId = 'cc1',
      String? categoryId = 'cat1',
    }) => InstallmentRules.validate(
      totalText: totalText,
      installmentCount: count,
      creditCardId: cardId,
      categoryId: categoryId,
      parser: parser,
    );

    test('Given a complete, valid entry '
        'When it is validated '
        'Then nothing is refused', () {
      expect(validate(), isNull);
    });

    test('Given fewer than two installments '
        'When it is validated '
        'Then it is refused (AF-01)', () {
      expect(validate(count: 1), InstallmentProblem.tooFewInstallments);
      expect(validate(count: 0), InstallmentProblem.tooFewInstallments);
      expect(validate(count: null), InstallmentProblem.tooFewInstallments);
    });

    test('Given exactly two installments '
        'When it is validated '
        'Then it is accepted, since two is the minimum', () {
      expect(validate(count: 2), isNull);
    });

    test('Given a total that is not greater than zero '
        'When it is validated '
        'Then it is refused (AF-02)', () {
      expect(validate(totalText: '0'), InstallmentProblem.totalNotPositive);
      expect(validate(totalText: '-5'), InstallmentProblem.totalNotPositive);
    });

    test('Given a total that is not a number '
        'When it is validated '
        'Then it is refused as unreadable (AF-02)', () {
      expect(validate(totalText: 'abc'), InstallmentProblem.totalUnreadable);
    });

    test('Given a total that does not divide evenly by the count '
        'When it is validated '
        'Then nothing is refused — the uneven split is the correct answer '
        '(AF-04)', () {
      // 100 into 3 is exactly the case AF-04 describes, and it is valid.
      expect(validate(totalText: '100.00', count: 3), isNull);
      expect(validate(totalText: '0.05', count: 3), isNull);
    });

    test('Given a missing card or category '
        'When it is validated '
        'Then the missing one is named', () {
      expect(validate(cardId: null), InstallmentProblem.missingCard);
      expect(validate(categoryId: null), InstallmentProblem.missingCategory);
    });
  });

  group('InstallmentProblem messages', () {
    test('Given the too-few-installments refusal '
        'When its message is read '
        'Then it says a single charge is a transaction (AF-01)', () {
      expect(
        InstallmentProblem.tooFewInstallments.message,
        contains('single charge is just a transaction'),
      );
    });

    test('Given every problem '
        'When its message is read '
        'Then none is empty', () {
      for (final problem in InstallmentProblem.values) {
        expect(problem.message, isNotEmpty);
      }
    });
  });

  group('InstallmentActions', () {
    test('Given a plan '
        'When it is submitted '
        'Then the exact total reaches the repository as a string', () async {
      final fake = FakeInstallments();

      await containerWith(fake)
          .read(installmentActionsProvider)
          .submit(
            creditCardId: 'cc1',
            categoryId: 'cat1',
            totalAmount: Decimal.parse('1234567.89'),
            installmentCount: 12,
            purchasedOn: DateTime(2026, 9, 10),
            currencyCode: 'BRL',
          );

      expect(fake.recorded.single['totalAmount'], '1234567.89');
      expect(fake.recorded.single['installmentCount'], 12);
    });

    test('Given the API refuses the plan '
        'When it is submitted '
        "Then the API's reason is carried back unchanged (AF-03)", () async {
      final fake = FakeInstallments(
        onRecord: () => const Failure(
          message: 'This card does not allow more than 12 installments.',
          kind: FailureKind.invalidInput,
        ),
      );

      final result = await containerWith(fake)
          .read(installmentActionsProvider)
          .submit(
            creditCardId: 'cc1',
            categoryId: 'cat1',
            totalAmount: Decimal.parse('100.00'),
            installmentCount: 24,
            purchasedOn: DateTime(2026, 9, 10),
            currencyCode: 'BRL',
          );

      expect(
        result,
        const Failure<InstallmentPlan>(
          message: 'This card does not allow more than 12 installments.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given a card that is not the user\'s '
        'When it is submitted '
        'Then it is presented as not found (AF-05)', () async {
      final fake = FakeInstallments(
        onRecord: () => const Failure(
          message: 'That card was not found.',
          kind: FailureKind.notFound,
        ),
      );

      final result = await containerWith(fake)
          .read(installmentActionsProvider)
          .submit(
            creditCardId: 'other',
            categoryId: 'cat1',
            totalAmount: Decimal.parse('100.00'),
            installmentCount: 3,
            purchasedOn: DateTime(2026, 9, 10),
            currencyCode: 'BRL',
          );

      expect(result.isSuccess, isFalse);
    });
  });

  group('RecordInstallmentScreen', () {
    testWidgets('Given the form is still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<CreditCard>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            installmentRepositoryProvider.overrideWithValue(FakeInstallments()),
            creditCardRepositoryProvider.overrideWithValue(
              SlowCards(pending.future),
            ),
            categoryRepositoryProvider.overrideWithValue(
              FakeCategories(tree: treeWith(['Electronics'])),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: RecordInstallmentScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(Success([card()]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordInstallment.total')), findsOneWidget);
    });

    testWidgets('Given no card '
        'When the form is opened '
        'Then it directs the user to create one', (tester) async {
      await pumpInstallment(tester, cards: FakeCards());

      expect(
        find.byKey(const Key('recordInstallment.nothingToRecordAgainst')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('recordInstallment.createCard')),
        findsOneWidget,
      );
    });

    testWidgets('Given no category '
        'When the form is opened '
        'Then it directs the user to create one', (tester) async {
      await pumpInstallment(tester, categories: FakeCategories());

      expect(
        find.byKey(const Key('recordInstallment.createCategory')),
        findsOneWidget,
      );
    });

    testWidgets('Given a count of one '
        'When it is submitted '
        'Then it is refused, explaining that one charge is a transaction '
        '(AF-01)', (tester) async {
      final fake = FakeInstallments();

      await pumpInstallment(tester, installments: fake);
      await fillValidPlan(tester, count: '1');
      await tester.tap(find.byKey(const Key('recordInstallment.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordInstallment.error')), findsOneWidget);
      expect(
        find.textContaining('single charge is just a transaction'),
        findsOneWidget,
      );
      expect(fake.recorded, isEmpty);
    });

    testWidgets('Given a total of zero '
        'When it is submitted '
        'Then it is refused in the form (AF-02)', (tester) async {
      final fake = FakeInstallments();

      await pumpInstallment(tester, installments: fake);
      await fillValidPlan(tester, total: '0');
      await tester.tap(find.byKey(const Key('recordInstallment.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text(InstallmentProblem.totalNotPositive.message),
        findsOneWidget,
      );
      expect(fake.recorded, isEmpty);
    });

    testWidgets('Given a valid plan '
        'When it is submitted '
        'Then the total and count reach the repository', (tester) async {
      final fake = FakeInstallments();

      await pumpInstallment(tester, installments: fake);
      await fillValidPlan(tester, total: '100.00', count: '3');
      await tester.tap(find.byKey(const Key('recordInstallment.submit')));
      await tester.pumpAndSettle();

      expect(fake.recorded.single['totalAmount'], '100');
      expect(fake.recorded.single['installmentCount'], 3);
      expect(fake.recorded.single['creditCardId'], 'cc1');
    });

    testWidgets('Given the API generated uneven installments '
        'When the plan is shown '
        'Then the amounts are displayed as generated and the difference is '
        'explained (step 5, AF-04)', (tester) async {
      await pumpInstallment(
        tester,
        installments: FakeInstallments(
          onRecord: () => Success(
            plan(total: '100.00', amounts: const ['33.34', '33.33', '33.33']),
          ),
        ),
      );
      await fillValidPlan(tester);
      await tester.tap(find.byKey(const Key('recordInstallment.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordInstallment.plan')), findsOneWidget);
      expect(find.byKey(const Key('recordInstallment.uneven')), findsOneWidget);
      expect(find.textContaining('carries the'), findsOneWidget);

      // The generated amounts, exactly.
      expect(find.textContaining('33.34'), findsOneWidget);
      expect(find.textContaining('33.33'), findsNWidgets(2));
    });

    testWidgets('Given the API generated even installments '
        'When the plan is shown '
        'Then no remainder is explained', (tester) async {
      await pumpInstallment(
        tester,
        installments: FakeInstallments(
          onRecord: () =>
              Success(plan(total: '100.00', amounts: const ['50.00', '50.00'])),
        ),
      );
      await fillValidPlan(tester, count: '2');
      await tester.tap(find.byKey(const Key('recordInstallment.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordInstallment.uneven')), findsNothing);
      expect(find.textContaining('50.00'), findsNWidgets(2));
    });

    testWidgets('Given the API refuses the plan '
        'When it is submitted '
        "Then the API's reason is shown and the entry is kept (AF-03)", (
      tester,
    ) async {
      await pumpInstallment(
        tester,
        installments: FakeInstallments(
          onRecord: () => const Failure(
            message: 'This card does not allow more than 12 installments.',
            kind: FailureKind.invalidInput,
          ),
        ),
      );
      await fillValidPlan(tester, total: '100.00', count: '24');
      await tester.tap(find.byKey(const Key('recordInstallment.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('This card does not allow more than 12 installments.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('recordInstallment.plan')), findsNothing);
      expect(find.text('100.00'), findsOneWidget);
    });
  });
}

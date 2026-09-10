import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';
import 'package:fortuna_ui/features/holdings/state/credit_card_providers.dart';
import 'package:fortuna_ui/features/holdings/ui/credit_cards_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

import 'accounts_test.dart' show FakeCurrencies;

class FakeCards implements CreditCardRepository {
  FakeCards({this.onList, this.onCreate, this.onDelete});

  Result<List<CreditCard>> Function()? onList;
  Result<void> Function()? onCreate;
  Result<void> Function()? onDelete;

  final List<Map<String, Object?>> created = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<CreditCard>>> list() async =>
      onList?.call() ?? const Success([]);

  @override
  Future<Result<CreditCard>> read(String id) async => const Failure(
    message: 'That card was not found.',
    kind: FailureKind.notFound,
  );

  @override
  Future<Result<void>> create({
    required String name,
    required String currencyCode,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
    String? lastFourDigits,
  }) async {
    created.add({
      'name': name,
      'creditLimit': creditLimit,
      'closingDay': closingDay,
      'dueDay': dueDay,
    });
    return onCreate?.call() ?? const Success(null);
  }

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
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return onDelete?.call() ?? const Success(null);
  }
}

CreditCard card({
  String id = 'c1',
  String name = 'Everyday card',
  String limit = '5000.00',
  String used = '1200.50',
  String available = '3799.50',
  String overage = '0',
}) => CreditCard(
  id: id,
  name: name,
  currencyCode: 'BRL',
  creditLimit: Money.parse(limit, 'BRL'),
  usedAmount: Money.parse(used, 'BRL'),
  availableAmount: Money.parse(available, 'BRL'),
  overageAmount: Money.parse(overage, 'BRL'),
  closingDay: 20,
  dueDay: 28,
  issuer: 'A Bank',
  lastFourDigits: '1234',
);

ProviderContainer containerWith(FakeCards cards) {
  final container = ProviderContainer(
    overrides: [
      creditCardRepositoryProvider.overrideWithValue(cards),
      currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpCards(WidgetTester tester, FakeCards cards) async {
  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        creditCardRepositoryProvider.overrideWithValue(cards),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: CreditCardsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('CreditCardRules.isPositiveAmount', () {
    test('Given an amount greater than zero '
        'When it is checked '
        'Then it is accepted (UC-15 step 3)', () {
      for (final amount in ['1', '0.01', '5000.00', ' 1200.50 ', '0,05']) {
        expect(
          CreditCardRules.isPositiveAmount(amount),
          isTrue,
          reason: '"$amount" should be accepted',
        );
      }
    });

    test('Given zero, nothing, or a negative amount '
        'When it is checked '
        'Then it is rejected (UC-15 AF-01)', () {
      for (final amount in ['', '   ', '0', '0.00', '0,00', '-1', '-0.01']) {
        expect(
          CreditCardRules.isPositiveAmount(amount),
          isFalse,
          reason: '"$amount" should be rejected',
        );
      }
    });
  });

  group('CreditCardRules.isDayInRange', () {
    test('Given a day within a month '
        'When it is checked '
        'Then it is accepted', () {
      for (final day in [1, 15, 31]) {
        expect(CreditCardRules.isDayInRange(day), isTrue, reason: '$day');
      }
    });

    test('Given a day outside a month '
        'When it is checked '
        'Then it is rejected (UC-15 AF-01)', () {
      for (final day in [null, 0, -1, 32, 100]) {
        expect(CreditCardRules.isDayInRange(day), isFalse, reason: '$day');
      }
    });
  });

  group('CreditCard', () {
    test('Given a card within its limit '
        'When it is asked '
        'Then it is not over', () {
      expect(card().isOverLimit, isFalse);
    });

    test('Given a card carrying an overage '
        'When it is asked '
        'Then it says so — the figure is its own, not a subtraction', () {
      // available + used does not reveal this, which is why the API sends it.
      expect(card(overage: '250.00').isOverLimit, isTrue);
    });

    test('Given the four figures the API sent '
        'When they are read '
        'Then each carries the exact value the API sent (FR-HO-05)', () {
      final subject = card(
        limit: '5000.00',
        used: '1200.50',
        available: '3799.50',
        overage: '0',
      );

      // Compared as decimals, not as strings: Decimal's canonical form drops
      // trailing zeros, so 5000.00 and 5000 are the same exact value. Padding
      // to a currency's minor units is the formatter's job, not the model's.
      expect(subject.creditLimit.amount, Decimal.parse('5000.00'));
      expect(subject.usedAmount.amount, Decimal.parse('1200.50'));
      expect(subject.availableAmount.amount, Decimal.parse('3799.50'));
      expect(subject.overageAmount.amount, Decimal.zero);
    });

    test('Given a card whose available amount is not the limit minus what is '
        'used '
        'When it is read '
        "Then the API's figure stands, because nothing here derives it "
        '(FR-HO-05)', () {
      // A card over its limit is where the arithmetic and the truth part
      // company: the API says nothing is available, while limit minus used is
      // a negative number that means something else entirely.
      final subject = card(
        limit: '5000.00',
        used: '5250.00',
        available: '0',
        overage: '250.00',
      );

      expect(subject.availableAmount.amount, Decimal.zero);
      expect(
        subject.creditLimit.amount - subject.usedAmount.amount,
        Decimal.parse('-250.00'),
      );
      // The screen shows the API's zero, not the subtraction's -250.
      expect(
        subject.availableAmount.amount,
        isNot(subject.creditLimit.amount - subject.usedAmount.amount),
      );
      expect(subject.isOverLimit, isTrue);
    });
  });

  group('creditCardsProvider', () {
    test('Given several cards '
        'When they are listed '
        'Then they are sorted by name', () async {
      final container = containerWith(
        FakeCards(
          onList: () => Success([
            card(id: 'b', name: 'Zebra'),
            card(id: 'a', name: 'apple'),
          ]),
        ),
      );

      final list = await container.read(creditCardsProvider.future);

      expect(list.map((c) => c.name), ['apple', 'Zebra']);
    });

    test('Given the list cannot be read '
        'When it is awaited '
        'Then the reason comes through', () async {
      final container = containerWith(
        FakeCards(
          onList: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await expectLater(
        container.read(creditCardsProvider.future),
        throwsA(isA<CreditCardsUnavailable>()),
      );
    });
  });

  group('CreditCardActions', () {
    test('Given a limit the user typed '
        'When the card is created '
        'Then the string reaches the API unrounded (BR-05)', () async {
      final cards = FakeCards();
      final container = containerWith(cards);

      await container
          .read(creditCardActionsProvider)
          .create(
            name: 'Everyday',
            currencyCode: 'BRL',
            creditLimit: '1.005',
            closingDay: 20,
            dueDay: 28,
          );

      expect(cards.created.single['creditLimit'], '1.005');
    });

    test('Given the API refuses the day combination '
        'When it answers '
        'Then its reason comes back (UC-15 AF-02)', () async {
      final container = containerWith(
        FakeCards(
          onCreate: () => const Failure(
            message: 'The due day must fall after the closing day.',
            kind: FailureKind.invalidInput,
          ),
        ),
      );

      final result = await container
          .read(creditCardActionsProvider)
          .create(
            name: 'Everyday',
            currencyCode: 'BRL',
            creditLimit: '5000',
            closingDay: 28,
            dueDay: 20,
          );

      expect(
        (result as Failure<void>).message,
        'The due day must fall after the closing day.',
      );
    });

    test('Given a deletion the API refuses '
        'When live records reference the card '
        'Then its reason comes back (UC-15 AF-05)', () async {
      final container = containerWith(
        FakeCards(
          onDelete: () => const Failure(
            message: 'Statements still reference this card.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      final result = await container
          .read(creditCardActionsProvider)
          .delete('c1');

      expect(
        (result as Failure<void>).message,
        'Statements still reference this card.',
      );
    });
  });

  group('CreditCardsScreen', () {
    testWidgets('Given no cards '
        'When the screen settles '
        'Then an empty state offers creation (UC-15 AF-06)', (tester) async {
      await pumpCards(tester, FakeCards());

      expect(find.byKey(const Key('cards.empty')), findsOneWidget);
      expect(find.byKey(const Key('cards.emptyAdd')), findsOneWidget);
    });

    testWidgets('Given a card '
        'When it is listed '
        'Then the limit, used and available are all shown (FR-HO-05)', (
      tester,
    ) async {
      await pumpCards(tester, FakeCards(onList: () => Success([card()])));

      expect(find.byKey(const Key('cards.used.c1')), findsOneWidget);
      expect(find.byKey(const Key('cards.available.c1')), findsOneWidget);
      expect(find.byKey(const Key('cards.limit.c1')), findsOneWidget);
    });

    testWidgets('Given a card within its limit '
        'When it is listed '
        'Then no overage is shown', (tester) async {
      await pumpCards(tester, FakeCards(onList: () => Success([card()])));

      expect(find.byKey(const Key('cards.overage.c1')), findsNothing);
    });

    testWidgets('Given a card over its limit '
        'When it is listed '
        'Then the overage is stated rather than left to be subtracted', (
      tester,
    ) async {
      await pumpCards(
        tester,
        FakeCards(onList: () => Success([card(overage: '250.00')])),
      );

      expect(find.byKey(const Key('cards.overage.c1')), findsOneWidget);
      expect(find.textContaining('Over the limit by'), findsOneWidget);
    });
  });
}

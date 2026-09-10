import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/holdings/data/investment_repository.dart';
import 'package:fortuna_ui/features/holdings/state/investment_providers.dart';
import 'package:fortuna_ui/features/holdings/ui/investment_record_sheet.dart';
import 'package:fortuna_ui/features/holdings/ui/investment_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

import 'accounts_test.dart' show FakeAccounts, FakeCurrencies, account;
import 'investments_test.dart' show FakeInvestments, investment;

/// Extends the UC-17 fake with the two recording calls UC-18 adds, so both
/// use cases exercise one double rather than two that could drift apart.
class RecordingInvestments extends FakeInvestments {
  RecordingInvestments({
    super.onRead,
    this.onValuations,
    this.onMovement,
    this.onValuation,
  });

  Result<List<RecordedValuation>> Function()? onValuations;
  Result<void> Function()? onMovement;
  Result<void> Function()? onValuation;

  final List<Map<String, Object?>> movements = [];
  final List<Map<String, Object?>> valuationsRecorded = [];

  @override
  Future<Result<List<RecordedValuation>>> valuations(
    String investmentId,
  ) async => onValuations?.call() ?? const Success([]);

  @override
  Future<Result<void>> recordMovement({
    required String investmentId,
    required MovementType type,
    required String amount,
    required DateTime occurredOn,
    String? financialAccountId,
  }) async {
    movements.add({
      'investmentId': investmentId,
      'type': type,
      'amount': amount,
      'occurredOn': occurredOn,
      'financialAccountId': financialAccountId,
    });
    return onMovement?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> recordValuation({
    required String investmentId,
    required String value,
    required DateTime valuedOn,
  }) async {
    valuationsRecorded.add({
      'investmentId': investmentId,
      'value': value,
      'valuedOn': valuedOn,
    });
    return onValuation?.call() ?? const Success(null);
  }
}

ProviderContainer containerWith(RecordingInvestments fake) {
  final container = ProviderContainer(
    overrides: [
      investmentRepositoryProvider.overrideWithValue(fake),
      accountRepositoryProvider.overrideWithValue(FakeAccounts()),
      currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpInvestment(
  WidgetTester tester,
  RecordingInvestments fake, {
  FakeAccounts? accounts,
}) async {
  tester.view.physicalSize = const Size(1000, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        investmentRepositoryProvider.overrideWithValue(fake),
        accountRepositoryProvider.overrideWithValue(accounts ?? FakeAccounts()),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: InvestmentScreen(investmentId: 'i1')),
    ),
  );
  await tester.pumpAndSettle();
}

/// Opens the movement or valuation sheet from the investment screen.
Future<void> openSheet(WidgetTester tester, RecordKind kind) async {
  await tester.tap(
    find.byKey(
      Key(
        kind == RecordKind.movement
            ? 'investment.recordMovement'
            : 'investment.recordValuation',
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('MovementType', () {
    test('Given the numbers the contract specifies '
        'When they are mapped '
        'Then each kind keeps its own number', () {
      expect(MovementType.contribution.wire, 1);
      expect(MovementType.withdrawal.wire, 2);
      expect(MovementType.yieldEarned.wire, 3);
      expect(MovementType.fee.wire, 4);
    });
  });

  group('InvestmentRules.isPositiveAmount', () {
    test('Given an amount greater than zero '
        'When it is checked '
        'Then it is accepted, however it is written', () {
      expect(InvestmentRules.isPositiveAmount('1'), isTrue);
      expect(InvestmentRules.isPositiveAmount('0.01'), isTrue);
      expect(InvestmentRules.isPositiveAmount(' 1500.75 '), isTrue);
      expect(InvestmentRules.isPositiveAmount('1000000'), isTrue);
    });

    test('Given zero, nothing, or a negative amount '
        'When it is checked '
        'Then it is refused (AF-01)', () {
      expect(InvestmentRules.isPositiveAmount('0'), isFalse);
      expect(InvestmentRules.isPositiveAmount('0.00'), isFalse);
      expect(InvestmentRules.isPositiveAmount(''), isFalse);
      expect(InvestmentRules.isPositiveAmount('   '), isFalse);
      expect(InvestmentRules.isPositiveAmount('-5.00'), isFalse);
    });
  });

  group('InvestmentRules.isNotInFuture', () {
    final now = DateTime(2026, 9, 10, 14, 30);

    test('Given a date before today '
        'When it is checked '
        'Then it is accepted', () {
      expect(
        InvestmentRules.isNotInFuture(DateTime(2026, 9, 9), now: now),
        isTrue,
      );
    });

    test('Given today '
        'When it is checked '
        'Then it is accepted, whatever the time of day', () {
      expect(
        InvestmentRules.isNotInFuture(DateTime(2026, 9, 10), now: now),
        isTrue,
      );
      expect(
        InvestmentRules.isNotInFuture(DateTime(2026, 9, 10, 23), now: now),
        isTrue,
      );
    });

    test('Given a date after today '
        'When it is checked '
        'Then it is refused (AF-02)', () {
      expect(
        InvestmentRules.isNotInFuture(DateTime(2026, 9, 11), now: now),
        isFalse,
      );
    });
  });

  group('InvestmentActions.recordMovement', () {
    test('Given a movement '
        'When it is recorded '
        'Then the amount is sent as the string that was typed', () async {
      final fake = RecordingInvestments();

      await containerWith(fake)
          .read(investmentActionsProvider)
          .recordMovement(
            investmentId: 'i1',
            type: MovementType.contribution,
            amount: '1500.75',
            occurredOn: DateTime(2026, 9, 1),
          );

      expect(fake.movements.single['amount'], '1500.75');
      expect(fake.movements.single['type'], MovementType.contribution);
    });

    test('Given an amount a double would not represent exactly '
        'When it is recorded '
        'Then it reaches the repository digit for digit', () async {
      final fake = RecordingInvestments();

      await containerWith(fake)
          .read(investmentActionsProvider)
          .recordMovement(
            investmentId: 'i1',
            type: MovementType.contribution,
            amount: '0.1',
            occurredOn: DateTime(2026, 9, 1),
          );

      expect(fake.movements.single['amount'], '0.1');
    });

    test(
      'Given a movement in a currency the investment does not hold '
      'When the API refuses '
      'Then its reason is carried back and nothing is converted (AF-05)',
      () async {
        final fake = RecordingInvestments(
          onMovement: () => const Failure(
            message: 'The amount must be in BRL.',
            kind: FailureKind.invalidInput,
          ),
        );

        final result = await containerWith(fake)
            .read(investmentActionsProvider)
            .recordMovement(
              investmentId: 'i1',
              type: MovementType.contribution,
              amount: '100.00',
              occurredOn: DateTime(2026, 9, 1),
            );

        expect(
          result,
          const Failure<void>(
            message: 'The amount must be in BRL.',
            kind: FailureKind.invalidInput,
          ),
        );
      },
    );
  });

  group('InvestmentActions.recordValuation', () {
    test('Given a valuation '
        'When it is recorded '
        'Then the value and its date reach the repository', () async {
      final fake = RecordingInvestments();

      await containerWith(fake)
          .read(investmentActionsProvider)
          .recordValuation(
            investmentId: 'i1',
            value: '16250.75',
            valuedOn: DateTime(2026, 8, 31),
          );

      expect(fake.valuationsRecorded.single['value'], '16250.75');
      expect(fake.valuationsRecorded.single['valuedOn'], DateTime(2026, 8, 31));
    });

    test('Given a valuation already exists for that date '
        'When another is recorded '
        "Then the API's answer is what reaches the caller (AF-03)", () async {
      final fake = RecordingInvestments(
        onValuation: () => const Failure(
          message: 'A valuation for 31 August already exists.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(investmentActionsProvider)
          .recordValuation(
            investmentId: 'i1',
            value: '16250.75',
            valuedOn: DateTime(2026, 8, 31),
          );

      expect(
        result,
        const Failure<void>(
          message: 'A valuation for 31 August already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('investmentValuationsProvider', () {
    test('Given recorded valuations '
        'When they are read '
        'Then each keeps its value and date', () async {
      final fake = RecordingInvestments(
        onValuations: () => Success([
          RecordedValuation(
            value: Money.parse('16250.75', 'BRL'),
            asOf: DateTime(2026, 8, 31),
          ),
        ]),
      );

      final list = await containerWith(fake)
          .read(investmentValuationsProvider('i1').future);

      expect(list.single.value.amount, Decimal.parse('16250.75'));
      expect(list.single.asOf, DateTime(2026, 8, 31));
    });

    test('Given the valuations cannot be read '
        'When they are requested '
        "Then the API's reason surfaces (AF-04)", () async {
      final fake = RecordingInvestments(
        onValuations: () => const Failure(
          message: 'That investment was not found.',
          kind: FailureKind.notFound,
        ),
      );

      await expectLater(
        containerWith(fake).read(investmentValuationsProvider('i1').future),
        throwsA(isA<InvestmentsUnavailable>()),
      );
    });
  });

  group('InvestmentRecordSheet', () {
    testWidgets('Given an investment '
        'When it is opened '
        'Then both a movement and a valuation can be recorded (step 1)', (
      tester,
    ) async {
      await pumpInvestment(tester, RecordingInvestments());

      expect(
        find.byKey(const Key('investment.recordMovement')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('investment.recordValuation')),
        findsOneWidget,
      );
    });

    testWidgets('Given an amount of zero '
        'When a movement is submitted '
        'Then it is rejected in the form and nothing is sent (AF-01)', (
      tester,
    ) async {
      final fake = RecordingInvestments();

      await pumpInvestment(tester, fake);
      await openSheet(tester, RecordKind.movement);
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '0',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('investmentRecord.error')), findsOneWidget);
      expect(
        find.text('The amount must be greater than zero.'),
        findsOneWidget,
      );
      expect(fake.movements, isEmpty);
    });

    testWidgets('Given a negative value '
        'When a valuation is submitted '
        'Then it is rejected in the form (AF-01)', (tester) async {
      final fake = RecordingInvestments();

      await pumpInvestment(tester, fake);
      await openSheet(tester, RecordKind.valuation);
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '-100.00',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(find.text('The value must be greater than zero.'), findsOneWidget);
      expect(fake.valuationsRecorded, isEmpty);
    });

    testWidgets('Given a valid movement '
        'When it is submitted '
        'Then the typed amount is sent unrounded', (tester) async {
      final fake = RecordingInvestments();

      await pumpInvestment(tester, fake);
      await openSheet(tester, RecordKind.movement);
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '1500.75',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(fake.movements.single['amount'], '1500.75');
      expect(fake.movements.single['investmentId'], 'i1');
    });

    testWidgets('Given a movement kind is chosen '
        'When it is submitted '
        'Then that kind is what is recorded', (tester) async {
      final fake = RecordingInvestments();

      await pumpInvestment(tester, fake);
      await openSheet(tester, RecordKind.movement);
      await tester.tap(find.byKey(const Key('investmentRecord.type')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Withdrawal').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '250.00',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(fake.movements.single['type'], MovementType.withdrawal);
    });

    testWidgets('Given a valid valuation '
        'When it is submitted '
        'Then the typed value is sent unrounded', (tester) async {
      final fake = RecordingInvestments();

      await pumpInvestment(tester, fake);
      await openSheet(tester, RecordKind.valuation);
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '16250.75',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(fake.valuationsRecorded.single['value'], '16250.75');
    });

    testWidgets('Given the movement form '
        'When it is shown '
        "Then the investment's own currency is stated, not chosen (AF-05)", (
      tester,
    ) async {
      await pumpInvestment(tester, RecordingInvestments());
      await openSheet(tester, RecordKind.movement);

      expect(find.text('BRL'), findsWidgets);
    });

    testWidgets('Given the API refuses a duplicate valuation date '
        'When it is submitted '
        "Then the API's answer is shown on the sheet (AF-03)", (tester) async {
      final fake = RecordingInvestments(
        onValuation: () => const Failure(
          message: 'A valuation for 31 August already exists.',
          kind: FailureKind.conflict,
        ),
      );

      await pumpInvestment(tester, fake);
      await openSheet(tester, RecordKind.valuation);
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '16250.75',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('A valuation for 31 August already exists.'),
        findsOneWidget,
      );
    });

    testWidgets('Given the currency does not match '
        'When a movement is submitted '
        "Then the API's refusal is shown and nothing is converted (AF-05)", (
      tester,
    ) async {
      final fake = RecordingInvestments(
        onMovement: () => const Failure(
          message: 'The amount must be in BRL.',
          kind: FailureKind.invalidInput,
        ),
      );

      await pumpInvestment(tester, fake);
      await openSheet(tester, RecordKind.movement);
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '100.00',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(find.text('The amount must be in BRL.'), findsOneWidget);
    });

    testWidgets('Given an account is chosen for a movement '
        'When it is submitted '
        'Then the movement is linked to it', (tester) async {
      final fake = RecordingInvestments();

      await pumpInvestment(
        tester,
        fake,
        accounts: FakeAccounts(onList: () => Success([account()])),
      );
      await openSheet(tester, RecordKind.movement);
      await tester.enterText(
        find.byKey(const Key('investmentRecord.amount')),
        '1500.75',
      );
      await tester.tap(find.byKey(const Key('investmentRecord.account')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Everyday · BRL').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('investmentRecord.submit')));
      await tester.pumpAndSettle();

      expect(fake.movements.single['financialAccountId'], 'a1');
    });
  });

  group('Valuation history', () {
    testWidgets('Given recorded valuations '
        'When the investment is opened '
        'Then they are listed', (tester) async {
      await pumpInvestment(
        tester,
        RecordingInvestments(
          onRead: (_) => Success(investment(valuation: '16250.75')),
          onValuations: () => Success([
            RecordedValuation(
              value: Money.parse('16250.75', 'BRL'),
              asOf: DateTime(2026, 8, 31),
            ),
          ]),
        ),
      );

      expect(find.text('Recorded valuations'), findsOneWidget);
      expect(
        find.byKey(const Key('investment.valuations.empty')),
        findsNothing,
      );
      expect(find.textContaining('16,250.75'), findsWidgets);
    });

    testWidgets('Given nothing has been recorded '
        'When the investment is opened '
        'Then the history says so rather than showing nothing', (tester) async {
      await pumpInvestment(tester, RecordingInvestments());

      expect(
        find.byKey(const Key('investment.valuations.empty')),
        findsOneWidget,
      );
    });

    testWidgets('Given the valuations cannot be read '
        'When the investment is opened '
        'Then the failure is shown without hiding the position (AF-04)', (
      tester,
    ) async {
      await pumpInvestment(
        tester,
        RecordingInvestments(
          onValuations: () => const Failure(
            message: 'That investment was not found.',
            kind: FailureKind.notFound,
          ),
        ),
      );

      expect(
        find.byKey(const Key('investment.valuations.error')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('investment.position')), findsOneWidget);
    });
  });
}

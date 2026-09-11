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
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transfer_repository.dart';
import 'package:fortuna_ui/features/transactions/state/transfer_form.dart';
import 'package:fortuna_ui/features/transactions/ui/record_transfer_screen.dart';

import '../holdings/accounts_test.dart'
    show FakeAccounts, FakeCurrencies, account;

class FakeTransfers implements TransferRepository {
  FakeTransfers({this.onRecord});

  Result<Transfer> Function()? onRecord;

  final List<Map<String, Object?>> recorded = [];

  @override
  Future<Result<Transfer>> record({
    required String originAccountId,
    required String destinationAccountId,
    required String amount,
    required DateTime occurredOn,
  }) async {
    recorded.add({
      'originAccountId': originAccountId,
      'destinationAccountId': destinationAccountId,
      'amount': amount,
      'occurredOn': occurredOn,
    });
    return onRecord?.call() ?? Success(transfer(outbound: amount));
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowAccounts extends FakeAccounts {
  SlowAccounts(this._pending);

  final Future<Result<List<FinancialAccount>>> _pending;

  @override
  Future<Result<List<FinancialAccount>>> list() => _pending;
}

Transfer transfer({
  String id = 'tr1',
  String outbound = '250.00',
  String outboundCurrency = 'BRL',
  String? inbound,
  String inboundCurrency = 'BRL',
  String? appliedRate,
}) => Transfer(
  id: id,
  occurredOn: DateTime(2026, 9, 10),
  originAccountId: 'a1',
  destinationAccountId: 'a2',
  outboundAmount: Money.parse(outbound, outboundCurrency),
  inboundAmount: Money.parse(inbound ?? outbound, inboundCurrency),
  appliedRate: appliedRate,
);

List<FinancialAccount> twoAccounts() => [
  account(),
  account(id: 'a2', name: 'Savings'),
];

ProviderContainer containerWith(FakeTransfers fake) {
  final container = ProviderContainer(
    overrides: [
      transferRepositoryProvider.overrideWithValue(fake),
      accountRepositoryProvider.overrideWithValue(
        FakeAccounts(onList: () => Success(twoAccounts())),
      ),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpTransfer(
  WidgetTester tester, {
  FakeTransfers? transfers,
  FakeAccounts? accounts,
}) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transferRepositoryProvider.overrideWithValue(
          transfers ?? FakeTransfers(),
        ),
        accountRepositoryProvider.overrideWithValue(
          accounts ?? FakeAccounts(onList: () => Success(twoAccounts())),
        ),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: RecordTransferScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Chooses two different accounts and an amount.
Future<void> fillValidTransfer(
  WidgetTester tester, {
  String amount = '250.00',
  String destination = 'Savings · BRL',
}) async {
  await tester.tap(find.byKey(const Key('recordTransfer.origin')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Everyday · BRL').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('recordTransfer.destination')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(destination).last);
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const Key('recordTransfer.amount')),
    amount,
  );
}

void main() {
  final parser = MoneyParser('en_US');

  group('Transfer', () {
    test('Given both sides in one currency '
        'When it is asked '
        'Then nothing was converted', () {
      expect(transfer().wasConverted, isFalse);
    });

    test('Given the two sides in different currencies '
        'When it is asked '
        'Then it reports a conversion (AF-03)', () {
      final converted = transfer(
        outbound: '250.00',
        inbound: '46.05',
        inboundCurrency: 'USD',
        appliedRate: '0.1842',
      );

      expect(converted.wasConverted, isTrue);
      expect(converted.outboundAmount.currencyCode, 'BRL');
      expect(converted.inboundAmount.currencyCode, 'USD');
      expect(converted.appliedRate, '0.1842');
    });

    test('Given an amount a double would not represent exactly '
        'When it is held '
        'Then it survives unchanged', () {
      final held = transfer(outbound: '1234567.89');

      expect(held.outboundAmount.amount, Decimal.parse('1234567.89'));
    });
  });

  group('TransferRules.validate', () {
    TransferProblem? validate({
      String amountText = '250.00',
      String? origin = 'a1',
      String? destination = 'a2',
    }) => TransferRules.validate(
      amountText: amountText,
      originAccountId: origin,
      destinationAccountId: destination,
      parser: parser,
    );

    test('Given two different accounts and a positive amount '
        'When it is validated '
        'Then nothing is refused', () {
      expect(validate(), isNull);
    });

    test('Given the same account on both sides '
        'When it is validated '
        'Then it is refused (AF-01, step 3)', () {
      expect(validate(destination: 'a1'), TransferProblem.sameAccount);
    });

    test('Given an amount that is not greater than zero '
        'When it is validated '
        'Then it is refused (AF-02)', () {
      expect(validate(amountText: '0'), TransferProblem.amountNotPositive);
      expect(validate(amountText: '-5'), TransferProblem.amountNotPositive);
    });

    test('Given an amount that is not a number '
        'When it is validated '
        'Then it is refused as unreadable (AF-02)', () {
      expect(validate(amountText: 'abc'), TransferProblem.amountUnreadable);
      expect(validate(amountText: ''), TransferProblem.amountUnreadable);
    });

    test('Given a missing account '
        'When it is validated '
        'Then the missing side is named', () {
      expect(validate(origin: null), TransferProblem.missingOrigin);
      expect(validate(destination: null), TransferProblem.missingDestination);
    });

    test('Given two accounts in different currencies '
        'When it is validated '
        'Then the client does not refuse it — that is the API\'s call '
        '(AF-03)', () {
      // The rule knows nothing about currencies on purpose: the API may
      // refuse the pair or convert it, and guessing would be wrong half the
      // time.
      expect(validate(), isNull);
    });

    test('Given the amount is also unreadable and the accounts match '
        'When it is validated '
        'Then the amount is reported first', () {
      expect(
        validate(amountText: 'abc', destination: 'a1'),
        TransferProblem.amountUnreadable,
      );
    });
  });

  group('TransferProblem messages', () {
    test('Given the same-account refusal '
        'When its message is read '
        'Then it explains why rather than only refusing', () {
      expect(
        TransferProblem.sameAccount.message,
        contains('cannot be transferred to the account it came from'),
      );
    });

    test('Given every problem '
        'When its message is read '
        'Then none is empty', () {
      for (final problem in TransferProblem.values) {
        expect(problem.message, isNotEmpty);
      }
    });
  });

  group('TransferActions', () {
    test('Given a transfer '
        'When it is submitted '
        'Then the exact decimal reaches the repository as a string', () async {
      final fake = FakeTransfers();

      await containerWith(fake)
          .read(transferActionsProvider)
          .submit(
            originAccountId: 'a1',
            destinationAccountId: 'a2',
            amount: Decimal.parse('1234567.89'),
            occurredOn: DateTime(2026, 9, 10),
          );

      expect(fake.recorded.single['amount'], '1234567.89');
      expect(fake.recorded.single['originAccountId'], 'a1');
      expect(fake.recorded.single['destinationAccountId'], 'a2');
    });

    test('Given the API refuses the currency pair '
        'When it is submitted '
        "Then the API's reason is carried back and nothing is converted "
        '(AF-03)', () async {
      final fake = FakeTransfers(
        onRecord: () => const Failure(
          message: 'This instance will not convert BRL to JPY.',
          kind: FailureKind.invalidInput,
        ),
      );

      final result = await containerWith(fake)
          .read(transferActionsProvider)
          .submit(
            originAccountId: 'a1',
            destinationAccountId: 'a2',
            amount: Decimal.parse('250.00'),
            occurredOn: DateTime(2026, 9, 10),
          );

      expect(
        result,
        const Failure<Transfer>(
          message: 'This instance will not convert BRL to JPY.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an account that is not the user\'s '
        'When it is submitted '
        'Then it is presented as not found (AF-04)', () async {
      final fake = FakeTransfers(
        onRecord: () => const Failure(
          message: 'That account was not found.',
          kind: FailureKind.notFound,
        ),
      );

      final result = await containerWith(fake)
          .read(transferActionsProvider)
          .submit(
            originAccountId: 'a1',
            destinationAccountId: 'other',
            amount: Decimal.parse('250.00'),
            occurredOn: DateTime(2026, 9, 10),
          );

      expect(result.isSuccess, isFalse);
    });
  });

  group('RecordTransferScreen', () {
    testWidgets('Given the accounts are still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<FinancialAccount>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transferRepositoryProvider.overrideWithValue(FakeTransfers()),
            accountRepositoryProvider.overrideWithValue(
              SlowAccounts(pending.future),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: RecordTransferScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(Success(twoAccounts()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordTransfer.amount')), findsOneWidget);
    });

    testWidgets('Given only one account '
        'When the form is opened '
        'Then it explains that a transfer needs two and offers creation '
        '(AF-06)', (tester) async {
      await pumpTransfer(
        tester,
        accounts: FakeAccounts(onList: () => Success([account()])),
      );

      expect(
        find.byKey(const Key('recordTransfer.notEnoughAccounts')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('recordTransfer.amount')), findsNothing);
      expect(
        find.byKey(const Key('recordTransfer.createAccount')),
        findsOneWidget,
      );
    });

    testWidgets('Given no accounts at all '
        'When the form is opened '
        'Then it still explains the requirement (AF-06)', (tester) async {
      await pumpTransfer(
        tester,
        accounts: FakeAccounts(onList: () => const Success([])),
      );

      expect(
        find.byKey(const Key('recordTransfer.notEnoughAccounts')),
        findsOneWidget,
      );
      expect(find.textContaining('no accounts yet'), findsOneWidget);
    });

    testWidgets('Given two accounts '
        'When the form is opened '
        'Then the form is shown', (tester) async {
      await pumpTransfer(tester);

      expect(find.byKey(const Key('recordTransfer.origin')), findsOneWidget);
      expect(
        find.byKey(const Key('recordTransfer.destination')),
        findsOneWidget,
      );
    });

    testWidgets('Given the same account on both sides '
        'When it is submitted '
        'Then it is refused in the form and nothing is sent (AF-01)', (
      tester,
    ) async {
      final fake = FakeTransfers();

      await pumpTransfer(tester, transfers: fake);
      await fillValidTransfer(tester, destination: 'Everyday · BRL');
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordTransfer.error')), findsOneWidget);
      expect(find.text(TransferProblem.sameAccount.message), findsOneWidget);
      expect(fake.recorded, isEmpty);
    });

    testWidgets('Given an amount of zero '
        'When it is submitted '
        'Then it is refused in the form (AF-02)', (tester) async {
      final fake = FakeTransfers();

      await pumpTransfer(tester, transfers: fake);
      await fillValidTransfer(tester, amount: '0');
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text(TransferProblem.amountNotPositive.message),
        findsOneWidget,
      );
      expect(fake.recorded, isEmpty);
    });

    testWidgets('Given a valid transfer '
        'When it is submitted '
        'Then both accounts and the exact amount are sent', (tester) async {
      final fake = FakeTransfers();

      await pumpTransfer(tester, transfers: fake);
      await fillValidTransfer(tester, amount: '250.00');
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(fake.recorded.single['originAccountId'], 'a1');
      expect(fake.recorded.single['destinationAccountId'], 'a2');
      expect(fake.recorded.single['amount'], '250');
    });

    testWidgets('Given the transfer is recorded '
        'When the confirmation is shown '
        'Then it says the transfer is neither an earning nor an expense '
        '(step 5, FR-MM-08)', (tester) async {
      await pumpTransfer(tester);
      await fillValidTransfer(tester);
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('recordTransfer.confirmation')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('recordTransfer.notAnExpense')),
        findsOneWidget,
      );
      expect(
        find.textContaining('neither an earning nor an expense'),
        findsOneWidget,
      );
    });

    testWidgets('Given the API converted between two currencies '
        'When the confirmation is shown '
        'Then both sides and the rate it used are shown (AF-03)', (
      tester,
    ) async {
      await pumpTransfer(
        tester,
        transfers: FakeTransfers(
          onRecord: () => Success(
            transfer(
              outbound: '250.00',
              inbound: '46.05',
              inboundCurrency: 'USD',
              appliedRate: '0.1842',
            ),
          ),
        ),
      );
      await fillValidTransfer(tester);
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordTransfer.outbound')), findsOneWidget);
      expect(find.byKey(const Key('recordTransfer.inbound')), findsOneWidget);
      expect(find.byKey(const Key('recordTransfer.rate')), findsOneWidget);
      expect(find.textContaining('0.1842'), findsOneWidget);
    });

    testWidgets('Given both sides in one currency '
        'When the confirmation is shown '
        'Then no conversion is implied', (tester) async {
      await pumpTransfer(tester);
      await fillValidTransfer(tester);
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recordTransfer.inbound')), findsNothing);
      expect(find.byKey(const Key('recordTransfer.rate')), findsNothing);
    });

    testWidgets('Given the API refuses the currency pair '
        'When it is submitted '
        "Then the API's reason is shown and the entry is kept (AF-03)", (
      tester,
    ) async {
      await pumpTransfer(
        tester,
        transfers: FakeTransfers(
          onRecord: () => const Failure(
            message: 'This instance will not convert BRL to JPY.',
            kind: FailureKind.invalidInput,
          ),
        ),
      );
      await fillValidTransfer(tester, amount: '250.00');
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('This instance will not convert BRL to JPY.'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('recordTransfer.confirmation')),
        findsNothing,
      );
      expect(find.text('250.00'), findsOneWidget);
    });

    testWidgets('Given the submission fails partway '
        'When the failure returns '
        'Then no transfer is reported and none is shown as half done '
        '(AF-05)', (tester) async {
      await pumpTransfer(
        tester,
        transfers: FakeTransfers(
          onRecord: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );
      await fillValidTransfer(tester);
      await tester.tap(find.byKey(const Key('recordTransfer.submit')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('recordTransfer.confirmation')),
        findsNothing,
      );
      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.byKey(const Key('recordTransfer.submit')), findsOneWidget);
    });
  });
}

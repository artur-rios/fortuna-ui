import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/app/routes.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';
import 'package:fortuna_ui/features/holdings/data/statement_repository.dart';
import 'package:fortuna_ui/features/holdings/state/statement_providers.dart';
import 'package:fortuna_ui/features/holdings/ui/card_statements_screen.dart';
import 'package:fortuna_ui/features/holdings/ui/credit_cards_screen.dart';
import 'package:fortuna_ui/features/holdings/ui/statement_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:go_router/go_router.dart';

import 'accounts_test.dart' show FakeAccounts, FakeCurrencies, account;

class FakeStatements implements StatementRepository {
  FakeStatements({this.onList, this.onRead, this.onClose, this.onSettle});

  Result<List<CardStatement>> Function()? onList;
  Result<CardStatement> Function(String id)? onRead;
  Result<void> Function()? onClose;
  Result<void> Function()? onSettle;

  final List<String> closed = [];
  final List<Map<String, Object?>> settled = [];

  @override
  Future<Result<List<CardStatement>>> listForCard(String creditCardId) async =>
      onList?.call() ?? const Success([]);

  @override
  Future<Result<CardStatement>> read(String statementId) async =>
      onRead?.call(statementId) ?? Success(statement());

  @override
  Future<Result<void>> close(String statementId) async {
    closed.add(statementId);
    return onClose?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> settle({
    required String statementId,
    required String financialAccountId,
    required String amount,
    required DateTime paymentDate,
  }) async {
    settled.add({
      'statementId': statementId,
      'financialAccountId': financialAccountId,
      'amount': amount,
      'paymentDate': paymentDate,
    });
    return onSettle?.call() ?? const Success(null);
  }
}

/// The one card the navigation test needs, so tapping through has something
/// to tap.
class FakeCardsForStatements implements CreditCardRepository {
  @override
  Future<Result<List<CreditCard>>> list() async => Success([
    CreditCard(
      id: 'c1',
      name: 'Everyday card',
      currencyCode: 'BRL',
      creditLimit: Money.parse('5000.00', 'BRL'),
      usedAmount: Money.parse('1200.50', 'BRL'),
      availableAmount: Money.parse('3799.50', 'BRL'),
      overageAmount: Money.parse('0', 'BRL'),
      closingDay: 20,
      dueDay: 28,
    ),
  ]);

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

/// A repository whose list answers only when the test lets it, so the loading
/// state is observable at all.
class SlowStatements extends FakeStatements {
  SlowStatements(this._pending);

  final Future<Result<List<CardStatement>>> _pending;

  @override
  Future<Result<List<CardStatement>>> listForCard(String creditCardId) =>
      _pending;
}

StatementCharge charge({
  String id = 'ch1',
  String amount = '120.00',
  bool isLateArriving = false,
  String? originalAmount,
  String originalCurrency = 'USD',
  String? appliedRate,
}) => StatementCharge(
  id: id,
  occurredOn: DateTime(2026, 4, 12),
  amount: Money.parse(amount, 'BRL'),
  isLateArriving: isLateArriving,
  originalAmount: originalAmount == null
      ? null
      : Money.parse(originalAmount, originalCurrency),
  appliedRate: appliedRate,
);

CardStatement statement({
  String id = 's1',
  StatementStatus status = StatementStatus.open,
  String amountDue = '1320.45',
  String previousBalance = '0',
  String purchaseTotal = '1200.45',
  String paymentsReceived = '0',
  String foreignTax = '20.00',
  String otherEntries = '100.00',
  List<StatementCharge>? charges,
  String? settlementTransactionId,
}) => CardStatement(
  id: id,
  creditCardId: 'c1',
  currencyCode: 'BRL',
  status: status,
  periodStart: DateTime(2026, 4),
  periodEnd: DateTime(2026, 4, 30),
  closingDate: DateTime(2026, 4, 20),
  dueDate: DateTime(2026, 5, 28),
  previousBalance: Money.parse(previousBalance, 'BRL'),
  purchaseTotal: Money.parse(purchaseTotal, 'BRL'),
  paymentsReceived: Money.parse(paymentsReceived, 'BRL'),
  foreignTaxTotal: Money.parse(foreignTax, 'BRL'),
  otherEntries: Money.parse(otherEntries, 'BRL'),
  amountDue: Money.parse(amountDue, 'BRL'),
  charges: charges ?? [charge()],
  settlementTransactionId: settlementTransactionId,
);

ProviderContainer containerWith(
  FakeStatements statements, {
  FakeAccounts? accounts,
}) {
  final container = ProviderContainer(
    overrides: [
      statementRepositoryProvider.overrideWithValue(statements),
      accountRepositoryProvider.overrideWithValue(accounts ?? FakeAccounts()),
      currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _pump(WidgetTester tester, Widget screen, FakeStatements fake,
    {FakeAccounts? accounts}) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        statementRepositoryProvider.overrideWithValue(fake),
        accountRepositoryProvider.overrideWithValue(accounts ?? FakeAccounts()),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: MaterialApp(home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpStatements(WidgetTester tester, FakeStatements fake) =>
    _pump(tester, const CardStatementsScreen(creditCardId: 'c1'), fake);

Future<void> pumpStatement(
  WidgetTester tester,
  FakeStatements fake, {
  FakeAccounts? accounts,
}) => _pump(
  tester,
  const StatementScreen(creditCardId: 'c1', statementId: 's1'),
  fake,
  accounts: accounts,
);

void main() {
  group('StatementStatus', () {
    test('Given the names the API publishes '
        'When they are parsed '
        'Then each maps to its own state', () {
      expect(StatementStatus.parse('Open'), StatementStatus.open);
      expect(StatementStatus.parse('Closed'), StatementStatus.closed);
      expect(StatementStatus.parse('Settled'), StatementStatus.settled);
    });

    test('Given a status the client does not recognize '
        'When it is parsed '
        'Then it reads as open, which offers the least', () {
      expect(StatementStatus.parse(null), StatementStatus.open);
      expect(StatementStatus.parse('something-new'), StatementStatus.open);
    });
  });

  group('CardStatement', () {
    test('Given an open statement '
        'When its actions are asked for '
        'Then closing is offered and settling is not (AF-02)', () {
      final open = statement();

      expect(open.canClose, isTrue);
      expect(open.canSettle, isFalse);
      expect(open.isFrozen, isFalse);
    });

    test('Given a closed statement '
        'When its actions are asked for '
        'Then settling is offered and closing is not', () {
      final closed = statement(status: StatementStatus.closed);

      expect(closed.canClose, isFalse);
      expect(closed.canSettle, isTrue);
      expect(closed.isFrozen, isFalse);
    });

    test('Given a settled statement '
        'When its actions are asked for '
        'Then neither closing nor settling is offered (AF-04)', () {
      final settled = statement(status: StatementStatus.settled);

      expect(settled.canClose, isFalse);
      expect(settled.canSettle, isFalse);
      expect(settled.isFrozen, isTrue);
    });

    test('Given a statement carrying a late-arriving charge '
        'When it is asked '
        'Then it reports one (FR-HO-09)', () {
      final late = statement(
        charges: [charge(), charge(id: 'ch2', isLateArriving: true)],
      );

      expect(late.hasLateArrivals, isTrue);
      expect(statement().hasLateArrivals, isFalse);
    });

    test('Given the six figures the API composed '
        'When the statement holds them '
        'Then each is exactly what was sent and none is derived', () {
      final held = statement(
        previousBalance: '10.10',
        purchaseTotal: '20.20',
        paymentsReceived: '5.05',
        foreignTax: '1.01',
        otherEntries: '2.02',
        amountDue: '28.28',
      );

      expect(held.previousBalance.amount, Decimal.parse('10.10'));
      expect(held.purchaseTotal.amount, Decimal.parse('20.20'));
      expect(held.paymentsReceived.amount, Decimal.parse('5.05'));
      expect(held.foreignTaxTotal.amount, Decimal.parse('1.01'));
      expect(held.otherEntries.amount, Decimal.parse('2.02'));

      // Deliberately not the sum: the API's figure stands even where the
      // arithmetic a reader would do disagrees with it.
      expect(held.amountDue.amount, Decimal.parse('28.28'));
    });

    test('Given an amount a double would not represent exactly '
        'When it is held and re-serialized '
        'Then it survives the round trip unchanged', () {
      final held = statement(amountDue: '1234567.89');

      expect(held.amountDue.amount, Decimal.parse('1234567.89'));
      expect(held.amountDue.asApiString, '1234567.89');
    });

    test('Given a charge converted from another currency '
        'When it is read '
        'Then the original amount keeps its own currency', () {
      final converted = charge(originalAmount: '20.00', appliedRate: '5.4321');

      expect(converted.wasConverted, isTrue);
      expect(converted.originalAmount!.currencyCode, 'USD');
      expect(converted.amount.currencyCode, 'BRL');
      expect(converted.appliedRate, '5.4321');
    });
  });

  group('cardStatementsProvider', () {
    test('Given a card with cycles '
        'When they are read '
        'Then they are returned in the order the API sent them', () async {
      final fake = FakeStatements(
        onList: () => Success([
          statement(id: 'newest'),
          statement(id: 'older'),
        ]),
      );

      final list = await containerWith(fake).read(
        cardStatementsProvider('c1').future,
      );

      expect(list.map((s) => s.id), ['newest', 'older']);
    });

    test('Given the cycles cannot be read '
        'When they are requested '
        "Then the API's reason surfaces (AF-05)", () async {
      final fake = FakeStatements(
        onList: () => const Failure(
          message: 'That card was not found.',
          kind: FailureKind.notFound,
        ),
      );

      await expectLater(
        containerWith(fake).read(cardStatementsProvider('c1').future),
        throwsA(
          isA<StatementsUnavailable>().having(
            (e) => e.message,
            'message',
            'That card was not found.',
          ),
        ),
      );
    });
  });

  group('StatementActions', () {
    test('Given a statement past its closing date '
        'When it is closed '
        'Then the close reaches the repository', () async {
      final fake = FakeStatements();

      final result = await containerWith(fake)
          .read(statementActionsProvider)
          .close(statementId: 's1', creditCardId: 'c1');

      expect(result.isSuccess, isTrue);
      expect(fake.closed, ['s1']);
    });

    test('Given closing is attempted before the closing date '
        'When it is refused '
        "Then the API's reason is carried back unchanged (AF-01)", () async {
      final fake = FakeStatements(
        onClose: () => const Failure(
          message: 'This statement cannot be closed before 20 April.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(statementActionsProvider)
          .close(statementId: 's1', creditCardId: 'c1');

      expect(
        result,
        const Failure<void>(
          message: 'This statement cannot be closed before 20 April.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given a closed statement and an account to pay from '
        'When it is settled '
        'Then the amount is sent as the string the API stated', () async {
      final fake = FakeStatements();

      await containerWith(fake).read(statementActionsProvider).settle(
        statementId: 's1',
        creditCardId: 'c1',
        financialAccountId: 'a1',
        amount: '1320.45',
        paymentDate: DateTime(2026, 5, 2),
      );

      expect(fake.settled.single['amount'], '1320.45');
      expect(fake.settled.single['financialAccountId'], 'a1');
    });

    test('Given settlement from an account in another currency '
        'When the API refuses '
        'Then its reason is carried back and nothing is converted (AF-03)',
        () async {
      final fake = FakeStatements(
        onSettle: () => const Failure(
          message: 'The account must be in BRL to settle this statement.',
          kind: FailureKind.invalidInput,
        ),
      );

      final result = await containerWith(fake)
          .read(statementActionsProvider)
          .settle(
            statementId: 's1',
            creditCardId: 'c1',
            financialAccountId: 'a-usd',
            amount: '1320.45',
            paymentDate: DateTime(2026, 5, 2),
          );

      expect(
        result,
        const Failure<void>(
          message: 'The account must be in BRL to settle this statement.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('CardStatementsScreen', () {
    testWidgets('Given the cycles are still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      // Held open deliberately: a fake that answers in a microtask has already
      // resolved by the first pump, so it could never show the loading state
      // the screen is being asked about here.
      final pending = Completer<Result<List<CardStatement>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            statementRepositoryProvider.overrideWithValue(
              SlowStatements(pending.future),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(
            home: CardStatementsScreen(creditCardId: 'c1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(const Success([]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('statements.empty')), findsOneWidget);
    });

    testWidgets('Given a card with no cycles '
        'When the screen settles '
        'Then an empty state explains that cycles follow charges (AF-06)',
        (tester) async {
      await pumpStatements(tester, FakeStatements(onList: () => const Success([])));

      expect(find.byKey(const Key('statements.empty')), findsOneWidget);
      expect(find.textContaining('once the card has charges'), findsOneWidget);
    });

    testWidgets('Given the cycles cannot be read '
        'When the screen settles '
        'Then the failure is shown with a retry, not an empty state',
        (tester) async {
      var attempts = 0;
      final fake = FakeStatements(
        onList: () {
          attempts++;
          return const Failure(
            message: 'That card was not found.',
            kind: FailureKind.notFound,
          );
        },
      );

      await pumpStatements(tester, fake);

      expect(find.byKey(const Key('statements.empty')), findsNothing);
      expect(find.text('That card was not found.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('statements.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given a cycle '
        'When it is listed '
        'Then its state and amount due are both shown', (tester) async {
      await pumpStatements(
        tester,
        FakeStatements(
          onList: () => Success([
            statement(status: StatementStatus.closed, amountDue: '1320.45'),
          ]),
        ),
      );

      expect(find.byKey(const Key('statements.status.s1')), findsOneWidget);
      expect(find.text('Closed'), findsOneWidget);
      expect(find.textContaining('1,320.45'), findsOneWidget);
    });

    testWidgets('Given a cycle containing a late-arriving charge '
        'When it is listed '
        'Then the cycle is marked (FR-HO-09)', (tester) async {
      await pumpStatements(
        tester,
        FakeStatements(
          onList: () => Success([
            statement(charges: [charge(isLateArriving: true)]),
          ]),
        ),
      );

      expect(find.byKey(const Key('statements.late.s1')), findsOneWidget);
    });
  });

  group('CreditCardsScreen reaching statements', () {
    testWidgets('Given a card '
        'When it is listed '
        'Then its statements are reachable from it (UC-16 step 1)',
        (tester) async {
      tester.view.physicalSize = const Size(1000, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final router = GoRouter(
        initialLocation: Routes.creditCards,
        routes: [
          GoRoute(
            path: Routes.creditCards,
            builder: (context, state) => const CreditCardsScreen(),
          ),
          GoRoute(
            path: Routes.cardStatements,
            builder: (context, state) => CardStatementsScreen(
              creditCardId: state.pathParameters['id'] ?? '',
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            creditCardRepositoryProvider.overrideWithValue(
              FakeCardsForStatements(),
            ),
            statementRepositoryProvider.overrideWithValue(
              FakeStatements(onList: () => const Success([])),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cards.statements.c1')));
      await tester.pumpAndSettle();

      expect(find.byType(CardStatementsScreen), findsOneWidget);
    });
  });

  group('StatementScreen', () {
    testWidgets('Given a statement '
        'When it is opened '
        'Then every figure the API composed is shown as sent', (tester) async {
      await pumpStatement(
        tester,
        FakeStatements(
          onRead: (_) => Success(
            statement(
              previousBalance: '10.10',
              purchaseTotal: '1200.45',
              paymentsReceived: '5.05',
              foreignTax: '20.00',
              otherEntries: '100.00',
              amountDue: '1320.45',
            ),
          ),
        ),
      );

      expect(find.textContaining('10.10'), findsWidgets);
      expect(find.textContaining('1,200.45'), findsWidgets);
      expect(find.textContaining('1,320.45'), findsWidgets);
    });

    testWidgets('Given the statement does not exist '
        'When the screen settles '
        'Then it is presented as not found (AF-05)', (tester) async {
      await pumpStatement(
        tester,
        FakeStatements(
          onRead: (_) => const Failure(
            message: 'That statement was not found.',
            kind: FailureKind.notFound,
          ),
        ),
      );

      expect(find.text('That statement was not found.'), findsOneWidget);
    });

    testWidgets('Given an open statement '
        'When it is opened '
        'Then closing is offered and settling is explained as unavailable '
        '(AF-02)', (tester) async {
      await pumpStatement(tester, FakeStatements());

      expect(find.byKey(const Key('statement.close')), findsOneWidget);
      expect(find.byKey(const Key('statement.settle')), findsNothing);
      expect(find.byKey(const Key('statement.notClosed')), findsOneWidget);
    });

    testWidgets('Given a settled statement '
        'When it is opened '
        'Then it reads as frozen and offers neither action (AF-04)',
        (tester) async {
      await pumpStatement(
        tester,
        FakeStatements(
          onRead: (_) => Success(statement(status: StatementStatus.settled)),
        ),
      );

      expect(find.byKey(const Key('statement.frozen')), findsOneWidget);
      expect(find.byKey(const Key('statement.close')), findsNothing);
      expect(find.byKey(const Key('statement.settle')), findsNothing);
    });

    testWidgets('Given closing is confirmed '
        'When the user accepts the warning '
        'Then the statement is closed (FR-HO-07)', (tester) async {
      final fake = FakeStatements();

      await pumpStatement(tester, fake);
      await tester.tap(find.byKey(const Key('statement.close')));
      await tester.pumpAndSettle();

      expect(find.textContaining('cannot be undone'), findsOneWidget);

      await tester.tap(find.byKey(const Key('statement.close.confirm')));
      await tester.pumpAndSettle();

      expect(fake.closed, ['s1']);
    });

    testWidgets('Given closing is offered '
        'When the user declines the warning '
        'Then nothing is closed', (tester) async {
      final fake = FakeStatements();

      await pumpStatement(tester, fake);
      await tester.tap(find.byKey(const Key('statement.close')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('statement.close.cancel')));
      await tester.pumpAndSettle();

      expect(fake.closed, isEmpty);
    });

    testWidgets('Given closing is refused as too early '
        'When the refusal returns '
        "Then the API's reason is shown (AF-01)", (tester) async {
      final fake = FakeStatements(
        onClose: () => const Failure(
          message: 'This statement cannot be closed before 20 April.',
          kind: FailureKind.conflict,
        ),
      );

      await pumpStatement(tester, fake);
      await tester.tap(find.byKey(const Key('statement.close')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('statement.close.confirm')));
      await tester.pumpAndSettle();

      expect(
        find.text('This statement cannot be closed before 20 April.'),
        findsOneWidget,
      );
    });

    testWidgets('Given a closed statement '
        'When settlement is opened '
        'Then it is presented as a transfer rather than an expense '
        '(FR-HO-08)', (tester) async {
      await pumpStatement(
        tester,
        FakeStatements(
          onRead: (_) => Success(statement(status: StatementStatus.closed)),
        ),
        accounts: FakeAccounts(onList: () => Success([account()])),
      );

      await tester.tap(find.byKey(const Key('statement.settle')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('statement.settle.transferNotice')),
        findsOneWidget,
      );
      expect(find.textContaining('not as an expense'), findsOneWidget);
    });

    testWidgets('Given an account is chosen '
        'When the settlement is confirmed '
        "Then the statement's own amount is sent unchanged", (tester) async {
      final fake = FakeStatements(
        onRead: (_) => Success(
          statement(status: StatementStatus.closed, amountDue: '1320.45'),
        ),
      );

      await pumpStatement(
        tester,
        fake,
        accounts: FakeAccounts(onList: () => Success([account()])),
      );

      await tester.tap(find.byKey(const Key('statement.settle')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('statement.settle.account')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Everyday · BRL').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('statement.settle.confirm')));
      await tester.pumpAndSettle();

      expect(fake.settled.single['amount'], '1320.45');
      expect(fake.settled.single['financialAccountId'], 'a1');
    });

    testWidgets('Given settlement from an account in another currency '
        'When the API refuses '
        'Then the reason is shown on the sheet and nothing is converted '
        '(AF-03)', (tester) async {
      final fake = FakeStatements(
        onRead: (_) => Success(statement(status: StatementStatus.closed)),
        onSettle: () => const Failure(
          message: 'The account must be in BRL to settle this statement.',
          kind: FailureKind.invalidInput,
        ),
      );

      await pumpStatement(
        tester,
        fake,
        accounts: FakeAccounts(onList: () => Success([account()])),
      );

      await tester.tap(find.byKey(const Key('statement.settle')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('statement.settle.account')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Everyday · BRL').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('statement.settle.confirm')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('statement.settle.reason')),
        findsOneWidget,
      );
      expect(
        find.text('The account must be in BRL to settle this statement.'),
        findsOneWidget,
      );
    });

    testWidgets('Given a late-arriving charge '
        'When the statement is opened '
        'Then that charge is marked in the statement that received it '
        '(FR-HO-09)', (tester) async {
      await pumpStatement(
        tester,
        FakeStatements(
          onRead: (_) => Success(
            statement(
              charges: [
                charge(),
                charge(id: 'ch2', isLateArriving: true),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('statement.charge.late.ch2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('statement.charge.late.ch1')),
        findsNothing,
      );
      expect(find.text('Late arrival'), findsOneWidget);
    });

    testWidgets('Given a charge converted from another currency '
        'When the statement is opened '
        'Then the original amount is shown in its own currency', (tester) async {
      await pumpStatement(
        tester,
        FakeStatements(
          onRead: (_) => Success(
            statement(
              charges: [
                charge(originalAmount: '20.00', appliedRate: '5.4321'),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('statement.charge.converted.ch1')),
        findsOneWidget,
      );
      expect(find.textContaining('5.4321'), findsOneWidget);
    });

    testWidgets('Given a statement with no charges '
        'When it is opened '
        'Then it says so rather than showing an empty list', (tester) async {
      await pumpStatement(
        tester,
        FakeStatements(onRead: (_) => Success(statement(charges: []))),
      );

      expect(find.byKey(const Key('statement.noCharges')), findsOneWidget);
    });
  });
}

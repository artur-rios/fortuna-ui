import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/insight/data/projection_repository.dart';
import 'package:fortuna_ui/features/insight/state/projection_providers.dart';
import 'package:fortuna_ui/features/insight/ui/projections_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

import '../holdings/accounts_test.dart' show FakeCurrencies;

class FakeProjections implements ProjectionRepository {
  FakeProjections({this.onPosition, this.onCashFlow, this.onObligations});

  Result<NetPosition> Function()? onPosition;
  Result<CashFlowProjection> Function()? onCashFlow;
  Result<CommittedObligations> Function()? onObligations;

  final List<int> horizonsAsked = [];

  @override
  Future<Result<NetPosition>> netPosition({
    String? displayCurrencyCode,
  }) async => onPosition?.call() ?? Success(position());

  @override
  Future<Result<CashFlowProjection>> cashFlow({
    required int horizonDays,
    String? displayCurrencyCode,
  }) async {
    horizonsAsked.add(horizonDays);
    return onCashFlow?.call() ?? Success(projection());
  }

  @override
  Future<Result<CommittedObligations>> obligations({
    required int horizonDays,
    String? displayCurrencyCode,
  }) async => onObligations?.call() ?? Success(obligations_());
}

NetPosition position({
  String? total = '15000.00',
  List<PositionInCurrency>? byCurrency,
  bool isFullyConverted = true,
  String? displayCurrencyCode = 'BRL',
}) => NetPosition(
  asOf: DateTime(2026, 9, 11),
  isFullyConverted: isFullyConverted,
  displayCurrencyCode: displayCurrencyCode,
  total: total == null ? null : Money.parse(total, 'BRL'),
  byCurrency:
      byCurrency ??
      [
        PositionInCurrency(
          net: Money.parse('15000.00', 'BRL'),
          accounts: Money.parse('12000.00', 'BRL'),
          creditCards: Money.parse('2000.00', 'BRL'),
          investments: Money.parse('5000.00', 'BRL'),
        ),
      ],
);

CashFlowProjection projection({
  int periods = 2,
  String? flatReason,
  String starting = '15000.00',
}) => CashFlowProjection(
  asOf: DateTime(2026, 9, 11),
  through: DateTime(2026, 12, 11),
  startingBalance: Money.parse(starting, 'BRL'),
  flatReason: flatReason,
  displayCurrencyCode: 'BRL',
  periods: [
    for (var i = 0; i < periods; i++)
      ProjectedPeriod(
        periodStart: DateTime(2026, 10 + i),
        periodEnd: DateTime(2026, 10 + i, 28),
        openingBalance: Money.parse('15000.00', 'BRL', isProjected: true),
        closingBalance: Money.parse('16000.00', 'BRL', isProjected: true),
      ),
  ],
);

CommittedObligations obligations_({
  int items = 2,
  bool overdue = false,
  String? total = '800.00',
  bool isFullyConverted = true,
}) => CommittedObligations(
  asOf: DateTime(2026, 9, 11),
  through: DateTime(2026, 12, 11),
  isFullyConverted: isFullyConverted,
  displayCurrencyCode: 'BRL',
  total: total == null ? null : Money.parse(total, 'BRL', isProjected: true),
  items: [
    for (var i = 0; i < items; i++)
      CommittedObligation(
        id: 'o${i + 1}',
        kind: ObligationKind.installment,
        amount: Money.parse('400.00', 'BRL', isProjected: true),
        dueDate: DateTime(2026, 10, 15),
        isOverdue: overdue,
        daysOverdue: overdue ? 3 : 0,
      ),
  ],
);

/// Answers only when the test lets it, so the loading state is observable at
/// all — a fake that answers in a microtask has already resolved by the first
/// pump.
class SlowProjections implements ProjectionRepository {
  SlowProjections(this._pending);

  final Future<Result<NetPosition>> _pending;

  @override
  Future<Result<NetPosition>> netPosition({String? displayCurrencyCode}) =>
      _pending;

  @override
  Future<Result<CashFlowProjection>> cashFlow({
    required int horizonDays,
    String? displayCurrencyCode,
  }) => Completer<Result<CashFlowProjection>>().future;

  @override
  Future<Result<CommittedObligations>> obligations({
    required int horizonDays,
    String? displayCurrencyCode,
  }) => Completer<Result<CommittedObligations>>().future;
}

ProviderContainer containerWith(FakeProjections fake) {
  final container = ProviderContainer(
    overrides: [
      projectionRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpProjections(WidgetTester tester, FakeProjections fake) async {
  tester.view.physicalSize = const Size(1000, 2800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        projectionRepositoryProvider.overrideWithValue(fake),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: ProjectionsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('NetPosition', () {
    test('Given holdings in one currency '
        'When it is asked '
        'Then it does not span currencies', () {
      expect(position().spansCurrencies, isFalse);
      expect(position().hasNoHoldings, isFalse);
    });

    test('Given no holdings at all '
        'When it is asked '
        'Then it reports that, which is not a failure (AF-05)', () {
      expect(position(byCurrency: []).hasNoHoldings, isTrue);
    });

    test('Given holdings that could not be fully converted '
        'When it is asked '
        'Then it spans currencies (AF-03)', () {
      expect(position(isFullyConverted: false).spansCurrencies, isTrue);
    });

    test(
      'Given each currency group '
      'When it is read '
      "Then the net is the API's, not accounts plus investments minus cards",
      () {
        final group = PositionInCurrency(
          net: Money.parse('9000.00', 'BRL'),
          accounts: Money.parse('12000.00', 'BRL'),
          creditCards: Money.parse('2000.00', 'BRL'),
          investments: Money.parse('5000.00', 'BRL'),
        );

        // The obvious arithmetic gives 15000. The API said 9000, and the API
        // is the one that can see everything.
        expect(group.net.amount, Decimal.parse('9000.00'));
      },
    );
  });

  group('CashFlowProjection', () {
    test('Given periods '
        'When their balances are read '
        'Then every projected figure is marked as projected (FR-PJ-04)', () {
      final projected = projection();

      for (final period in projected.periods) {
        expect(period.openingBalance.isProjected, isTrue);
        expect(period.closingBalance.isProjected, isTrue);
      }
    });

    test('Given the starting balance '
        'When it is read '
        'Then it is not projected — it is where things stand today', () {
      expect(projection().startingBalance.isProjected, isFalse);
    });

    test('Given no periods '
        'When it is asked '
        'Then there is nothing to project (AF-01)', () {
      expect(projection(periods: 0).hasNothingToProject, isTrue);
    });

    test('Given the API states a reason it could not project '
        'When it is asked '
        'Then that counts as nothing to project (AF-01)', () {
      expect(
        projection(flatReason: 'Too little history.').hasNothingToProject,
        isTrue,
      );
    });
  });

  group('CommittedObligations', () {
    test('Given obligations '
        'When their amounts are read '
        'Then each is marked as scheduled rather than recorded (FR-PJ-04)', () {
      for (final item in obligations_().items) {
        expect(item.amount.isProjected, isTrue);
      }
      expect(obligations_().total!.isProjected, isTrue);
    });

    test('Given the kinds the contract specifies '
        'When they are mapped '
        'Then each keeps its own meaning', () {
      expect(ObligationKind.installment.wire, 1);
      expect(ObligationKind.statement.wire, 2);
      expect(ObligationKind.from(null), ObligationKind.other);
    });

    test('Given nothing committed '
        'When it is asked '
        'Then it is empty', () {
      expect(obligations_(items: 0).isEmpty, isTrue);
    });
  });

  group('Projection providers', () {
    test('Given a horizon '
        'When the projection is read '
        'Then that many days are asked for (step 2)', () async {
      final fake = FakeProjections();

      await containerWith(fake).read(
        cashFlowProvider(const ProjectionRequest(horizon: Horizon.oneYear))
            .future,
      );

      expect(fake.horizonsAsked.single, 365);
    });

    test('Given the request fails '
        'When the projection is read '
        "Then the API's reason surfaces (AF-02)", () async {
      final fake = FakeProjections(
        onCashFlow: () => const Failure(
          message: 'The projection could not be computed.',
          kind: FailureKind.serverError,
        ),
      );

      await expectLater(
        containerWith(fake)
            .read(cashFlowProvider(const ProjectionRequest()).future),
        throwsA(
          isA<ProjectionUnavailable>().having(
            (e) => e.message,
            'message',
            'The projection could not be computed.',
          ),
        ),
      );
    });
  });

  group('ProjectionsScreen', () {
    testWidgets('Given everything is still loading '
        'When the screen is built '
        'Then progress indicators are shown', (tester) async {
      tester.view.physicalSize = const Size(1000, 2800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final pending = Completer<Result<NetPosition>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectionRepositoryProvider.overrideWithValue(
              SlowProjections(pending.future),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: ProjectionsScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      pending.complete(Success(position()));
      await tester.pump();

      expect(find.byKey(const Key('position.total')), findsOneWidget);
    });

    testWidgets('Given a net position '
        'When the screen settles '
        'Then it is shown as the API reported it (step 1)', (tester) async {
      await pumpProjections(tester, FakeProjections());

      expect(find.byKey(const Key('position.total')), findsOneWidget);
      expect(find.textContaining('15,000.00'), findsWidgets);
    });

    testWidgets('Given no holdings '
        'When the screen settles '
        'Then a zero is explained, distinct from a failure (AF-05)', (
      tester,
    ) async {
      await pumpProjections(
        tester,
        FakeProjections(onPosition: () => Success(position(byCurrency: []))),
      );

      expect(find.byKey(const Key('position.noHoldings')), findsOneWidget);
      expect(find.byKey(const Key('position.failed')), findsNothing);
      expect(find.textContaining('not a failure to read them'), findsOneWidget);
    });

    testWidgets('Given the net position fails '
        'When the screen settles '
        'Then a failure with a retry is shown (AF-02)', (tester) async {
      var attempts = 0;
      final fake = FakeProjections(
        onPosition: () {
          attempts++;
          return const Failure(
            message: 'The net position could not be read.',
            kind: FailureKind.serverError,
          );
        },
      );

      await pumpProjections(tester, fake);

      expect(find.byKey(const Key('position.failed')), findsOneWidget);

      await tester.tap(find.byKey(const Key('position.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given holdings in several currencies '
        'When the position is shown '
        'Then each is listed rather than summed (AF-03)', (tester) async {
      await pumpProjections(
        tester,
        FakeProjections(
          onPosition: () => Success(
            position(
              total: null,
              isFullyConverted: false,
              displayCurrencyCode: null,
              byCurrency: [
                PositionInCurrency(
                  net: Money.parse('15000.00', 'BRL'),
                  accounts: Money.parse('15000.00', 'BRL'),
                  creditCards: Money.parse('0', 'BRL'),
                  investments: Money.parse('0', 'BRL'),
                ),
                PositionInCurrency(
                  net: Money.parse('2000.00', 'USD'),
                  accounts: Money.parse('2000.00', 'USD'),
                  creditCards: Money.parse('0', 'USD'),
                  investments: Money.parse('0', 'USD'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('position.multipleCurrencies')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('position.currency.BRL')), findsOneWidget);
      expect(find.byKey(const Key('position.currency.USD')), findsOneWidget);
      expect(find.textContaining('rather than added together'), findsOneWidget);
    });

    testWidgets('Given a projection '
        'When it is shown '
        'Then it is labelled as projected in words, not by colour alone '
        '(step 4, FR-PJ-04, NFR-17)', (tester) async {
      await pumpProjections(tester, FakeProjections());

      expect(find.byKey(const Key('projected.label')), findsWidgets);
      expect(find.text('Projected'), findsWidgets);
      expect(find.textContaining('forecasts, not records'), findsWidgets);
    });

    testWidgets('Given too little history to project '
        'When the projection returns '
        'Then that is said rather than a forecast built on nothing (AF-01)', (
      tester,
    ) async {
      await pumpProjections(
        tester,
        FakeProjections(
          onCashFlow: () => Success(
            projection(
              periods: 0,
              flatReason: 'There is too little history to project from.',
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('cashFlow.nothingToProject')),
        findsOneWidget,
      );
      expect(
        find.text('There is too little history to project from.'),
        findsOneWidget,
      );
      // And no projected figures are shown at all.
      expect(find.byKey(const Key('cashFlow.startingBalance')), findsNothing);
    });

    testWidgets('Given a horizon is chosen '
        'When it changes '
        'Then the projection is asked for that period (step 2)', (
      tester,
    ) async {
      final fake = FakeProjections();

      await pumpProjections(tester, fake);
      expect(fake.horizonsAsked.last, 90);

      await tester.tap(find.byKey(const Key('projections.horizon')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next year').last);
      await tester.pumpAndSettle();

      expect(fake.horizonsAsked.last, 365);
    });

    testWidgets('Given committed obligations '
        'When they are shown '
        'Then each is listed with its due date (step 3)', (tester) async {
      await pumpProjections(tester, FakeProjections());

      expect(find.byKey(const Key('obligations.item.o1')), findsOneWidget);
      expect(find.byKey(const Key('obligations.item.o2')), findsOneWidget);
      expect(find.byKey(const Key('obligations.total')), findsOneWidget);
    });

    testWidgets('Given an overdue obligation '
        'When it is shown '
        'Then it says so in words, not only in colour (NFR-17)', (
      tester,
    ) async {
      await pumpProjections(
        tester,
        FakeProjections(
          onObligations: () => Success(obligations_(overdue: true)),
        ),
      );

      expect(find.byKey(const Key('obligations.overdue.o1')), findsOneWidget);
      expect(find.textContaining('Overdue by 3 days'), findsWidgets);
    });

    testWidgets('Given nothing committed '
        'When the section is shown '
        'Then it says so', (tester) async {
      await pumpProjections(
        tester,
        FakeProjections(onObligations: () => Success(obligations_(items: 0))),
      );

      expect(find.byKey(const Key('obligations.empty')), findsOneWidget);
    });

    testWidgets('Given the obligations fail '
        'When the screen settles '
        'Then a failure with a retry is shown, and the position still shows '
        '(AF-02)', (tester) async {
      await pumpProjections(
        tester,
        FakeProjections(
          onObligations: () => const Failure(
            message: 'The obligations could not be read.',
            kind: FailureKind.serverError,
          ),
        ),
      );

      expect(find.byKey(const Key('obligations.failed')), findsOneWidget);
      expect(find.byKey(const Key('obligations.retry')), findsOneWidget);
      // One section failing does not take the others down with it.
      expect(find.byKey(const Key('position.total')), findsOneWidget);
    });
  });
}

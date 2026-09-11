import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/insight/data/aggregation_repository.dart';
import 'package:fortuna_ui/features/insight/state/aggregation_providers.dart';
import 'package:fortuna_ui/features/insight/ui/aggregation_chart.dart';
import 'package:fortuna_ui/features/insight/ui/insight_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';

import '../holdings/accounts_test.dart' show FakeCurrencies;

class FakeAggregations implements AggregationRepository {
  FakeAggregations({this.onAggregate});

  Result<Aggregation> Function(Grouping grouping)? onAggregate;

  final List<Map<String, Object?>> asked = [];

  @override
  Future<Result<Aggregation>> aggregate({
    required Grouping grouping,
    required DateTime from,
    required DateTime to,
    Granularity? granularity,
    String? displayCurrencyCode,
    Direction? direction,
    String? financialAccountId,
    String? categoryId,
    String? counterpartyId,
    bool rollUpSmallest = true,
  }) async {
    asked.add({
      'grouping': grouping,
      'from': from,
      'to': to,
      'granularity': granularity,
      'displayCurrencyCode': displayCurrencyCode,
      'rollUpSmallest': rollUpSmallest,
    });
    return onAggregate?.call(grouping) ?? Success(aggregation());
  }

  // UC-37 added this to the interface. Defaulted here so the UC-36 tests stay
  // about UC-36; `DrillableAggregations` in drill_down_test.dart is where it
  // is actually exercised.
  @override
  Future<Result<DrillLevel>> drillDown({
    required String key,
    String? dimension,
    String? displayCurrencyCode,
    int pageNumber = 1,
    int pageSize = 50,
  }) async => const Success(DrillBuckets(dimension: '', buckets: []));
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowAggregations implements AggregationRepository {
  SlowAggregations(this._pending);

  final Future<Result<Aggregation>> _pending;

  @override
  Future<Result<Aggregation>> aggregate({
    required Grouping grouping,
    required DateTime from,
    required DateTime to,
    Granularity? granularity,
    String? displayCurrencyCode,
    Direction? direction,
    String? financialAccountId,
    String? categoryId,
    String? counterpartyId,
    bool rollUpSmallest = true,
  }) => _pending;

  @override
  Future<Result<DrillLevel>> drillDown({
    required String key,
    String? dimension,
    String? displayCurrencyCode,
    int pageNumber = 1,
    int pageSize = 50,
  }) async => const Success(DrillBuckets(dimension: '', buckets: []));
}

AggregationBucket bucket({
  String label = 'Groceries',
  String? total = '550.25',
  String currency = 'BRL',
  String? share = '0.4',
  String? drillDownKey = 'cat1',
  bool isFullyConverted = true,
  List<UnconvertedAmount> unconverted = const [],
}) => AggregationBucket(
  label: label,
  total: total == null ? null : Money.parse(total, currency),
  share: share == null ? null : Decimal.parse(share),
  isFullyConverted: isFullyConverted,
  unconverted: unconverted,
  drillDownKey: drillDownKey,
);

Aggregation aggregation({
  Grouping grouping = Grouping.category,
  List<AggregationBucket>? buckets,
  bool isFullyConverted = true,
  String? displayCurrencyCode = 'BRL',
}) => Aggregation(
  grouping: grouping,
  buckets: buckets ?? [bucket(), bucket(label: 'Transport', total: '120.00')],
  from: DateTime(2026),
  to: DateTime(2026, 12, 31),
  isFullyConverted: isFullyConverted,
  displayCurrencyCode: displayCurrencyCode,
);

ProviderContainer containerWith(FakeAggregations fake) {
  final container = ProviderContainer(
    overrides: [
      aggregationRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpInsight(
  WidgetTester tester,
  AggregationRepository fake,
) async {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        aggregationRepositoryProvider.overrideWithValue(fake),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: InsightScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Grouping', () {
    test('Given the groupings the API supports '
        'When they are listed '
        'Then each names the dimension the API knows (AF-04)', () {
      expect(Grouping.period.wireName, 'period');
      expect(Grouping.category.wireName, 'category');
      expect(Grouping.account.wireName, 'account');
      expect(Grouping.counterparty.wireName, 'counterparty');
    });

    test('Given a grouping '
        'When it is asked whether it is temporal '
        'Then only the period grouping is', () {
      expect(Grouping.period.isTemporal, isTrue);
      expect(Grouping.category.isTemporal, isFalse);
    });
  });

  group('AggregationBucket', () {
    test('Given a share the API computed '
        'When it is asked for as thousandths '
        'Then it is an exact integer, with no float in the conversion', () {
      expect(bucket(share: '0.4').sharePermille, 400);
      expect(bucket(share: '0').sharePermille, 0);
      expect(bucket(share: '1').sharePermille, 1000);
      expect(bucket(share: '0.3333').sharePermille, 333);
    });

    test('Given no share '
        'When it is asked '
        'Then there are no thousandths either', () {
      expect(bucket(share: null).sharePermille, isNull);
    });

    test('Given a bucket with a drill-down key '
        'When it is asked '
        'Then descending is possible (FR-CH-03)', () {
      expect(bucket().canDrillDown, isTrue);
      expect(bucket(drillDownKey: null).canDrillDown, isFalse);
      expect(bucket(drillDownKey: '').canDrillDown, isFalse);
    });

    test('Given a total the API computed '
        'When it is read '
        'Then it is exactly what was sent, not derived (FR-CH-02)', () {
      expect(bucket(total: '550.25').total!.amount, Decimal.parse('550.25'));
    });
  });

  group('Aggregation', () {
    test('Given no buckets '
        'When it is asked '
        'Then it is empty, which is not a failure (AF-01)', () {
      expect(aggregation(buckets: []).isEmpty, isTrue);
    });

    test('Given everything converted into one currency '
        'When it is asked '
        'Then it does not span currencies', () {
      expect(aggregation().spansCurrencies, isFalse);
    });

    test('Given the aggregation could not be fully converted '
        'When it is asked '
        'Then it spans currencies (AF-03)', () {
      expect(aggregation(isFullyConverted: false).spansCurrencies, isTrue);
    });

    test('Given one bucket that could not be fully converted '
        'When the aggregation is asked '
        'Then it spans currencies even though the whole claims otherwise', () {
      // The aggregation-level flag alone is not enough: a single unconverted
      // bucket still means the totals are not comparable.
      final partly = aggregation(
        buckets: [
          bucket(),
          bucket(label: 'Travel', isFullyConverted: false),
        ],
      );

      expect(partly.spansCurrencies, isTrue);
    });
  });

  group('aggregationProvider', () {
    test(
      'Given a request '
      'When the aggregation is read '
      'Then the grouping and period are asked of the API (FR-CH-02)',
      () async {
        final fake = FakeAggregations();

        await containerWith(fake).read(
          aggregationProvider(
            AggregationRequest(
              grouping: Grouping.counterparty,
              from: DateTime(2026),
              to: DateTime(2026, 6, 30),
            ),
          ).future,
        );

        final asked = fake.asked.single;
        expect(asked['grouping'], Grouping.counterparty);
        expect(asked['from'], DateTime(2026));
        expect(asked['to'], DateTime(2026, 6, 30));
      },
    );

    test('Given a non-temporal grouping '
        'When the aggregation is read '
        'Then no granularity is sent, since it would mean nothing', () async {
      final fake = FakeAggregations();

      await containerWith(fake).read(
        aggregationProvider(
          AggregationRequest(
            grouping: Grouping.category,
            from: DateTime(2026),
            to: DateTime(2026, 6, 30),
          ),
        ).future,
      );

      expect(fake.asked.single['granularity'], isNull);
    });

    test('Given a temporal grouping '
        'When the aggregation is read '
        'Then the granularity is sent', () async {
      final fake = FakeAggregations();

      await containerWith(fake).read(
        aggregationProvider(
          AggregationRequest(
            grouping: Grouping.period,
            granularity: Granularity.weekly,
            from: DateTime(2026),
            to: DateTime(2026, 6, 30),
          ),
        ).future,
      );

      expect(fake.asked.single['granularity'], Granularity.weekly);
    });

    test('Given the request fails '
        'When the aggregation is read '
        "Then the API's reason surfaces (AF-02)", () async {
      final fake = FakeAggregations(
        onAggregate: (_) => const Failure(
          message: 'The aggregation could not be computed.',
          kind: FailureKind.serverError,
        ),
      );

      await expectLater(
        containerWith(fake).read(
          aggregationProvider(
            AggregationRequest(
              grouping: Grouping.category,
              from: DateTime(2026),
              to: DateTime(2026, 6, 30),
            ),
          ).future,
        ),
        throwsA(
          isA<AggregationUnavailable>().having(
            (e) => e.message,
            'message',
            'The aggregation could not be computed.',
          ),
        ),
      );
    });

    test(
      'Given the smallest elements would be too many to plot '
      'When the aggregation is read '
      'Then the API is asked to roll them up, not this client (AF-05)',
      () async {
        final fake = FakeAggregations();

        await containerWith(fake).read(
          aggregationProvider(
            AggregationRequest(
              grouping: Grouping.category,
              from: DateTime(2026),
              to: DateTime(2026, 6, 30),
            ),
          ).future,
        );

        // FR-CH-04: subdividing an aggregate this client holds is forbidden,
        // so the rollup is the instance's to perform.
        expect(fake.asked.single['rollUpSmallest'], isTrue);
      },
    );
  });

  group('InsightScreen', () {
    testWidgets('Given the aggregation is still loading '
        'When the screen is built '
        'Then a loading state is shown', (tester) async {
      final pending = Completer<Result<Aggregation>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aggregationRepositoryProvider.overrideWithValue(
              SlowAggregations(pending.future),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: InsightScreen()),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('insight.loading')), findsOneWidget);

      pending.complete(Success(aggregation()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chart.bars')), findsOneWidget);
    });

    testWidgets('Given nothing in the period '
        'When the screen settles '
        'Then an empty state says so, distinct from a failure (AF-01)', (
      tester,
    ) async {
      await pumpInsight(
        tester,
        FakeAggregations(onAggregate: (_) => Success(aggregation(buckets: []))),
      );

      expect(find.byKey(const Key('insight.empty')), findsOneWidget);
      expect(find.byKey(const Key('insight.failed')), findsNothing);
    });

    testWidgets('Given the request fails '
        'When the screen settles '
        'Then a failure with a retry is shown, not an empty state (AF-02)', (
      tester,
    ) async {
      var attempts = 0;
      final fake = FakeAggregations(
        onAggregate: (_) {
          attempts++;
          return const Failure(
            message: 'The aggregation could not be computed.',
            kind: FailureKind.serverError,
          );
        },
      );

      await pumpInsight(tester, fake);

      expect(find.byKey(const Key('insight.failed')), findsOneWidget);
      expect(find.byKey(const Key('insight.empty')), findsNothing);

      await tester.tap(find.byKey(const Key('insight.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given a categorical grouping '
        'When it is rendered '
        'Then it is drawn as bars (step 3)', (tester) async {
      await pumpInsight(tester, FakeAggregations());

      expect(find.byKey(const Key('chart.bars')), findsOneWidget);
      expect(find.byKey(const Key('chart.line')), findsNothing);
    });

    testWidgets('Given a temporal grouping '
        'When it is rendered '
        'Then it is drawn as a line, since the order means something', (
      tester,
    ) async {
      await pumpInsight(
        tester,
        FakeAggregations(
          onAggregate: (_) => Success(aggregation(grouping: Grouping.period)),
        ),
      );

      // The grouping control starts categorical, so switch it.
      await tester.tap(find.byKey(const Key('insight.grouping')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Over time').last);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chart.line')), findsOneWidget);
      expect(find.byKey(const Key('chart.bars')), findsNothing);
    });

    testWidgets('Given a temporal grouping '
        'When it is chosen '
        'Then a granularity can be chosen too', (tester) async {
      await pumpInsight(
        tester,
        FakeAggregations(
          onAggregate: (_) => Success(aggregation(grouping: Grouping.period)),
        ),
      );

      expect(find.byKey(const Key('insight.granularity')), findsNothing);

      await tester.tap(find.byKey(const Key('insight.grouping')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Over time').last);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('insight.granularity')), findsOneWidget);
    });

    testWidgets('Given each element '
        'When the aggregation is shown '
        'Then every figure carries its currency (step 5, FR-CH-10)', (
      tester,
    ) async {
      await pumpInsight(tester, FakeAggregations());

      expect(find.byKey(const Key('chart.total.Groceries')), findsOneWidget);
      expect(find.byKey(const Key('chart.total.Transport')), findsOneWidget);
      // MoneyText renders the currency; a bare number would not.
      expect(find.textContaining('550.25'), findsOneWidget);
    });

    testWidgets('Given amounts in several currencies with none chosen '
        'When the aggregation is shown '
        'Then it says they are shown separately rather than summed (AF-03)', (
      tester,
    ) async {
      await pumpInsight(
        tester,
        FakeAggregations(
          onAggregate: (_) => Success(
            aggregation(isFullyConverted: false, displayCurrencyCode: null),
          ),
        ),
      );

      expect(
        find.byKey(const Key('insight.multipleCurrencies')),
        findsOneWidget,
      );
      expect(find.textContaining('rather than added together'), findsOneWidget);
    });

    testWidgets('Given some amounts could not be converted '
        'When the aggregation is shown '
        'Then each is listed in its own currency beside the total (AF-03)', (
      tester,
    ) async {
      await pumpInsight(
        tester,
        FakeAggregations(
          onAggregate: (_) => Success(
            aggregation(
              isFullyConverted: false,
              buckets: [
                bucket(
                  isFullyConverted: false,
                  unconverted: [
                    UnconvertedAmount(
                      amount: Money.parse('46.05', 'USD'),
                      reason: 'No rate for USD on that date.',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('chart.unconverted.Groceries.USD')),
        findsOneWidget,
      );
      expect(find.textContaining('Not converted'), findsOneWidget);
    });

    testWidgets('Given a bucket the API could not total '
        'When it is shown '
        'Then no figure is invented for it', (tester) async {
      await pumpInsight(
        tester,
        FakeAggregations(
          onAggregate: (_) =>
              Success(aggregation(buckets: [bucket(total: null)])),
        ),
      );

      expect(find.byKey(const Key('chart.noTotal.Groceries')), findsOneWidget);
      expect(find.byKey(const Key('chart.total.Groceries')), findsNothing);
    });

    testWidgets('Given a bar chart '
        'When its rods are inspected '
        'Then they plot the share, not the amount (FR-CH-08)', (tester) async {
      await pumpInsight(
        tester,
        FakeAggregations(
          onAggregate: (_) => Success(
            aggregation(
              buckets: [bucket(total: '550.25', share: '0.4')],
            ),
          ),
        ),
      );

      final chart = tester.widget<BarChart>(
        find.byKey(const Key('chart.bars')),
      );
      final rod = chart.data.barGroups.single.barRods.single;

      // 0.4, the share — emphatically not 550.25. A coordinate carrying a
      // monetary value is the defect FR-CH-08 exists to prevent.
      expect(rod.toY, 0.4);
    });

    testWidgets('Given a line chart '
        'When its spots are inspected '
        'Then they plot the share, not the amount (FR-CH-08)', (tester) async {
      await pumpInsight(
        tester,
        FakeAggregations(
          onAggregate: (_) => Success(
            aggregation(
              grouping: Grouping.period,
              buckets: [bucket(label: 'Jan', total: '550.25', share: '0.4')],
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('insight.grouping')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Over time').last);
      await tester.pumpAndSettle();

      final chart = tester.widget<LineChart>(
        find.byKey(const Key('chart.line')),
      );
      expect(chart.data.lineBarsData.single.spots.single.y, 0.4);
    });
  });

  group('AggregationChart selection', () {
    testWidgets('Given a drillable element '
        'When it is selected from the legend '
        'Then the bucket itself is reported, not a coordinate (FR-CH-08)', (
      tester,
    ) async {
      AggregationBucket? selected;

      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AggregationChart(
                  aggregation: aggregation(),
                  onSelect: (value) => selected = value,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.label, 'Groceries');
      expect(selected!.total!.amount, Decimal.parse('550.25'));
    });

    testWidgets('Given an element with no drill-down key '
        'When it is shown '
        'Then it cannot be selected', (tester) async {
      var selections = 0;

      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AggregationChart(
                  aggregation: aggregation(
                    buckets: [bucket(drillDownKey: null)],
                  ),
                  onSelect: (_) => selections++,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(selections, 0);
    });
  });
}

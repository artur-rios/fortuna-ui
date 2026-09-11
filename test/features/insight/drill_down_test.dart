import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/insight/data/aggregation_repository.dart';
import 'package:fortuna_ui/features/insight/state/drill_down_controller.dart';
import 'package:fortuna_ui/features/insight/ui/insight_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';

import '../holdings/accounts_test.dart' show FakeCurrencies;
import 'aggregation_test.dart' show FakeAggregations, bucket;

/// Extends the UC-36 fake with the descent UC-37 adds.
class DrillableAggregations extends FakeAggregations {
  DrillableAggregations({super.onAggregate, this.onDrill});

  Result<DrillLevel> Function(String key)? onDrill;

  final List<Map<String, Object?>> drills = [];

  @override
  Future<Result<DrillLevel>> drillDown({
    required String key,
    String? dimension,
    String? displayCurrencyCode,
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    drills.add({
      'key': key,
      'dimension': dimension,
      'displayCurrencyCode': displayCurrencyCode,
    });
    return onDrill?.call(key) ?? Success(deeperBuckets());
  }
}

DrillLevel deeperBuckets({List<AggregationBucket>? buckets}) => DrillBuckets(
  dimension: 'counterparty',
  buckets: buckets ?? [bucket(label: 'A Market', drillDownKey: 'cp1')],
);

DrillLevel finestLevel({int count = 2, bool mayDifferFromChart = false}) =>
    DrillTransactions(
      transactions: [
        for (var i = 0; i < count; i++)
          Transaction(
            id: 't${i + 1}',
            occurredOn: DateTime(2026, 9, 10),
            amount: Money.parse('125.50', 'BRL'),
            direction: Direction.expense,
            categoryId: 'cat1',
            categoryName: 'Groceries',
            description: 'Weekly shop',
          ),
      ],
      totalItems: count,
      mayDifferFromChart: mayDifferFromChart,
    );

ProviderContainer containerWith(DrillableAggregations fake) {
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
  DrillableAggregations fake,
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
  group('DrillDownController', () {
    test('Given the chart '
        'When nothing has been drilled '
        'Then the path is empty and the chart stands unfiltered (AF-04)', () {
      final container = containerWith(DrillableAggregations());

      expect(container.read(drillDownControllerProvider), isA<AtChart>());
      expect(
        container.read(drillDownControllerProvider.notifier).path,
        isEmpty,
      );
    });

    test('Given an element is selected '
        "Then the bucket's own key is what descends, never a coordinate "
        '(FR-CH-08, step 2)', () async {
      final fake = DrillableAggregations();
      final container = containerWith(fake);

      await container
          .read(drillDownControllerProvider.notifier)
          .descend(
            bucket(label: 'Groceries', drillDownKey: 'cat1'),
            dimension: 'category',
            displayCurrencyCode: 'BRL',
          );

      expect(fake.drills.single['key'], 'cat1');
      expect(fake.drills.single['dimension'], 'category');
      expect(fake.drills.single['displayCurrencyCode'], 'BRL');
    });

    test('Given an element with no drill-down key '
        'When it is selected '
        'Then nothing is requested', () async {
      final fake = DrillableAggregations();
      final container = containerWith(fake);

      await container
          .read(drillDownControllerProvider.notifier)
          .descend(bucket(drillDownKey: null), dimension: 'category');

      expect(fake.drills, isEmpty);
      expect(container.read(drillDownControllerProvider), isA<AtChart>());
    });

    test('Given a descent '
        'When it succeeds '
        'Then the step is appended to the path (step 4)', () async {
      final container = containerWith(DrillableAggregations());
      final controller = container.read(drillDownControllerProvider.notifier);

      await controller.descend(
        bucket(label: 'Groceries', drillDownKey: 'cat1'),
        dimension: 'category',
      );

      expect(controller.path, hasLength(1));
      expect(controller.path.single.label, 'Groceries');
      expect(container.read(drillDownControllerProvider), isA<DrillLoaded>());
    });

    test('Given two descents '
        'When stepping back once '
        'Then the level above is asked for again (FR-CH-06, step 7)', () async {
      final fake = DrillableAggregations();
      final container = containerWith(fake);
      final controller = container.read(drillDownControllerProvider.notifier);

      await controller.descend(
        bucket(label: 'Groceries', drillDownKey: 'cat1'),
        dimension: 'category',
      );
      await controller.descend(
        bucket(label: 'A Market', drillDownKey: 'cp1'),
        dimension: 'counterparty',
      );
      expect(controller.path, hasLength(2));

      await controller.stepBack();

      expect(controller.path, hasLength(1));
      expect(controller.path.single.label, 'Groceries');
      expect(fake.drills.last['key'], 'cat1');
    });

    test('Given one level '
        'When stepping back from it '
        'Then the chart returns to its unfiltered state (AF-04)', () async {
      final container = containerWith(DrillableAggregations());
      final controller = container.read(drillDownControllerProvider.notifier);

      await controller.descend(
        bucket(drillDownKey: 'cat1'),
        dimension: 'category',
      );
      await controller.stepBack();

      expect(container.read(drillDownControllerProvider), isA<AtChart>());
      expect(controller.path, isEmpty);
    });

    test('Given three levels '
        'When jumping to the first '
        'Then the path is truncated to it', () async {
      final container = containerWith(DrillableAggregations());
      final controller = container.read(drillDownControllerProvider.notifier);

      await controller.descend(
        bucket(label: 'One', drillDownKey: 'k1'),
        dimension: 'category',
      );
      await controller.descend(
        bucket(label: 'Two', drillDownKey: 'k2'),
        dimension: 'counterparty',
      );
      await controller.descend(
        bucket(label: 'Three', drillDownKey: 'k3'),
        dimension: 'account',
      );

      await controller.stepTo(0);

      expect(controller.path, hasLength(1));
      expect(controller.path.single.label, 'One');
    });

    test('Given any level '
        'When jumping above the root '
        'Then the chart returns unfiltered (AF-04)', () async {
      final container = containerWith(DrillableAggregations());
      final controller = container.read(drillDownControllerProvider.notifier);

      await controller.descend(
        bucket(drillDownKey: 'cat1'),
        dimension: 'category',
      );
      await controller.stepTo(-1);

      expect(container.read(drillDownControllerProvider), isA<AtChart>());
    });

    test(
      'Given the breakdown request fails '
      'When it returns '
      'Then the path survives so the level above stays reachable (AF-02)',
      () async {
        final fake = DrillableAggregations(
          onDrill: (_) => const Failure(
            message: 'The breakdown could not be computed.',
            kind: FailureKind.serverError,
          ),
        );
        final container = containerWith(fake);
        final controller = container.read(drillDownControllerProvider.notifier);

        await controller.descend(
          bucket(label: 'Groceries', drillDownKey: 'cat1'),
          dimension: 'category',
        );

        final state = container.read(drillDownControllerProvider);
        expect(state, isA<DrillFailed>());
        expect(
          (state as DrillFailed).reason,
          'The breakdown could not be computed.',
        );
        // The path is intact, which is what makes stepping back possible.
        expect(controller.path, hasLength(1));
      },
    );

    test('Given a failed level '
        'When it is retried '
        'Then the same level is asked for again (AF-02)', () async {
      var attempts = 0;
      final fake = DrillableAggregations(
        onDrill: (_) {
          attempts++;
          return attempts == 1
              ? const Failure<DrillLevel>(
                  message: 'The breakdown could not be computed.',
                  kind: FailureKind.serverError,
                )
              : Success(deeperBuckets());
        },
      );
      final container = containerWith(fake);
      final controller = container.read(drillDownControllerProvider.notifier);

      await controller.descend(
        bucket(drillDownKey: 'cat1'),
        dimension: 'category',
      );
      await controller.retry();

      expect(attempts, 2);
      expect(container.read(drillDownControllerProvider), isA<DrillLoaded>());
      expect(fake.drills.last['key'], 'cat1');
    });

    test('Given the finest level '
        'When it is reached '
        'Then the transactions are what came back (AF-01, step 6)', () async {
      final container = containerWith(
        DrillableAggregations(onDrill: (_) => Success(finestLevel())),
      );

      await container
          .read(drillDownControllerProvider.notifier)
          .descend(bucket(drillDownKey: 'cat1'), dimension: 'category');

      final state = container.read(drillDownControllerProvider);
      expect(state, isA<DrillLoaded>());
      expect((state as DrillLoaded).level, isA<DrillTransactions>());
    });

    test('Given a remainder group '
        'When it is selected '
        'Then it descends like any other element (AF-06)', () async {
      final fake = DrillableAggregations();
      final container = containerWith(fake);

      // A remainder is a bucket with a key. There is no special case for it,
      // which is the point.
      await container
          .read(drillDownControllerProvider.notifier)
          .descend(
            bucket(label: 'Everything else', drillDownKey: 'remainder'),
            dimension: 'category',
          );

      expect(fake.drills.single['key'], 'remainder');
      expect(container.read(drillDownControllerProvider), isA<DrillLoaded>());
    });
  });

  group('DrillLevel', () {
    test('Given an empty breakdown '
        'When it is asked '
        'Then it is empty (AF-03)', () {
      expect((deeperBuckets(buckets: []) as DrillBuckets).isEmpty, isTrue);
      expect((finestLevel(count: 0) as DrillTransactions).isEmpty, isTrue);
    });

    test('Given the finest level '
        'When it carries the API\'s warning '
        'Then that warning is preserved', () {
      final warned = finestLevel(mayDifferFromChart: true) as DrillTransactions;

      expect(warned.mayDifferFromChart, isTrue);
    });
  });

  group('Drilling on the insight screen', () {
    testWidgets('Given a chart element '
        'When it is selected from the legend '
        'Then the drill path opens with it (steps 1 to 5)', (tester) async {
      await pumpInsight(tester, DrillableAggregations());

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('drill.crumb.root')), findsOneWidget);
      expect(find.byKey(const Key('drill.crumb.current')), findsOneWidget);
      expect(find.text('Groceries'), findsWidgets);
    });

    testWidgets('Given a drilled level '
        'When the root crumb is tapped '
        'Then the unfiltered chart returns (AF-04)', (tester) async {
      await pumpInsight(tester, DrillableAggregations());

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('drill.crumb.root')));
      await tester.pumpAndSettle();

      // The chart's own controls are back, which only happens at the root.
      expect(find.byKey(const Key('insight.grouping')), findsOneWidget);
      expect(find.byKey(const Key('drill.crumb.root')), findsNothing);
    });

    testWidgets('Given the breakdown fails '
        'When it returns '
        'Then the failure is reported with a retry and the path stays '
        '(AF-02)', (tester) async {
      await pumpInsight(
        tester,
        DrillableAggregations(
          onDrill: (_) => const Failure(
            message: 'The breakdown could not be computed.',
            kind: FailureKind.serverError,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('drill.failed')), findsOneWidget);
      expect(find.byKey(const Key('drill.retry')), findsOneWidget);
      // The path is still above it.
      expect(find.byKey(const Key('drill.crumb.root')), findsOneWidget);
    });

    testWidgets('Given an empty breakdown '
        'When it is shown '
        'Then an empty state appears with the path intact (AF-03)', (
      tester,
    ) async {
      await pumpInsight(
        tester,
        DrillableAggregations(
          onDrill: (_) => Success(deeperBuckets(buckets: [])),
        ),
      );

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('drill.empty')), findsOneWidget);
      expect(find.byKey(const Key('drill.crumb.root')), findsOneWidget);
    });

    testWidgets('Given the finest level '
        'When it is reached '
        'Then the transactions are presented (step 6, AF-01)', (tester) async {
      await pumpInsight(
        tester,
        DrillableAggregations(onDrill: (_) => Success(finestLevel())),
      );

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('drill.transactions')), findsOneWidget);
      expect(find.byKey(const Key('drill.transaction.t1')), findsOneWidget);
      expect(find.byKey(const Key('drill.transaction.t2')), findsOneWidget);
    });

    testWidgets('Given the API warns the rows may not add up '
        'When the finest level is shown '
        'Then the warning is passed on rather than hidden', (tester) async {
      await pumpInsight(
        tester,
        DrillableAggregations(
          onDrill: (_) => Success(finestLevel(mayDifferFromChart: true)),
        ),
      );

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('drill.mayDiffer')), findsOneWidget);
      expect(find.textContaining('may not add up'), findsOneWidget);
    });

    testWidgets('Given no warning '
        'When the finest level is shown '
        'Then none is invented', (tester) async {
      await pumpInsight(
        tester,
        DrillableAggregations(onDrill: (_) => Success(finestLevel())),
      );

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('drill.mayDiffer')), findsNothing);
    });

    testWidgets('Given a deeper level of buckets '
        'When one is selected '
        'Then the descent continues (FR-CH-04)', (tester) async {
      final fake = DrillableAggregations();

      await pumpInsight(tester, fake);

      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('chart.bucket.A Market')));
      await tester.pumpAndSettle();

      expect(fake.drills, hasLength(2));
      expect(fake.drills.last['key'], 'cp1');
      // Every level was requested; none was produced by subdividing a total
      // this client already held.
      expect(fake.drills.map((d) => d['key']), ['cat1', 'cp1']);
    });
  });

  group('DrillStep', () {
    test('Given two steps for the same element '
        'When they are compared '
        'Then they are equal', () {
      expect(
        const DrillStep(label: 'A', key: 'k', dimension: 'category'),
        const DrillStep(label: 'A', key: 'k', dimension: 'category'),
      );
      expect(
        const DrillStep(label: 'A', key: 'k', dimension: 'category'),
        isNot(const DrillStep(label: 'A', key: 'k2', dimension: 'category')),
      );
    });
  });

  group('Figures at a drilled level', () {
    testWidgets('Given a drilled level '
        'When its totals are shown '
        "Then they carry the chart's display currency (BR-07)", (tester) async {
      final fake = DrillableAggregations(
        onDrill: (_) => Success(
          DrillBuckets(
            dimension: 'counterparty',
            buckets: [
              AggregationBucket(
                label: 'A Market',
                total: Money.parse('320.00', 'BRL'),
                share: Decimal.parse('0.6'),
                isFullyConverted: true,
                unconverted: const [],
                drillDownKey: 'cp1',
              ),
            ],
          ),
        ),
      );

      await pumpInsight(tester, fake);
      await tester.tap(find.byKey(const Key('chart.bucket.Groceries')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chart.total.A Market')), findsOneWidget);
      expect(find.textContaining('320.00'), findsOneWidget);
    });
  });
}

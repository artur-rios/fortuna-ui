import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/insight/data/aggregation_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> bucketOutput({
  String? label = 'Groceries',
  String? total = '1250.50',
  String? share = '0.4',
  bool? isFullyConverted = true,
  String? drillDownKey = 'category:c1',
  List<Map<String, Object?>>? conversions,
}) => {
  'label': ?label,
  'total': ?total,
  'share': ?share,
  'isFullyConverted': ?isFullyConverted,
  'drillDownKey': ?drillDownKey,
  'conversions': ?conversions,
};

Map<String, Object?> transactionOutput(String id) => {
  'id': id,
  'occurredOn': '2026-03-05T00:00:00.000',
  'amount': '42.10',
  'currencyCode': 'BRL',
  'direction': 1,
  'categoryId': 'c1',
};

HttpAggregationRepository repositoryOn(ApiStub stub) =>
    HttpAggregationRepository.fromDio(stub.dio);

void main() {
  final from = DateTime(2026);
  final to = DateTime(2026, 3, 31);

  group('HttpAggregationRepository.aggregate', () {
    test('Given every filter the user set '
        'When an aggregation is asked for '
        'Then each travels to the API as a query parameter', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub).aggregate(
        grouping: Grouping.category,
        from: from,
        to: to,
        granularity: Granularity.monthly,
        displayCurrencyCode: 'BRL',
        direction: Direction.expense,
        financialAccountId: 'a1',
        categoryId: 'c1',
        counterpartyId: 'p1',
      );

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/reports/aggregate');
      final query = stub.request.queryParameters;
      expect(query['Dimension'], 'category');
      expect(query['Granularity'], 'monthly');
      expect(query['From'], '2026-01-01T00:00:00.000');
      expect(query['To'], '2026-03-31T00:00:00.000');
      expect(query['RollupCategories'], isTrue);
      expect(query['DisplayCurrencyCode'], 'BRL');
      expect('${query['Direction']}', '1');
      expect(query['FinancialAccountId'], 'a1');
      expect(query['CategoryId'], 'c1');
      expect(query['CounterpartyId'], 'p1');
    });

    test('Given no optional filter '
        'When an aggregation is asked for '
        'Then only the grouping, the period and the roll-up are sent '
        '(UC-36 AF-05)', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub)
          .aggregate(grouping: Grouping.period, from: from, to: to);

      expect(stub.request.queryParameters, {
        'Dimension': 'period',
        'From': '2026-01-01T00:00:00.000',
        'To': '2026-03-31T00:00:00.000',
        'RollupCategories': true,
      });
    });

    test('Given the user asked for every element on its own '
        'When an aggregation is asked for '
        'Then the API is told not to roll the smallest up', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub).aggregate(
        grouping: Grouping.counterparty,
        from: from,
        to: to,
        direction: Direction.earning,
        rollUpSmallest: false,
      );

      expect(stub.request.queryParameters['RollupCategories'], isFalse);
      expect('${stub.request.queryParameters['Direction']}', '2');
    });

    test(
      'Given an aggregation the API produced '
      'When it is read '
      "Then every figure is the API's own, in the display currency",
      () async {
        final stub = ApiStub.data({
          'displayCurrencyCode': 'BRL',
          'from': '2026-01-02T00:00:00.000',
          'to': '2026-03-30T00:00:00.000',
          'isFullyConverted': true,
          'buckets': [
            {
              ...bucketOutput(),
              'periodStart': '2026-01-01T00:00:00.000',
              'periodEnd': '2026-01-31T00:00:00.000',
            },
          ],
        });

        final result = await repositoryOn(stub)
            .aggregate(grouping: Grouping.category, from: from, to: to);

        final aggregation = result.valueOrNull!;
        expect(aggregation.grouping, Grouping.category);
        expect(aggregation.from, DateTime(2026, 1, 2));
        expect(aggregation.to, DateTime(2026, 3, 30));
        expect(aggregation.isFullyConverted, isTrue);
        expect(aggregation.displayCurrencyCode, 'BRL');
        expect(aggregation.spansCurrencies, isFalse);
        final bucket = aggregation.buckets.single;
        expect(bucket.label, 'Groceries');
        expect(bucket.total, Money.parse('1250.50', 'BRL'));
        expect(bucket.share, Decimal.parse('0.4'));
        expect(bucket.sharePermille, 400);
        expect(bucket.isFullyConverted, isTrue);
        expect(bucket.drillDownKey, 'category:c1');
        expect(bucket.canDrillDown, isTrue);
        expect(bucket.periodStart, DateTime(2026));
        expect(bucket.periodEnd, DateTime(2026, 1, 31));
        expect(bucket.unconverted, isEmpty);
      },
    );

    test(
      'Given amounts the API could not convert '
      'When the aggregation is read '
      'Then only those are listed, each in its own currency (UC-36 AF-03)',
      () async {
        final stub = ApiStub.data({
          'displayCurrencyCode': 'BRL',
          'isFullyConverted': false,
          'buckets': [
            bucketOutput(
              isFullyConverted: false,
              conversions: [
                {
                  'sourceAmount': '100.00',
                  'sourceCurrencyCode': 'USD',
                  'displayAmount': '520.00',
                },
                {
                  'sourceAmount': '30.25',
                  'sourceCurrencyCode': 'JPY',
                  'unconvertedReason': 'No rate for JPY on that date.',
                },
                <String, Object?>{},
              ],
            ),
          ],
        });

        final aggregation = (await repositoryOn(stub).aggregate(
          grouping: Grouping.category,
          from: from,
          to: to,
        )).valueOrNull!;

        expect(aggregation.isFullyConverted, isFalse);
        expect(aggregation.spansCurrencies, isTrue);
        final bucket = aggregation.buckets.single;
        expect(bucket.isFullyConverted, isFalse);
        expect(bucket.unconverted, hasLength(2));
        expect(bucket.unconverted.first.amount, Money.parse('30.25', 'JPY'));
        expect(
          bucket.unconverted.first.reason,
          'No rate for JPY on that date.',
        );
        expect(bucket.unconverted.last.amount, Money.parse('0', ''));
        expect(bucket.unconverted.last.reason, isNull);
      },
    );

    test('Given an aggregation with no display currency '
        'When it is read '
        'Then a bucket carries no total rather than a bare number '
        '(BR-07)', () async {
      final stub = ApiStub.data({
        'buckets': [bucketOutput()],
      });

      final aggregation = (await repositoryOn(
        stub,
      ).aggregate(grouping: Grouping.account, from: from, to: to)).valueOrNull!;

      expect(aggregation.displayCurrencyCode, isNull);
      expect(aggregation.buckets.single.total, isNull);
    });

    test('Given an aggregation with every optional field missing '
        'When it is read '
        'Then the requested period stands and nothing is invented', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final aggregation = (await repositoryOn(
        stub,
      ).aggregate(grouping: Grouping.period, from: from, to: to)).valueOrNull!;

      expect(aggregation.from, from);
      expect(aggregation.to, to);
      expect(aggregation.isFullyConverted, isTrue);
      expect(aggregation.displayCurrencyCode, isNull);
      expect(aggregation.buckets, isEmpty);
      expect(aggregation.isEmpty, isTrue);
    });

    test('Given a bucket with every optional field missing '
        'When the aggregation is read '
        'Then its gaps read as empty rather than failing', () async {
      final stub = ApiStub.data({
        'displayCurrencyCode': 'BRL',
        'buckets': [<String, Object?>{}],
      });

      final bucket = (await repositoryOn(stub).aggregate(
        grouping: Grouping.category,
        from: from,
        to: to,
      )).valueOrNull!.buckets.single;

      expect(bucket.label, '');
      expect(bucket.total, isNull);
      expect(bucket.share, isNull);
      expect(bucket.sharePermille, isNull);
      expect(bucket.isFullyConverted, isTrue);
      expect(bucket.drillDownKey, isNull);
      expect(bucket.canDrillDown, isFalse);
      expect(bucket.periodStart, isNull);
      expect(bucket.periodEnd, isNull);
      expect(bucket.unconverted, isEmpty);
    });

    test('Given a bucket whose share is not a decimal '
        'When the aggregation is read '
        'Then the share is absent rather than guessed', () async {
      final stub = ApiStub.data({
        'buckets': [bucketOutput(share: 'forty percent')],
      });

      final bucket = (await repositoryOn(stub).aggregate(
        grouping: Grouping.category,
        from: from,
        to: to,
      )).valueOrNull!.buckets.single;

      expect(bucket.share, isNull);
    });

    test('Given an answer with no data '
        'When an aggregation is asked for '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub)
          .aggregate(grouping: Grouping.category, from: from, to: to);

      expect(
        result,
        const Failure<Aggregation>(
          message: 'The instance returned no aggregation.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given the API refuses the aggregation '
        'When it is asked for '
        "Then the API's reason is the failure (UC-36 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The period must end after it starts.']),
      );

      final result = await repositoryOn(stub)
          .aggregate(grouping: Grouping.category, from: to, to: from);

      expect(
        result,
        const Failure<Aggregation>(
          message: 'The period must end after it starts.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When an aggregation is asked for '
        'Then it is a failure saying so (UC-36 AF-02)', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub)
          .aggregate(grouping: Grouping.category, from: from, to: to);

      expect(
        result,
        const Failure<Aggregation>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpAggregationRepository.drillDown', () {
    test('Given a key and a dimension '
        'When the level beneath is asked for '
        'Then both travel with the page asked for', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub).drillDown(
        key: 'category:c1',
        dimension: 'counterparty',
        pageNumber: 2,
        pageSize: 10,
      );

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/reports/drill-down');
      expect(stub.request.queryParameters, {
        'Key': 'category:c1',
        'Dimension': 'counterparty',
        'PageNumber': 2,
        'PageSize': 10,
      });
    });

    test(
      'Given only a key '
      'When the level beneath is asked for '
      'Then the first page of fifty is asked for, with no dimension',
      () async {
        final stub = ApiStub.data(<String, Object?>{});

        await repositoryOn(stub).drillDown(key: 'category:c1');

        expect(stub.request.queryParameters, {
          'Key': 'category:c1',
          'PageNumber': 1,
          'PageSize': 50,
        });
      },
    );

    test(
      'Given the finest level '
      'When it is read '
      "Then it is the transactions themselves, with the API's warning",
      () async {
        final stub = ApiStub.data({
          'transactions': [transactionOutput('t1'), transactionOutput('t2')],
          'totalItems': 120,
          'mayDifferFromChart': true,
        });

        final result = await repositoryOn(stub)
            .drillDown(key: 'category:c1', displayCurrencyCode: 'BRL');

        final level = result.valueOrNull! as DrillTransactions;
        expect(level.transactions.map((t) => t.id), ['t1', 't2']);
        expect(level.transactions.first.amount, Money.parse('42.10', 'BRL'));
        expect(level.totalItems, 120);
        expect(level.mayDifferFromChart, isTrue);
        expect(level.isEmpty, isFalse);
      },
    );

    test(
      'Given the finest level with no count and no warning '
      'When it is read '
      'Then the count is the rows sent and no difference is claimed',
      () async {
        final stub = ApiStub.data({
          'transactions': [transactionOutput('t1')],
        });

        final level =
            (await repositoryOn(stub).drillDown(key: 'k')).valueOrNull!
                as DrillTransactions;

        expect(level.totalItems, 1);
        expect(level.mayDifferFromChart, isFalse);
      },
    );

    test('Given the finest level with no transactions in it '
        'When it is read '
        'Then it is still the finest level, and empty', () async {
      final stub = ApiStub.data({
        'transactions': <Object?>[],
        'buckets': [bucketOutput()],
      });

      final level = (await repositoryOn(stub).drillDown(key: 'k')).valueOrNull;

      expect(level, isA<DrillTransactions>());
      final transactions = level! as DrillTransactions;
      expect(transactions.isEmpty, isTrue);
      expect(transactions.totalItems, 0);
    });

    test('Given a level the API breaks down further '
        'When it is read '
        "Then its buckets carry the chart's display currency down", () async {
      final stub = ApiStub.data({
        'dimension': 'counterparty',
        'buckets': [
          bucketOutput(label: 'Market', drillDownKey: 'counterparty:p1'),
        ],
      });

      final level =
          (await repositoryOn(stub).drillDown(
                key: 'category:c1',
                displayCurrencyCode: 'BRL',
              )).valueOrNull!
              as DrillBuckets;

      expect(level.dimension, 'counterparty');
      final bucket = level.buckets.single;
      expect(bucket.label, 'Market');
      expect(bucket.total, Money.parse('1250.50', 'BRL'));
      expect(bucket.drillDownKey, 'counterparty:p1');
      expect(level.isEmpty, isFalse);
    });

    test(
      'Given a chart with no display currency '
      'When a level beneath it is read '
      'Then its totals stay absent rather than bare numbers (BR-07)',
      () async {
        final stub = ApiStub.data({
          'buckets': [bucketOutput()],
        });

        final level =
            (await repositoryOn(stub).drillDown(key: 'k')).valueOrNull!
                as DrillBuckets;

        expect(level.buckets.single.total, isNull);
      },
    );

    test(
      'Given a level with neither transactions nor buckets '
      'When it is read '
      'Then it is an empty grouping with the path intact (UC-37 AF-03)',
      () async {
        final stub = ApiStub.data(<String, Object?>{});

        final level = (await repositoryOn(stub).drillDown(key: 'k'))
            .valueOrNull;

        expect(level, isA<DrillBuckets>());
        final buckets = level! as DrillBuckets;
        expect(buckets.dimension, '');
        expect(buckets.buckets, isEmpty);
        expect(buckets.isEmpty, isTrue);
      },
    );

    test('Given an answer with no data '
        'When a level is asked for '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub).drillDown(key: 'k');

      expect(
        result,
        const Failure<DrillLevel>(
          message: 'The instance returned no breakdown.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given a key the API does not know '
        'When the level beneath is asked for '
        "Then the API's reason is the failure (UC-37 AF-02)", () async {
      final stub = ApiStub((_) => refusal(404, ['Unknown drill-down key.']));

      final result = await repositoryOn(stub).drillDown(key: 'k');

      expect(
        result,
        const Failure<DrillLevel>(
          message: 'Unknown drill-down key.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a level is asked for '
        'Then it is a failure saying so (UC-37 AF-02)', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).drillDown(key: 'k');

      expect(
        result,
        const Failure<DrillLevel>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}

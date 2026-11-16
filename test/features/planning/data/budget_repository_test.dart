import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/planning/data/budget_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> budgetOutput({
  Object? periodType = 2,
  Map<String, Object?>? currentPeriod,
}) => {
  'id': 'b1',
  'amount': '800.00',
  'currencyCode': 'BRL',
  'periodType': ?periodType,
  'periodStart': '2026-01-01T00:00:00.000',
  'categories': [
    {'id': 'k1', 'name': 'Food'},
    {'id': 'k2', 'name': 'Restaurants'},
  ],
  'includeDescendants': true,
  'currentPeriod': ?currentPeriod,
};

void main() {
  group('HttpBudgetRepository.list', () {
    test('Given a budget with its consumption '
        'When the budgets are listed '
        "Then it is mapped with the API's own figures and verdict "
        '(UC-28 main flow)', () async {
      final stub = ApiStub.data({
        'budgets': [
          budgetOutput(
            currentPeriod: {
              'periodStart': '2026-01-01T00:00:00.000',
              'periodEnd': '2026-03-31T00:00:00.000',
              'spent': '900.10',
              'remaining': '0.00',
              'overage': '100.10',
              'isExceeded': true,
            },
          ),
        ],
      });

      final result = await HttpBudgetRepository.fromDio(stub.dio).list();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/budgets');
      expect(stub.request.queryParameters, {
        'includeDeleted': false,
        'pageNumber': 1,
        'pageSize': 100,
      });
      final budget = result.valueOrNull!.single;
      expect(budget.id, 'b1');
      expect(budget.amount, Money.parse('800.00', 'BRL'));
      expect(budget.period, BudgetPeriod.quarterly);
      expect(budget.periodStart, DateTime(2026));
      expect(budget.categoryNames, ['Food', 'Restaurants']);
      expect(budget.includeDescendants, isTrue);
      final consumption = budget.consumption!;
      expect(consumption.periodStart, DateTime(2026));
      expect(consumption.periodEnd, DateTime(2026, 3, 31));
      expect(consumption.spent, Money.parse('900.10', 'BRL'));
      expect(consumption.remaining, Money.parse('0', 'BRL'));
      expect(consumption.overage, Money.parse('100.10', 'BRL'));
      expect(consumption.isExceeded, isTrue);
      expect(budget.isExceeded, isTrue);
      expect(budget.hasNoConsumption, isFalse);
    });

    test(
      'Given a period the API could not compute figures for '
      'When it is listed '
      'Then each figure stays absent rather than zero (UC-28 AF-04)',
      () async {
        final stub = ApiStub.data({
          'budgets': [
            budgetOutput(currentPeriod: {'isExceeded': null}),
          ],
        });

        final budget = (await HttpBudgetRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!.single;

        final consumption = budget.consumption!;
        expect(consumption.periodStart, DateTime(1970));
        expect(consumption.periodEnd, DateTime(1970));
        expect(consumption.spent, isNull);
        expect(consumption.remaining, isNull);
        expect(consumption.overage, isNull);
        expect(consumption.isExceeded, isNull);
        expect(consumption.isUnavailable, isTrue);
        expect(budget.hasNoConsumption, isTrue);
        expect(budget.isExceeded, isFalse);
      },
    );

    test('Given a budget the API sent no period for '
        'When it is listed '
        'Then it has no consumption at all (UC-28 AF-04)', () async {
      final stub = ApiStub.data({
        'budgets': [budgetOutput()],
      });

      final budget = (await HttpBudgetRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(budget.consumption, isNull);
      expect(budget.hasNoConsumption, isTrue);
      expect(budget.isExceeded, isFalse);
    });

    test('Given budgets of every period the contract numbers '
        'When they are listed '
        'Then each number maps to its period and anything else reads as '
        'monthly', () async {
      final stub = ApiStub.data({
        'budgets': [
          for (final type in [1, 2, 3, 99, null])
            budgetOutput(periodType: type),
        ],
      });

      final result = await HttpBudgetRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull!.map((budget) => budget.period), [
        BudgetPeriod.monthly,
        BudgetPeriod.quarterly,
        BudgetPeriod.yearly,
        BudgetPeriod.monthly,
        BudgetPeriod.monthly,
      ]);
    });

    test('Given a budget with every optional field missing '
        'When it is listed '
        'Then the gaps read as empty, a zero ceiling and the epoch', () async {
      final stub = ApiStub.data({
        'budgets': [
          <String, Object?>{
            'categories': [<String, Object?>{}],
          },
        ],
      });

      final budget = (await HttpBudgetRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(budget.id, '');
      expect(budget.amount, Money.zero(''));
      expect(budget.period, BudgetPeriod.monthly);
      expect(budget.periodStart, DateTime(1970));
      expect(budget.categoryNames, ['']);
      expect(budget.includeDescendants, isFalse);
      expect(budget.consumption, isNull);
    });

    test('Given a budget the API sent no categories for '
        'When it is listed '
        'Then it names none', () async {
      final stub = ApiStub.data({
        'budgets': [<String, Object?>{}],
      });

      final budget = (await HttpBudgetRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(budget.categoryNames, isEmpty);
    });

    test('Given an answer with no data '
        'When the budgets are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpBudgetRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given an answer with no budget list in its data '
        'When the budgets are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final result = await HttpBudgetRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given an instance that cannot be reached '
        'When the budgets are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpBudgetRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Budget>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpBudgetRepository.read', () {
    test(
      'Given a budget that exists '
      'When it is read '
      'Then it is fetched by its id, live records only, and mapped',
      () async {
        final stub = ApiStub.data(budgetOutput(periodType: 3));

        final result = await HttpBudgetRepository.fromDio(stub.dio).read('b1');

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/budgets/b1');
        expect(stub.request.queryParameters, {'includeDeleted': false});
        expect(result.valueOrNull!.amount, Money.parse('800', 'BRL'));
        expect(result.valueOrNull!.period, BudgetPeriod.yearly);
      },
    );

    test('Given an answer with no data '
        'When a budget is read '
        'Then it is not found (UC-28 AF-05)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpBudgetRepository.fromDio(stub.dio).read('b1');

      expect(
        result,
        const Failure<Budget>(
          message: 'That budget was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When a budget is read '
        "Then the API's reason is the failure (UC-28 AF-05)", () async {
      final stub = ApiStub((_) => refusal(404, ['Budget not found.']));

      final result = await HttpBudgetRepository.fromDio(stub.dio).read('b1');

      expect(
        result,
        const Failure<Budget>(
          message: 'Budget not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpBudgetRepository.create', () {
    test(
      'Given a monthly budget left at its defaults '
      'When it is created '
      'Then the amount is sent as typed and descendants are left out',
      () async {
        final stub = ApiStub.data({'id': 'b1'}, status: 201);

        final result = await HttpBudgetRepository.fromDio(stub.dio).create(
          categoryIds: ['k1'],
          amount: '800.00',
          currencyCode: 'BRL',
          period: BudgetPeriod.monthly,
          periodStart: DateTime(2026, 3),
        );

        expect(result, const Success<void>(null));
        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/budgets');
        expect(stub.body, {
          'amount': '800.00',
          'categoryIds': ['k1'],
          'currencyCode': 'BRL',
          'includeDescendants': false,
          'periodStart': '2026-03-01T00:00:00.000',
          'periodType': 1,
        });
      },
    );

    test(
      'Given budgets of each period that include descendants '
      'When they are created '
      'Then each period travels as the number the contract gives it',
      () async {
        final stub = ApiStub.data({'id': 'b1'}, status: 201);
        final repository = HttpBudgetRepository.fromDio(stub.dio);

        for (final period in BudgetPeriod.values) {
          await repository.create(
            categoryIds: ['k1', 'k2'],
            amount: '800',
            currencyCode: 'BRL',
            period: period,
            periodStart: DateTime(2026),
            includeDescendants: true,
          );
        }

        final bodies = [
          for (final request in stub.requests)
            request.data as Map<String, Object?>,
        ];
        expect(bodies.map((body) => body['periodType']), [1, 2, 3]);
        expect(bodies.map((body) => body['includeDescendants']), [
          true,
          true,
          true,
        ]);
        expect(bodies.first['categoryIds'], ['k1', 'k2']);
      },
    );

    test('Given a budget already covering that category and period '
        'When another is created '
        "Then the API's refusal is the failure (UC-28 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A budget already covers that period.']),
      );

      final result = await HttpBudgetRepository.fromDio(stub.dio).create(
        categoryIds: ['k1'],
        amount: '800.00',
        currencyCode: 'BRL',
        period: BudgetPeriod.monthly,
        periodStart: DateTime(2026, 3),
      );

      expect(
        result,
        const Failure<void>(
          message: 'A budget already covers that period.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('HttpBudgetRepository.update', () {
    test('Given an edited budget '
        'When it is saved '
        'Then it is put to its own address with every field', () async {
      final stub = ApiStub.data({'id': 'b1'});

      final result = await HttpBudgetRepository.fromDio(stub.dio).update(
        id: 'b1',
        categoryIds: ['k1', 'k3'],
        amount: '1200.50',
        currencyCode: 'BRL',
        period: BudgetPeriod.yearly,
        periodStart: DateTime(2026),
        includeDescendants: true,
      );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/budgets/b1');
      expect(stub.body, {
        'amount': '1200.50',
        'categoryIds': ['k1', 'k3'],
        'currencyCode': 'BRL',
        'includeDescendants': true,
        'periodStart': '2026-01-01T00:00:00.000',
        'periodType': 3,
      });
    });

    test('Given an edit left at the default for descendants '
        'When it is saved '
        'Then descendants are sent as left out', () async {
      final stub = ApiStub.data({'id': 'b1'});

      await HttpBudgetRepository.fromDio(stub.dio).update(
        id: 'b1',
        categoryIds: ['k1'],
        amount: '800',
        currencyCode: 'BRL',
        period: BudgetPeriod.quarterly,
        periodStart: DateTime(2026),
      );

      final body = stub.body! as Map<String, Object?>;
      expect(body['includeDescendants'], isFalse);
      expect(body['periodType'], 2);
    });

    test('Given the API refuses the edit '
        'When it is saved '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The amount must be positive.']),
      );

      final result = await HttpBudgetRepository.fromDio(stub.dio).update(
        id: 'b1',
        categoryIds: ['k1'],
        amount: '0',
        currencyCode: 'BRL',
        period: BudgetPeriod.monthly,
        periodStart: DateTime(2026),
      );

      expect(
        result,
        const Failure<void>(
          message: 'The amount must be positive.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('HttpBudgetRepository.delete', () {
    test('Given a budget '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 'b1'});

      final result = await HttpBudgetRepository.fromDio(stub.dio).delete('b1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/budgets/b1');
    });

    test('Given the API answers 404 '
        'When a budget is deleted '
        "Then the API's reason is the failure (UC-28 AF-05)", () async {
      final stub = ApiStub((_) => refusal(404, ['Budget not found.']));

      final result = await HttpBudgetRepository.fromDio(stub.dio).delete('b1');

      expect(
        result,
        const Failure<void>(
          message: 'Budget not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a budget is deleted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpBudgetRepository.fromDio(stub.dio).delete('b1');

      expect(
        result,
        const Failure<void>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}

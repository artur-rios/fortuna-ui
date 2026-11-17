import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/holdings/data/investment_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> investmentOutput({
  Object? investmentType = 1,
  Object? valuation,
  Object? valuationDate,
}) => {
  'id': 'i1',
  'instrument': 'Treasury 2030',
  'currencyCode': 'BRL',
  'investmentType': ?investmentType,
  'position': '10250.75',
  'isIndependentlyValued': true,
  'institution': 'Neo Broker',
  'latestValuationValue': ?valuation,
  'latestValuationDate': ?valuationDate,
};

void main() {
  group('HttpInvestmentRepository.list', () {
    test('Given more investments than one page holds '
        'When they are listed '
        'Then every page is read and the list is whole (UC-17)', () async {
      final stub = ApiStub((request) {
        final page = requestedPage(request);
        return paginated(
          [
            {...investmentOutput(), 'id': 'p$page'},
          ],
          pageNumber: page,
          totalPages: 2,
        );
      });

      final result = await HttpInvestmentRepository.fromDio(stub.dio).list();

      expect(
        [
          for (final request in stub.requests)
            request.queryParameters['PageNumber'],
        ],
        [1, 2],
      );
      expect([for (final item in result.valueOrNull!) item.id], ['p1', 'p2']);
    });

    test(
      'Given an investment with a recorded valuation '
      'When the investments are listed '
      "Then the position and valuation are the API's own (UC-17 main flow)",
      () async {
        final stub = ApiStub.data([
          investmentOutput(
            valuation: '10400.00',
            valuationDate: '2026-02-28T00:00:00.000',
          ),
        ]);

        final result = await HttpInvestmentRepository.fromDio(stub.dio).list();

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/investments');
        expect(stub.request.queryParameters, {
          'PageNumber': 1,
          'PageSize': 100,
        });
        final investment = result.valueOrNull!.single;
        expect(investment.id, 'i1');
        expect(investment.instrument, 'Treasury 2030');
        expect(investment.currencyCode, 'BRL');
        expect(investment.type, InvestmentType.fixedIncome);
        expect(investment.position, Money.parse('10250.75', 'BRL'));
        expect(investment.isIndependentlyValued, isTrue);
        expect(investment.institution, 'Neo Broker');
        expect(
          investment.latestValuation!.value,
          Money.parse('10400.00', 'BRL'),
        );
        expect(investment.latestValuation!.asOf, DateTime(2026, 2, 28));
        expect(investment.hasNoValuation, isFalse);
      },
    );

    test(
      'Given an investment nobody valued '
      'When it is listed '
      'Then its valuation stays absent rather than zero (UC-17 AF-05)',
      () async {
        final stub = ApiStub.data([investmentOutput()]);

        final investment = (await HttpInvestmentRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!.single;

        expect(investment.latestValuation, isNull);
        expect(investment.hasNoValuation, isTrue);
      },
    );

    test('Given a valuation the API sent without its date '
        'When it is listed '
        'Then the value is kept and its date stays absent', () async {
      final stub = ApiStub.data([investmentOutput(valuation: '0')]);

      final investment = (await HttpInvestmentRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(investment.latestValuation!.value, Money.zero('BRL'));
      expect(investment.latestValuation!.asOf, isNull);
      expect(investment.hasNoValuation, isFalse);
    });

    test(
      'Given investments of every type the contract numbers '
      'When they are listed '
      'Then each number maps to its type and anything else reads as other',
      () async {
        final stub = ApiStub.data([
          for (final type in [1, 2, 3, 4, 99, null])
            investmentOutput(investmentType: type),
        ]);

        final result = await HttpInvestmentRepository.fromDio(stub.dio).list();

        expect(result.valueOrNull!.map((investment) => investment.type), [
          InvestmentType.fixedIncome,
          InvestmentType.equity,
          InvestmentType.fund,
          InvestmentType.other,
          InvestmentType.other,
          InvestmentType.other,
        ]);
      },
    );

    test(
      'Given an investment with every optional field missing '
      'When it is listed '
      'Then the gaps read as empty, a zero position and no valuation',
      () async {
        final stub = ApiStub.data([<String, Object?>{}]);

        final investment = (await HttpInvestmentRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!.single;

        expect(investment.id, '');
        expect(investment.instrument, '');
        expect(investment.currencyCode, '');
        expect(investment.type, InvestmentType.other);
        expect(investment.position, Money.zero(''));
        expect(investment.isIndependentlyValued, isFalse);
        expect(investment.institution, isNull);
        expect(investment.latestValuation, isNull);
      },
    );

    test('Given an answer with no data '
        'When the investments are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpInvestmentRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given an instance that cannot be reached '
        'When the investments are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpInvestmentRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Investment>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpInvestmentRepository.read', () {
    test('Given an investment that exists '
        'When it is read '
        'Then it is fetched by its id and mapped', () async {
      final stub = ApiStub.data(investmentOutput(investmentType: 2));

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .read('i1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/investments/i1');
      expect(stub.request.queryParameters, isEmpty);
      expect(result.valueOrNull!.instrument, 'Treasury 2030');
      expect(result.valueOrNull!.type, InvestmentType.equity);
    });

    test('Given an answer with no data '
        'When an investment is read '
        'Then it is not found (UC-17 AF-03)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .read('i1');

      expect(
        result,
        const Failure<Investment>(
          message: 'That investment was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When an investment is read '
        "Then the API's reason is the failure (UC-17 AF-03)", () async {
      final stub = ApiStub((_) => refusal(404, ['Investment not found.']));

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .read('i1');

      expect(
        result,
        const Failure<Investment>(
          message: 'Investment not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpInvestmentRepository.create', () {
    test('Given a new investment without an institution '
        'When it is created '
        'Then it is posted with the type as its number', () async {
      final stub = ApiStub.data({'id': 'i1'}, status: 201);

      final result = await HttpInvestmentRepository.fromDio(stub.dio).create(
        instrument: 'Index fund',
        currencyCode: 'BRL',
        type: InvestmentType.fund,
      );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/investments');
      expect(stub.body, {
        'currencyCode': 'BRL',
        'instrument': 'Index fund',
        'investmentType': 3,
      });
    });

    test('Given investments of each type '
        'When they are created '
        'Then each type travels as the number the contract gives it', () async {
      final stub = ApiStub.data({'id': 'i1'}, status: 201);
      final repository = HttpInvestmentRepository.fromDio(stub.dio);

      for (final type in InvestmentType.values) {
        await repository.create(
          instrument: 'Holding',
          currencyCode: 'BRL',
          type: type,
          institution: 'Neo Broker',
        );
      }

      expect(
        stub.requests.map(
          (request) => (request.data as Map<String, Object?>)['investmentType'],
        ),
        [1, 2, 3, 4],
      );
      expect(
        (stub.requests.first.data as Map<String, Object?>)['institution'],
        'Neo Broker',
      );
    });

    test('Given the API refuses a duplicate name '
        'When an investment is created '
        "Then the API's reason is the failure (UC-17 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['An investment with that name already exists.']),
      );

      final result = await HttpInvestmentRepository.fromDio(stub.dio).create(
        instrument: 'Index fund',
        currencyCode: 'BRL',
        type: InvestmentType.fund,
      );

      expect(
        result,
        const Failure<void>(
          message: 'An investment with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('HttpInvestmentRepository.update', () {
    test('Given an investment whose institution was removed '
        'When it is saved '
        'Then the institution travels as null, which clears it offline as '
        'online', () async {
      final stub = ApiStub.data({'id': 'i1'});

      await HttpInvestmentRepository.fromDio(stub.dio)
          .update(id: 'i1', instrument: 'Stocks', type: InvestmentType.equity);

      expect(stub.body, containsPair('institution', null));
    });

    test('Given an edited investment '
        'When it is saved '
        'Then it is put to its own address without a currency', () async {
      final stub = ApiStub.data({'id': 'i1'});

      final result = await HttpInvestmentRepository.fromDio(stub.dio).update(
        id: 'i1',
        instrument: 'Stocks',
        type: InvestmentType.equity,
        institution: 'Neo Broker',
      );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/investments/i1');
      expect(stub.body, {
        'currencyCode': null,
        'institution': 'Neo Broker',
        'instrument': 'Stocks',
        'investmentType': 2,
      });
    });

    test('Given the API refuses the edit '
        'When it is saved '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The instrument is required.']),
      );

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .update(id: 'i1', instrument: '', type: InvestmentType.other);

      expect(
        result,
        const Failure<void>(
          message: 'The instrument is required.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('HttpInvestmentRepository.delete', () {
    test('Given an investment '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 'i1'});

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .delete('i1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/investments/i1');
    });

    test('Given movements still referencing the investment '
        'When it is deleted '
        "Then the API's reason is the failure (UC-17 AF-04)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['The investment still has movements.']),
      );

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .delete('i1');

      expect(
        result,
        const Failure<void>(
          message: 'The investment still has movements.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('HttpInvestmentRepository.valuations', () {
    test('Given more valuations than one page holds '
        'When they are listed '
        'Then every page is read and the list is whole (FR-HO-11)', () async {
      final stub = ApiStub((request) {
        final page = requestedPage(request);
        return paginated(
          [
            {'value': '${page}0', 'currencyCode': 'BRL'},
          ],
          pageNumber: page,
          totalPages: 2,
        );
      });

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .valuations('i1');

      expect(
        [
          for (final request in stub.requests)
            request.queryParameters['PageNumber'],
        ],
        [1, 2],
      );
      expect(
        [for (final item in result.valueOrNull!) item.value.amount.toString()],
        ['10', '20'],
      );
    });

    test('Given recorded valuations '
        'When they are listed '
        'Then they are asked for most recent first and mapped as sent '
        '(FR-HO-11)', () async {
      final stub = ApiStub.data([
        {
          'id': 'v2',
          'investmentId': 'i1',
          'value': '10400.00',
          'currencyCode': 'BRL',
          'valuedOn': '2026-02-28T00:00:00.000',
        },
        {
          'id': 'v1',
          'investmentId': 'i1',
          'value': '10100.50',
          'currencyCode': 'BRL',
          'valuedOn': '2026-01-31T00:00:00.000',
        },
      ]);

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .valuations('i1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/investments/i1/valuations');
      expect(stub.request.queryParameters, {
        'SortBy': 'valuedOn',
        'Descending': true,
        'PageNumber': 1,
        'PageSize': 100,
      });
      final valuations = result.valueOrNull!;
      expect(valuations.map((valuation) => valuation.value), [
        Money.parse('10400.00', 'BRL'),
        Money.parse('10100.50', 'BRL'),
      ]);
      expect(valuations.map((valuation) => valuation.asOf), [
        DateTime(2026, 2, 28),
        DateTime(2026, 1, 31),
      ]);
    });

    test('Given a valuation with every optional field missing '
        'When the valuations are listed '
        'Then it reads as zero with an empty currency and no date', () async {
      final stub = ApiStub.data([<String, Object?>{}]);

      final valuation = (await HttpInvestmentRepository.fromDio(
        stub.dio,
      ).valuations('i1')).valueOrNull!.single;

      expect(valuation.value, Money.zero(''));
      expect(valuation.asOf, isNull);
    });

    test('Given an answer with no data '
        'When the valuations are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .valuations('i1');

      expect(result.valueOrNull, isEmpty);
    });

    test('Given the API answers 404 '
        'When the valuations are listed '
        "Then the API's reason is the failure (UC-18 AF-04)", () async {
      final stub = ApiStub((_) => refusal(404, ['Investment not found.']));

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .valuations('i1');

      expect(
        result,
        const Failure<List<RecordedValuation>>(
          message: 'Investment not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpInvestmentRepository.recordMovement', () {
    test('Given a contribution from an account '
        'When it is recorded '
        'Then it is posted under the investment with the amount as typed '
        '(UC-18)', () async {
      final stub = ApiStub.data({'id': 'm1'}, status: 201);

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .recordMovement(
            investmentId: 'i1',
            type: MovementType.contribution,
            amount: '150.10',
            occurredOn: DateTime(2026, 3, 5),
            financialAccountId: 'a1',
          );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/investments/i1/movements');
      expect(stub.body, {
        'amount': '150.10',
        'financialAccountId': 'a1',
        'id': 'i1',
        'movementType': 1,
        'occurredOn': '2026-03-05',
      });
    });

    test('Given movements of each type and none drawn from an account '
        'When they are recorded '
        'Then each type travels as the number the contract gives it', () async {
      final stub = ApiStub.data({'id': 'm1'}, status: 201);
      final repository = HttpInvestmentRepository.fromDio(stub.dio);

      for (final type in MovementType.values) {
        await repository.recordMovement(
          investmentId: 'i1',
          type: type,
          amount: '1',
          occurredOn: DateTime(2026, 3, 5),
        );
      }

      final bodies = [
        for (final request in stub.requests)
          request.data as Map<String, Object?>,
      ];
      expect(bodies.map((body) => body['movementType']), [1, 2, 3, 4]);
      expect(bodies.map((body) => body['financialAccountId']), [
        null,
        null,
        null,
        null,
      ]);
    });

    test('Given the API refuses an account in another currency '
        'When a movement is recorded '
        "Then the API's reason is the failure, nothing converted "
        '(UC-18 AF-05)', () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The account currency does not match.']),
      );

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .recordMovement(
            investmentId: 'i1',
            type: MovementType.withdrawal,
            amount: '150.10',
            occurredOn: DateTime(2026, 3, 5),
            financialAccountId: 'a2',
          );

      expect(
        result,
        const Failure<void>(
          message: 'The account currency does not match.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a movement is recorded '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .recordMovement(
            investmentId: 'i1',
            type: MovementType.fee,
            amount: '2',
            occurredOn: DateTime(2026, 3, 5),
          );

      expect(
        result,
        const Failure<void>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpInvestmentRepository.recordValuation', () {
    test('Given a valuation '
        'When it is recorded '
        'Then it is posted under the investment with the value as typed '
        '(UC-18)', () async {
      final stub = ApiStub.data({'id': 'v1'}, status: 201);

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .recordValuation(
            investmentId: 'i1',
            value: '10400.00',
            valuedOn: DateTime(2026, 2, 28),
          );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/investments/i1/valuations');
      expect(stub.body, {
        'id': 'i1',
        'value': '10400.00',
        'valuedOn': '2026-02-28',
      });
    });

    test('Given the API refuses a second valuation on one date '
        'When it is recorded '
        "Then the API's reason is the failure (UC-18 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A valuation already exists on that date.']),
      );

      final result = await HttpInvestmentRepository.fromDio(stub.dio)
          .recordValuation(
            investmentId: 'i1',
            value: '10400.00',
            valuedOn: DateTime(2026, 2, 28),
          );

      expect(
        result,
        const Failure<void>(
          message: 'A valuation already exists on that date.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });
}

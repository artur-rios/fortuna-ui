import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/insight/data/projection_repository.dart';

import '../../../support/api_stub.dart';

HttpProjectionRepository repositoryOn(ApiStub stub) =>
    HttpProjectionRepository.fromDio(stub.dio);

/// Whether [actual] was read from the clock between [before] and [after]:
/// the fallback to "now", pinned without depending on what now is.
Matcher readBetween(DateTime before, DateTime after) => predicate<DateTime>(
  (actual) => !actual.isBefore(before) && !actual.isAfter(after),
  'a time between $before and $after',
);

void main() {
  group('HttpProjectionRepository.netPosition', () {
    test('Given a display currency '
        'When the net position is read '
        'Then it is asked for in that currency', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub).netPosition(displayCurrencyCode: 'BRL');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/reports/net-position');
      expect(stub.request.queryParameters, {'DisplayCurrencyCode': 'BRL'});
    });

    test('Given no display currency '
        'When the net position is read '
        'Then nothing is asked beyond the route', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub).netPosition();

      expect(stub.request.queryParameters, isEmpty);
    });

    test(
      'Given a net position the API worked out '
      'When it is read '
      "Then the total and every currency's four figures are the API's own",
      () async {
        final stub = ApiStub.data({
          'asOf': '2026-11-16T09:30:00.000',
          'displayCurrencyCode': 'BRL',
          'total': '15200.75',
          'isFullyConverted': true,
          'currencyGroups': [
            {
              'sourceCurrencyCode': 'BRL',
              'sourceNet': '12000.00',
              'financialAccounts': '9000.00',
              'creditCards': '-1500.00',
              'investments': '4500.00',
            },
            {
              'sourceCurrencyCode': 'USD',
              'sourceNet': '600.15',
              'financialAccounts': '600.15',
              'creditCards': '0',
              'investments': '0',
            },
          ],
        });

        final result = await repositoryOn(stub)
            .netPosition(displayCurrencyCode: 'BRL');

        final position = result.valueOrNull!;
        expect(position.asOf, DateTime(2026, 11, 16, 9, 30));
        expect(position.isFullyConverted, isTrue);
        expect(position.displayCurrencyCode, 'BRL');
        expect(position.total, Money.parse('15200.75', 'BRL'));
        expect(position.hasNoHoldings, isFalse);
        expect(position.spansCurrencies, isTrue);
        final brl = position.byCurrency.first;
        expect(brl.net, Money.parse('12000', 'BRL'));
        expect(brl.accounts, Money.parse('9000', 'BRL'));
        expect(brl.creditCards, Money.parse('-1500', 'BRL'));
        expect(brl.investments, Money.parse('4500', 'BRL'));
        expect(brl.unconvertedReason, isNull);
        expect(position.byCurrency.last.net, Money.parse('600.15', 'USD'));
        expect(position.byCurrency.last.net.isProjected, isFalse);
      },
    );

    test('Given a currency the API could not convert '
        'When the net position is read '
        "Then it stays in its own currency with the API's reason "
        '(UC-38 AF-03)', () async {
      final stub = ApiStub.data({
        'displayCurrencyCode': 'BRL',
        'isFullyConverted': false,
        'currencyGroups': [
          {
            'sourceCurrencyCode': 'JPY',
            'sourceNet': '30000',
            'unconvertedReason': 'No rate for JPY today.',
          },
        ],
      });

      final position = (await repositoryOn(
        stub,
      ).netPosition(displayCurrencyCode: 'BRL')).valueOrNull!;

      expect(position.isFullyConverted, isFalse);
      expect(position.spansCurrencies, isTrue);
      expect(position.total, isNull);
      final jpy = position.byCurrency.single;
      expect(jpy.net, Money.parse('30000', 'JPY'));
      expect(jpy.accounts, Money.parse('0', 'JPY'));
      expect(jpy.creditCards, Money.parse('0', 'JPY'));
      expect(jpy.investments, Money.parse('0', 'JPY'));
      expect(jpy.unconvertedReason, 'No rate for JPY today.');
    });

    test('Given a total with no display currency '
        'When the net position is read '
        'Then there is no total rather than a bare number (BR-07)', () async {
      final stub = ApiStub.data({'total': '15200.75'});

      final position = (await repositoryOn(stub).netPosition()).valueOrNull!;

      expect(position.total, isNull);
      expect(position.displayCurrencyCode, isNull);
    });

    test(
      'Given a net position with every optional field missing '
      'When it is read '
      'Then it is as of now, converted, and holds nothing (UC-38 AF-05)',
      () async {
        final stub = ApiStub.data({'currencyGroups': <Object?>[]});

        final before = DateTime.now();
        final position = (await repositoryOn(stub).netPosition()).valueOrNull!;
        final after = DateTime.now();

        expect(position.asOf, readBetween(before, after));
        expect(position.isFullyConverted, isTrue);
        expect(position.total, isNull);
        expect(position.byCurrency, isEmpty);
        expect(position.hasNoHoldings, isTrue);
        expect(position.spansCurrencies, isFalse);
      },
    );

    test('Given a currency group with every field missing '
        'When the net position is read '
        'Then its figures are zero in no named currency', () async {
      final stub = ApiStub.data({
        'currencyGroups': [<String, Object?>{}],
      });

      final group = (await repositoryOn(
        stub,
      ).netPosition()).valueOrNull!.byCurrency.single;

      expect(group.net, Money.parse('0', ''));
      expect(group.accounts, Money.parse('0', ''));
      expect(group.creditCards, Money.parse('0', ''));
      expect(group.investments, Money.parse('0', ''));
      expect(group.unconvertedReason, isNull);
    });

    test('Given an answer with no data '
        'When the net position is read '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub).netPosition();

      expect(
        result,
        const Failure<NetPosition>(
          message: 'The instance returned no net position.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given the API refuses the display currency '
        'When the net position is read '
        "Then the API's reason is the failure (UC-38 AF-02)", () async {
      final stub = ApiStub((_) => refusal(400, ['Unknown currency XYZ.']));

      final result = await repositoryOn(stub)
          .netPosition(displayCurrencyCode: 'XYZ');

      expect(
        result,
        const Failure<NetPosition>(
          message: 'Unknown currency XYZ.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the net position is read '
        'Then it is a failure saying so (UC-38 AF-02)', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).netPosition();

      expect(
        result,
        const Failure<NetPosition>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpProjectionRepository.cashFlow', () {
    test('Given a horizon and a display currency '
        'When the projection is read '
        'Then both are asked for', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub)
          .cashFlow(horizonDays: 90, displayCurrencyCode: 'BRL');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/projections/cash-flow');
      expect(stub.request.queryParameters, {
        'HorizonDays': 90,
        'DisplayCurrencyCode': 'BRL',
      });
    });

    test(
      'Given a projection the API produced '
      'When it is read '
      'Then every period is marked projected and the start is not (FR-PJ-04)',
      () async {
        final stub = ApiStub.data({
          'asOf': '2026-11-16T00:00:00.000',
          'through': '2027-02-14T00:00:00.000',
          'displayCurrencyCode': 'BRL',
          'startingBalance': '3000.00',
          'periods': [
            {
              'periodStart': '2026-11-16T00:00:00.000',
              'periodEnd': '2026-11-30T00:00:00.000',
              'openingBalance': '3000.00',
              'closingBalance': '2750.40',
            },
          ],
        });

        final result = await repositoryOn(stub)
            .cashFlow(horizonDays: 90, displayCurrencyCode: 'BRL');

        final projection = result.valueOrNull!;
        expect(projection.asOf, DateTime(2026, 11, 16));
        expect(projection.through, DateTime(2027, 2, 14));
        expect(projection.displayCurrencyCode, 'BRL');
        expect(projection.startingBalance, Money.parse('3000', 'BRL'));
        expect(projection.startingBalance.isProjected, isFalse);
        expect(projection.flatReason, isNull);
        expect(projection.hasNothingToProject, isFalse);
        final period = projection.periods.single;
        expect(period.periodStart, DateTime(2026, 11, 16));
        expect(period.periodEnd, DateTime(2026, 11, 30));
        expect(
          period.openingBalance,
          Money.parse('3000', 'BRL', isProjected: true),
        );
        expect(
          period.closingBalance,
          Money.parse('2750.40', 'BRL', isProjected: true),
        );
      },
    );

    test(
      'Given a projection the API could not shape '
      'When it is read '
      "Then the API's reason is kept instead of a forecast (UC-38 AF-01)",
      () async {
        final stub = ApiStub.data({
          'displayCurrencyCode': 'BRL',
          'startingBalance': '3000.00',
          'flatReason': 'Too little history to project from.',
          'periods': <Object?>[],
        });

        final projection = (await repositoryOn(stub).cashFlow(horizonDays: 30))
            .valueOrNull!;

        expect(projection.flatReason, 'Too little history to project from.');
        expect(projection.periods, isEmpty);
        expect(projection.hasNothingToProject, isTrue);
      },
    );

    test(
      'Given a projection with every optional field missing '
      'When it is read '
      'Then its dates are now and its figures zero in no named currency',
      () async {
        final stub = ApiStub.data({
          'periods': [<String, Object?>{}],
        });

        final before = DateTime.now();
        final projection = (await repositoryOn(stub).cashFlow(horizonDays: 30))
            .valueOrNull!;
        final after = DateTime.now();

        expect(projection.asOf, readBetween(before, after));
        expect(projection.through, readBetween(before, after));
        expect(projection.displayCurrencyCode, isNull);
        expect(projection.startingBalance, Money.parse('0', ''));
        final period = projection.periods.single;
        expect(period.periodStart, readBetween(before, after));
        expect(period.periodEnd, readBetween(before, after));
        expect(period.openingBalance, Money.parse('0', '', isProjected: true));
        expect(period.closingBalance, Money.parse('0', '', isProjected: true));
      },
    );

    test('Given an answer with no data '
        'When the projection is read '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub).cashFlow(horizonDays: 30);

      expect(
        result,
        const Failure<CashFlowProjection>(
          message: 'The instance returned no projection.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given the API refuses the horizon '
        'When the projection is read '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The horizon must be at most 365 days.']),
      );

      final result = await repositoryOn(stub).cashFlow(horizonDays: 9999);

      expect(
        result,
        const Failure<CashFlowProjection>(
          message: 'The horizon must be at most 365 days.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the projection is read '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).cashFlow(horizonDays: 30);

      expect((result as Failure).kind, FailureKind.unreachable);
    });
  });

  group('HttpProjectionRepository.obligations', () {
    test('Given a horizon and a display currency '
        'When the obligations are read '
        'Then both are asked for', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub)
          .obligations(horizonDays: 60, displayCurrencyCode: 'BRL');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/projections/commitments');
      expect(stub.request.queryParameters, {
        'HorizonDays': 60,
        'DisplayCurrencyCode': 'BRL',
      });
    });

    test(
      'Given obligations the API converted '
      'When they are read '
      'Then each is its display amount, marked as scheduled (FR-PJ-03)',
      () async {
        final stub = ApiStub.data({
          'asOf': '2026-11-16T00:00:00.000',
          'through': '2027-01-15T00:00:00.000',
          'displayCurrencyCode': 'BRL',
          'total': '1820.00',
          'isFullyConverted': true,
          'items': [
            {
              'id': 'o1',
              'kind': 1,
              'amount': '100.00',
              'currencyCode': 'USD',
              'displayAmount': '520.00',
              'dueDate': '2026-12-10T00:00:00.000',
              'isOverdue': false,
              'daysOverdue': 0,
            },
            {
              'id': 'o2',
              'kind': 2,
              'amount': '1300.00',
              'currencyCode': 'BRL',
              'displayAmount': '1300.00',
              'dueDate': '2026-11-10T00:00:00.000',
              'isOverdue': true,
              'daysOverdue': 6,
            },
          ],
        });

        final result = await repositoryOn(stub)
            .obligations(horizonDays: 60, displayCurrencyCode: 'BRL');

        final obligations = result.valueOrNull!;
        expect(obligations.asOf, DateTime(2026, 11, 16));
        expect(obligations.through, DateTime(2027, 1, 15));
        expect(obligations.displayCurrencyCode, 'BRL');
        expect(
          obligations.total,
          Money.parse('1820', 'BRL', isProjected: true),
        );
        expect(obligations.isFullyConverted, isTrue);
        expect(obligations.spansCurrencies, isFalse);
        expect(obligations.isEmpty, isFalse);
        final installment = obligations.items.first;
        expect(installment.id, 'o1');
        expect(installment.kind, ObligationKind.installment);
        expect(
          installment.amount,
          Money.parse('520', 'BRL', isProjected: true),
        );
        expect(installment.dueDate, DateTime(2026, 12, 10));
        expect(installment.isOverdue, isFalse);
        expect(installment.daysOverdue, 0);
        final statement = obligations.items.last;
        expect(statement.kind, ObligationKind.statement);
        expect(statement.isOverdue, isTrue);
        expect(statement.daysOverdue, 6);
      },
    );

    test(
      'Given an obligation the API could not convert '
      'When it is read '
      'Then it is its own amount in its own currency (UC-38 AF-03)',
      () async {
        final stub = ApiStub.data({
          'displayCurrencyCode': 'BRL',
          'isFullyConverted': false,
          'items': [
            {'id': 'o1', 'kind': 1, 'amount': '30000', 'currencyCode': 'JPY'},
          ],
        });

        final obligations = (await repositoryOn(stub).obligations(
          horizonDays: 60,
          displayCurrencyCode: 'BRL',
        )).valueOrNull!;

        expect(obligations.isFullyConverted, isFalse);
        expect(obligations.spansCurrencies, isTrue);
        expect(obligations.total, isNull);
        expect(
          obligations.items.single.amount,
          Money.parse('30000', 'JPY', isProjected: true),
        );
      },
    );

    test('Given a kind this build does not know '
        'When an obligation is read '
        'Then it is a commitment of no particular kind', () async {
      final stub = ApiStub.data({
        'items': [
          {'id': 'o1', 'kind': 7},
        ],
      });

      final item = (await repositoryOn(stub).obligations(horizonDays: 60))
          .valueOrNull!
          .items
          .single;

      expect(item.kind, ObligationKind.other);
    });

    test('Given a total with no display currency '
        'When the obligations are read '
        'Then there is no total rather than a bare number (BR-07)', () async {
      final stub = ApiStub.data({'total': '1820.00'});

      final obligations = (await repositoryOn(
        stub,
      ).obligations(horizonDays: 60)).valueOrNull!;

      expect(obligations.total, isNull);
    });

    test('Given obligations with every optional field missing '
        'When they are read '
        'Then the dates are now, converted, and there are none', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final before = DateTime.now();
      final obligations = (await repositoryOn(
        stub,
      ).obligations(horizonDays: 60)).valueOrNull!;
      final after = DateTime.now();

      expect(obligations.asOf, readBetween(before, after));
      expect(obligations.through, readBetween(before, after));
      expect(obligations.isFullyConverted, isTrue);
      expect(obligations.displayCurrencyCode, isNull);
      expect(obligations.total, isNull);
      expect(obligations.items, isEmpty);
      expect(obligations.isEmpty, isTrue);
      expect(obligations.spansCurrencies, isFalse);
    });

    test(
      'Given an obligation with every field missing '
      'When it is read '
      'Then it is due now, not overdue, and zero in no named currency',
      () async {
        final stub = ApiStub.data({
          'items': [<String, Object?>{}],
        });

        final before = DateTime.now();
        final item = (await repositoryOn(stub).obligations(horizonDays: 60))
            .valueOrNull!
            .items
            .single;
        final after = DateTime.now();

        expect(item.id, '');
        expect(item.kind, ObligationKind.other);
        expect(item.amount, Money.parse('0', '', isProjected: true));
        expect(item.dueDate, readBetween(before, after));
        expect(item.isOverdue, isFalse);
        expect(item.daysOverdue, 0);
      },
    );

    test('Given an answer with no data '
        'When the obligations are read '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub).obligations(horizonDays: 60);

      expect(
        result,
        const Failure<CommittedObligations>(
          message: 'The instance returned no obligations.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given the API refuses the horizon '
        'When the obligations are read '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The horizon must be positive.']),
      );

      final result = await repositoryOn(stub).obligations(horizonDays: 0);

      expect(
        result,
        const Failure<CommittedObligations>(
          message: 'The horizon must be positive.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the obligations are read '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).obligations(horizonDays: 60);

      expect((result as Failure).kind, FailureKind.unreachable);
    });
  });
}

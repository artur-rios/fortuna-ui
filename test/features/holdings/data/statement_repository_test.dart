import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/holdings/data/statement_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> statementOutput({
  Object? status = 'Closed',
  Object? transactions,
}) => {
  'id': 's1',
  'creditCardId': 'c1',
  'currencyCode': 'BRL',
  'status': ?status,
  'periodStart': '2026-02-01T00:00:00.000',
  'periodEnd': '2026-02-28T00:00:00.000',
  'closingDate': '2026-03-01T00:00:00.000',
  'dueDate': '2026-03-10T00:00:00.000',
  'previousBalance': '100.00',
  'purchaseTotal': '850.40',
  'paymentsReceived': '100.00',
  'foreignTaxTotal': '3.21',
  'otherEntries': '-5.00',
  'amountDue': '848.62',
  'settlementTransactionId': 't9',
  'transactions': ?transactions,
};

void main() {
  group('HttpStatementRepository.listForCard', () {
    test('Given a card with a statement '
        'When its statements are listed '
        'Then they are asked for latest period first and every total is read '
        'as sent (UC-16 main flow)', () async {
      final stub = ApiStub.data([statementOutput()]);

      final result = await HttpStatementRepository.fromDio(stub.dio)
          .listForCard('c1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/credit-cards/c1/statements');
      expect(stub.request.queryParameters, {
        'SortBy': 'periodEnd',
        'Descending': true,
      });
      final statement = result.valueOrNull!.single;
      expect(statement.id, 's1');
      expect(statement.creditCardId, 'c1');
      expect(statement.currencyCode, 'BRL');
      expect(statement.status, StatementStatus.closed);
      expect(statement.periodStart, DateTime(2026, 2));
      expect(statement.periodEnd, DateTime(2026, 2, 28));
      expect(statement.closingDate, DateTime(2026, 3));
      expect(statement.dueDate, DateTime(2026, 3, 10));
      expect(statement.previousBalance, Money.parse('100.00', 'BRL'));
      expect(statement.purchaseTotal, Money.parse('850.40', 'BRL'));
      expect(statement.paymentsReceived, Money.parse('100.00', 'BRL'));
      expect(statement.foreignTaxTotal, Money.parse('3.21', 'BRL'));
      expect(statement.otherEntries, Money.parse('-5.00', 'BRL'));
      expect(statement.amountDue, Money.parse('848.62', 'BRL'));
      expect(statement.settlementTransactionId, 't9');
      expect(statement.charges, isEmpty);
    });

    test(
      'Given statements in each status, in any letter case '
      'When they are listed '
      'Then each status is read by name and anything else reads as open',
      () async {
        final stub = ApiStub.data([
          for (final status in ['Open', 'closed', 'SETTLED', 'Disputed', null])
            statementOutput(status: status),
        ]);

        final result = await HttpStatementRepository.fromDio(stub.dio)
            .listForCard('c1');

        expect(result.valueOrNull!.map((statement) => statement.status), [
          StatementStatus.open,
          StatementStatus.closed,
          StatementStatus.settled,
          StatementStatus.open,
          StatementStatus.open,
        ]);
      },
    );

    test(
      'Given a statement with every optional field missing '
      'When it is listed '
      'Then the totals read as zero, the dates as the epoch and it is open',
      () async {
        final stub = ApiStub.data([<String, Object?>{}]);

        final statement = (await HttpStatementRepository.fromDio(
          stub.dio,
        ).listForCard('c1')).valueOrNull!.single;

        expect(statement.id, '');
        expect(statement.creditCardId, '');
        expect(statement.currencyCode, '');
        expect(statement.status, StatementStatus.open);
        expect(statement.periodStart, DateTime(1970));
        expect(statement.periodEnd, DateTime(1970));
        expect(statement.closingDate, DateTime(1970));
        expect(statement.dueDate, DateTime(1970));
        for (final total in [
          statement.previousBalance,
          statement.purchaseTotal,
          statement.paymentsReceived,
          statement.foreignTaxTotal,
          statement.otherEntries,
          statement.amountDue,
        ]) {
          expect(total, Money.zero(''));
        }
        expect(statement.settlementTransactionId, isNull);
        expect(statement.charges, isEmpty);
      },
    );

    test('Given an answer with no data '
        'When the statements are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpStatementRepository.fromDio(stub.dio)
          .listForCard('c1');

      expect(result.valueOrNull, isEmpty);
    });

    test("Given a card that is not the user's "
        'When its statements are listed '
        "Then the API's not-found is the failure (UC-16 AF-05)", () async {
      final stub = ApiStub((_) => refusal(404, ['Credit card not found.']));

      final result = await HttpStatementRepository.fromDio(stub.dio)
          .listForCard('c1');

      expect(
        result,
        const Failure<List<CardStatement>>(
          message: 'Credit card not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the statements are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpStatementRepository.fromDio(stub.dio)
          .listForCard('c1');

      expect(
        result,
        const Failure<List<CardStatement>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpStatementRepository.read', () {
    test('Given a statement with a converted, late-arriving charge '
        'When it is read '
        'Then the charge keeps its amount, original amount and rate as sent '
        '(FR-HO-09)', () async {
      final stub = ApiStub.data(
        statementOutput(
          transactions: [
            {
              'id': 't1',
              'occurredOn': '2026-01-30T00:00:00.000',
              'amount': '52.34',
              'isLateArriving': true,
              'direction': 'Expense',
              'originalAmount': '10.00',
              'originalCurrencyCode': 'USD',
              'appliedRate': '5.234',
              'rateDate': '2026-01-30T00:00:00.000',
            },
          ],
        ),
      );

      final result = await HttpStatementRepository.fromDio(stub.dio).read('s1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/statements/s1');
      final statement = result.valueOrNull!;
      expect(statement.hasLateArrivals, isTrue);
      final charge = statement.charges.single;
      expect(charge.id, 't1');
      expect(charge.occurredOn, DateTime(2026, 1, 30));
      expect(charge.amount, Money.parse('52.34', 'BRL'));
      expect(charge.isLateArriving, isTrue);
      expect(charge.direction, 'Expense');
      expect(charge.originalAmount, Money.parse('10.00', 'USD'));
      expect(charge.wasConverted, isTrue);
      expect(charge.appliedRate, '5.234');
      expect(charge.rateDate, DateTime(2026, 1, 30));
    });

    test('Given a charge with every optional field missing '
        'When its statement is read '
        "Then it reads as zero in the statement's currency, on time and "
        'unconverted', () async {
      final stub = ApiStub.data(
        statementOutput(transactions: [<String, Object?>{}]),
      );

      final charge = (await HttpStatementRepository.fromDio(
        stub.dio,
      ).read('s1')).valueOrNull!.charges.single;

      expect(charge.id, '');
      expect(charge.occurredOn, DateTime(1970));
      expect(charge.amount, Money.zero('BRL'));
      expect(charge.isLateArriving, isFalse);
      expect(charge.direction, isNull);
      expect(charge.originalAmount, isNull);
      expect(charge.wasConverted, isFalse);
      expect(charge.appliedRate, isNull);
      expect(charge.rateDate, isNull);
    });

    test('Given charges carrying only half of an original amount '
        'When their statement is read '
        'Then neither has an original amount, since a number without its '
        'currency is not money', () async {
      final stub = ApiStub.data(
        statementOutput(
          transactions: [
            {'id': 't1', 'amount': '52.34', 'originalAmount': '10.00'},
            {'id': 't2', 'amount': '52.34', 'originalCurrencyCode': 'USD'},
          ],
        ),
      );

      final charges = (await HttpStatementRepository.fromDio(
        stub.dio,
      ).read('s1')).valueOrNull!.charges;

      expect(charges.map((charge) => charge.originalAmount), [null, null]);
      expect(charges.map((charge) => charge.wasConverted), [false, false]);
    });

    test('Given an answer with no data '
        'When a statement is read '
        'Then it is not found (UC-16 AF-05)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpStatementRepository.fromDio(stub.dio).read('s1');

      expect(
        result,
        const Failure<CardStatement>(
          message: 'That statement was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When a statement is read '
        "Then the API's reason is the failure (UC-16 AF-05)", () async {
      final stub = ApiStub((_) => refusal(404, ['Statement not found.']));

      final result = await HttpStatementRepository.fromDio(stub.dio).read('s1');

      expect(
        result,
        const Failure<CardStatement>(
          message: 'Statement not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpStatementRepository.close', () {
    test('Given an open statement '
        'When it is closed '
        'Then the close is posted to its own address with no body', () async {
      final stub = ApiStub.data({'id': 's1'});

      final result = await HttpStatementRepository.fromDio(stub.dio)
          .close('s1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/statements/s1/close');
      expect(stub.body, isNull);
    });

    test('Given a closing date that has not passed on the instance '
        'When the statement is closed '
        "Then the API's refusal is the failure (UC-16 AF-01)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The closing date has not been reached.']),
      );

      final result = await HttpStatementRepository.fromDio(stub.dio)
          .close('s1');

      expect(
        result,
        const Failure<void>(
          message: 'The closing date has not been reached.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a statement is closed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpStatementRepository.fromDio(stub.dio)
          .close('s1');

      expect(
        result,
        const Failure<void>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpStatementRepository.settle', () {
    test(
      'Given a closed statement '
      'When it is settled from an account '
      'Then the payment is posted with the amount as typed (FR-HO-08)',
      () async {
        final stub = ApiStub.data({'id': 's1'});

        final result = await HttpStatementRepository.fromDio(stub.dio).settle(
          statementId: 's1',
          financialAccountId: 'a1',
          amount: '848.62',
          paymentDate: DateTime(2026, 3, 9),
        );

        expect(result, const Success<void>(null));
        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/statements/s1/settle');
        expect(stub.body, {
          'amount': '848.62',
          'financialAccountId': 'a1',
          'id': 's1',
          'paymentDate': '2026-03-09T00:00:00.000',
        });
      },
    );

    test('Given a statement that is not closed '
        'When it is settled '
        "Then the API's refusal is the failure (UC-16 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['Only a closed statement can be settled.']),
      );

      final result = await HttpStatementRepository.fromDio(stub.dio).settle(
        statementId: 's1',
        financialAccountId: 'a1',
        amount: '848.62',
        paymentDate: DateTime(2026, 3, 9),
      );

      expect(
        result,
        const Failure<void>(
          message: 'Only a closed statement can be settled.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an account in another currency '
        'When the statement is settled from it '
        "Then the API's refusal is the failure, nothing converted "
        '(UC-16 AF-03)', () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The account currency does not match.']),
      );

      final result = await HttpStatementRepository.fromDio(stub.dio).settle(
        statementId: 's1',
        financialAccountId: 'a2',
        amount: '848.62',
        paymentDate: DateTime(2026, 3, 9),
      );

      expect(
        result,
        const Failure<void>(
          message: 'The account currency does not match.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });
}

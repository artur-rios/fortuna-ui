import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/transactions/data/transfer_repository.dart';

import '../../../support/api_stub.dart';

Future<Result<Transfer>> _record(ApiStub stub) =>
    HttpTransferRepository.fromDio(stub.dio).record(
      originAccountId: 'a1',
      destinationAccountId: 'a2',
      amount: '150.00',
      occurredOn: DateTime(2026, 11, 10),
    );

void main() {
  group('HttpTransferRepository.record', () {
    test('Given a transfer between accounts in one currency '
        'When it is recorded '
        'Then the exact amount is posted and the one stored transfer comes '
        'back (UC-21 main flow)', () async {
      final stub = ApiStub.data({
        'id': 'tr1',
        'occurredOn': '2026-11-10T00:00:00.000',
        'originFinancialAccountId': 'a1',
        'destinationFinancialAccountId': 'a2',
        'outboundAmount': '150.00',
        'outboundCurrencyCode': 'BRL',
        'outboundTransactionId': 'tx1',
        'inboundAmount': '150.00',
        'inboundCurrencyCode': 'BRL',
        'inboundTransactionId': 'tx2',
      }, status: 201);

      final result = await _record(stub);

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/transfers');
      expect(stub.body, {
        'amount': '150.00',
        'destinationFinancialAccountId': 'a2',
        'destinationStatementId': null,
        'occurredOn': '2026-11-10T00:00:00.000',
        'originFinancialAccountId': 'a1',
        'ownerId': null,
      });
      final transfer = result.valueOrNull!;
      expect(transfer.id, 'tr1');
      expect(transfer.occurredOn, DateTime(2026, 11, 10));
      expect(transfer.originAccountId, 'a1');
      expect(transfer.destinationAccountId, 'a2');
      expect(transfer.outboundAmount.amount, Decimal.parse('150.00'));
      expect(transfer.outboundAmount.currencyCode, 'BRL');
      expect(transfer.inboundAmount.amount, Decimal.parse('150.00'));
      expect(transfer.inboundAmount.currencyCode, 'BRL');
      expect(transfer.appliedRate, isNull);
      expect(transfer.rateDate, isNull);
      expect(transfer.wasConverted, isFalse);
    });

    test('Given a transfer the API converted between currencies '
        'When it is recorded '
        'Then both sides and the rate are kept as the API performed them '
        '(UC-21 AF-03)', () async {
      final stub = ApiStub.data({
        'id': 'tr1',
        'occurredOn': '2026-11-10T00:00:00.000',
        'originFinancialAccountId': 'a1',
        'destinationFinancialAccountId': 'a2',
        'outboundAmount': '150.00',
        'outboundCurrencyCode': 'USD',
        'inboundAmount': '801.375',
        'inboundCurrencyCode': 'BRL',
        'appliedRate': '5.3425',
        'rateDate': '2026-11-09T00:00:00.000',
      }, status: 201);

      final result = await _record(stub);

      final transfer = result.valueOrNull!;
      expect(transfer.outboundAmount.amount, Decimal.parse('150.00'));
      expect(transfer.outboundAmount.currencyCode, 'USD');
      expect(transfer.inboundAmount.amount, Decimal.parse('801.375'));
      expect(transfer.inboundAmount.currencyCode, 'BRL');
      expect(transfer.appliedRate, '5.3425');
      expect(transfer.rateDate, DateTime(2026, 11, 9));
      expect(transfer.wasConverted, isTrue);
    });

    test('Given a stored transfer with every optional field missing '
        'When it is recorded '
        'Then the gaps read as empty rather than failing', () async {
      final stub = ApiStub.data(<String, Object?>{}, status: 201);

      final result = await _record(stub);

      final transfer = result.valueOrNull!;
      expect(transfer.id, '');
      expect(transfer.occurredOn, DateTime(1970));
      expect(transfer.originAccountId, '');
      expect(transfer.destinationAccountId, isNull);
      expect(transfer.outboundAmount.amount, Decimal.zero);
      expect(transfer.outboundAmount.currencyCode, '');
      expect(transfer.inboundAmount.amount, Decimal.zero);
      expect(transfer.inboundAmount.currencyCode, '');
      expect(transfer.appliedRate, isNull);
      expect(transfer.rateDate, isNull);
      expect(transfer.wasConverted, isFalse);
    });

    test(
      'Given an answer with no transfer in it '
      'When it is recorded '
      'Then it is a failure, not a transfer nobody can show (UC-21 AF-05)',
      () async {
        final stub = ApiStub.data(null, status: 201);

        final result = await _record(stub);

        expect(
          result,
          const Failure<Transfer>(
            message: 'The instance did not confirm the transfer.',
            kind: FailureKind.serverError,
          ),
        );
      },
    );

    test('Given a currency pair the instance will not convert '
        'When the transfer is recorded '
        "Then the API's reason is the failure (UC-21 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(422, ['No exchange rate from USD to BRL.']),
      );

      final result = await _record(stub);

      expect(
        result,
        const Failure<Transfer>(
          message: 'No exchange rate from USD to BRL.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test("Given an account that is not the user's "
        'When the transfer is recorded '
        'Then it is not found (UC-21 AF-04)', () async {
      final stub = ApiStub((_) => refusal(404, ['Account not found.']));

      final result = await _record(stub);

      expect(
        result,
        const Failure<Transfer>(
          message: 'Account not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the transfer is recorded '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await _record(stub);

      expect(
        result,
        const Failure<Transfer>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/transactions/data/installment_repository.dart';

import '../../../support/api_stub.dart';

Future<Result<InstallmentPlan>> _record(ApiStub stub, {String? counterparty}) =>
    HttpInstallmentRepository.fromDio(stub.dio).record(
      creditCardId: 'card1',
      categoryId: 'electronics',
      totalAmount: '100.00',
      installmentCount: 3,
      purchasedOn: DateTime(2026, 11, 10),
      currencyCode: 'BRL',
      counterparty: counterparty,
    );

Map<String, Object?> _installment(
  int number,
  String amount, {
  String? currencyCode,
}) => {
  'number': number,
  'transactionId': 'tx$number',
  'amount': amount,
  'currencyCode': ?currencyCode,
  'occurredOn':
      '2026-${(10 + number).toString().padLeft(2, '0')}-10T00:00:00.000',
};

void main() {
  group('HttpInstallmentRepository.record', () {
    test('Given a purchase split across three charges '
        'When it is recorded '
        'Then the total is posted as typed and the plan comes back with the '
        "API's own installments (UC-22 main flow)", () async {
      final stub = ApiStub.data({
        'id': 'plan1',
        'creditCardId': 'card1',
        'currencyCode': 'BRL',
        'totalAmount': '100.00',
        'installmentCount': 3,
        'purchasedOn': '2026-11-10T00:00:00.000',
        'installments': [
          _installment(1, '33.34', currencyCode: 'BRL'),
          _installment(2, '33.33', currencyCode: 'BRL'),
        ],
      }, status: 201);

      final result = await _record(stub);

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/installment-plans');
      expect(stub.body, {
        'categoryId': 'electronics',
        'counterparty': null,
        'creditCardId': 'card1',
        'currencyCode': 'BRL',
        'installmentCount': 3,
        'ownerId': null,
        'purchasedOn': '2026-11-10T00:00:00.000',
        'totalAmount': '100.00',
      });
      final plan = result.valueOrNull!;
      expect(plan.id, 'plan1');
      expect(plan.creditCardId, 'card1');
      expect(plan.totalAmount.amount, Decimal.parse('100.00'));
      expect(plan.totalAmount.currencyCode, 'BRL');
      expect(plan.installmentCount, 3);
      expect(plan.purchasedOn, DateTime(2026, 11, 10));
      final first = plan.installments.first;
      expect(first.number, 1);
      expect(first.transactionId, 'tx1');
      expect(first.amount.amount, Decimal.parse('33.34'));
      expect(first.amount.currencyCode, 'BRL');
      expect(first.occurredOn, DateTime(2026, 11, 10));
      expect(plan.installments[1].occurredOn, DateTime(2026, 12, 10));
    });

    test('Given installments that do not divide evenly '
        'When the plan is recorded '
        'Then each keeps the amount the API gave it, remainder and all '
        '(UC-22 AF-04)', () async {
      final stub = ApiStub.data({
        'currencyCode': 'BRL',
        'totalAmount': '100.00',
        'installments': [
          _installment(1, '33.34'),
          _installment(2, '33.33'),
          _installment(3, '33.33'),
        ],
      }, status: 201);

      final result = await _record(stub);

      final plan = result.valueOrNull!;
      expect(plan.installments.map((each) => each.number), [1, 2, 3]);
      expect(plan.installments.map((each) => each.amount.amount), [
        Decimal.parse('33.34'),
        Decimal.parse('33.33'),
        Decimal.parse('33.33'),
      ]);
      expect(plan.isUneven, isTrue);
    });

    test('Given installments that name no currency of their own '
        'When the plan is recorded '
        "Then they are in the plan's currency, and one that names its own "
        'keeps it', () async {
      final stub = ApiStub.data({
        'currencyCode': 'BRL',
        'totalAmount': '100.00',
        'installments': [
          _installment(1, '50.00'),
          _installment(2, '9.50', currencyCode: 'USD'),
        ],
      }, status: 201);

      final result = await _record(stub);

      final installments = result.valueOrNull!.installments;
      expect(installments[0].amount.currencyCode, 'BRL');
      expect(installments[1].amount.currencyCode, 'USD');
    });

    test('Given a purchase from a named counterparty '
        'When it is recorded '
        'Then the counterparty is sent', () async {
      final stub = ApiStub.data({'id': 'plan1'}, status: 201);

      await _record(stub, counterparty: 'Electronics Store');

      expect(
        (stub.body! as Map<String, Object?>)['counterparty'],
        'Electronics Store',
      );
    });

    test('Given a plan and an installment with every optional field missing '
        'When the plan is recorded '
        'Then the gaps read as empty rather than failing', () async {
      final stub = ApiStub.data({
        'installments': [<String, Object?>{}],
      }, status: 201);

      final result = await _record(stub);

      final plan = result.valueOrNull!;
      expect(plan.id, '');
      expect(plan.creditCardId, '');
      expect(plan.totalAmount.amount, Decimal.zero);
      expect(plan.totalAmount.currencyCode, '');
      expect(plan.installmentCount, 0);
      expect(plan.purchasedOn, DateTime(1970));
      final installment = plan.installments.single;
      expect(installment.number, 0);
      expect(installment.transactionId, '');
      expect(installment.amount.amount, Decimal.zero);
      expect(installment.amount.currencyCode, '');
      expect(installment.occurredOn, DateTime(1970));
    });

    test('Given a plan that came back with no installments '
        'When it is recorded '
        'Then the plan has none', () async {
      final stub = ApiStub.data({'id': 'plan1'}, status: 201);

      final result = await _record(stub);

      expect(result.valueOrNull!.installments, isEmpty);
      expect(result.valueOrNull!.isUneven, isFalse);
    });

    test('Given an answer with no plan in it '
        'When it is recorded '
        'Then it is a failure, not a plan with nothing to show', () async {
      final stub = ApiStub.data(null, status: 201);

      final result = await _record(stub);

      expect(
        result,
        const Failure<InstallmentPlan>(
          message: 'The instance did not confirm the plan.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given a plan the API refuses '
        'When it is recorded '
        "Then the API's reason is the failure (UC-22 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The installment count must be at least 2.']),
      );

      final result = await _record(stub);

      expect(
        result,
        const Failure<InstallmentPlan>(
          message: 'The installment count must be at least 2.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test("Given a card that is not the user's "
        'When the plan is recorded '
        'Then it is not found (UC-22 AF-05)', () async {
      final stub = ApiStub((_) => refusal(404, ['Credit card not found.']));

      final result = await _record(stub);

      expect(
        result,
        const Failure<InstallmentPlan>(
          message: 'Credit card not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the plan is recorded '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await _record(stub);

      expect(
        result,
        const Failure<InstallmentPlan>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> cardOutput() => {
  'id': 'c1',
  'name': 'Gold',
  'currencyCode': 'BRL',
  'creditLimit': '5000.00',
  'usedAmount': '5200.00',
  'availableAmount': '0.00',
  'overageAmount': '200.00',
  'closingDay': 25,
  'dueDay': 5,
  'issuer': 'Neo Bank',
  'lastFourDigits': '4242',
};

void main() {
  group('HttpCreditCardRepository.list', () {
    test('Given more cards than one page holds '
        'When they are listed '
        'Then every page is read and the list is whole (UC-15)', () async {
      final stub = ApiStub((request) {
        final page = requestedPage(request);
        return paginated(
          [
            {...cardOutput(), 'id': 'p$page'},
          ],
          pageNumber: page,
          totalPages: 2,
        );
      });

      final result = await HttpCreditCardRepository.fromDio(stub.dio).list();

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
      'Given a card over its limit '
      'When the cards are listed '
      "Then all four figures are the API's own, none derived (UC-15 main flow)",
      () async {
        final stub = ApiStub.data([cardOutput()]);

        final result = await HttpCreditCardRepository.fromDio(stub.dio).list();

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/credit-cards');
        expect(stub.request.queryParameters, {
          'PageNumber': 1,
          'PageSize': 100,
        });
        final card = result.valueOrNull!.single;
        expect(card.id, 'c1');
        expect(card.name, 'Gold');
        expect(card.currencyCode, 'BRL');
        expect(card.creditLimit, Money.parse('5000.00', 'BRL'));
        expect(card.usedAmount, Money.parse('5200.00', 'BRL'));
        expect(card.availableAmount, Money.parse('0', 'BRL'));
        expect(card.overageAmount, Money.parse('200.00', 'BRL'));
        expect(card.isOverLimit, isTrue);
        expect(card.closingDay, 25);
        expect(card.dueDay, 5);
        expect(card.issuer, 'Neo Bank');
        expect(card.lastFourDigits, '4242');
      },
    );

    test('Given a card with every optional field missing '
        'When it is listed '
        'Then the figures read as zero and both days as the first', () async {
      final stub = ApiStub.data([<String, Object?>{}]);

      final card = (await HttpCreditCardRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(card.id, '');
      expect(card.name, '');
      expect(card.currencyCode, '');
      expect(card.creditLimit, Money.zero(''));
      expect(card.usedAmount, Money.zero(''));
      expect(card.availableAmount, Money.zero(''));
      expect(card.overageAmount, Money.zero(''));
      expect(card.isOverLimit, isFalse);
      expect(card.closingDay, 1);
      expect(card.dueDay, 1);
      expect(card.issuer, isNull);
      expect(card.lastFourDigits, isNull);
    });

    test('Given an answer with no data '
        'When the cards are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpCreditCardRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given an instance that cannot be reached '
        'When the cards are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCreditCardRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<CreditCard>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCreditCardRepository.read', () {
    test('Given a card that exists '
        'When it is read '
        'Then it is fetched by its id and mapped', () async {
      final stub = ApiStub.data(cardOutput());

      final result = await HttpCreditCardRepository.fromDio(stub.dio)
          .read('c1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/credit-cards/c1');
      expect(result.valueOrNull!.name, 'Gold');
      expect(result.valueOrNull!.overageAmount, Money.parse('200', 'BRL'));
    });

    test('Given an answer with no data '
        'When a card is read '
        'Then it is not found (UC-15 AF-04)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpCreditCardRepository.fromDio(stub.dio)
          .read('c1');

      expect(
        result,
        const Failure<CreditCard>(
          message: 'That card was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When a card is read '
        "Then the API's reason is the failure (UC-15 AF-04)", () async {
      final stub = ApiStub((_) => refusal(404, ['Credit card not found.']));

      final result = await HttpCreditCardRepository.fromDio(stub.dio)
          .read('c1');

      expect(
        result,
        const Failure<CreditCard>(
          message: 'Credit card not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpCreditCardRepository.create', () {
    test(
      'Given a new card with only what is required '
      'When it is created '
      'Then the limit is sent as typed and the optional fields as null',
      () async {
        final stub = ApiStub.data({'id': 'c1'}, status: 201);

        final result = await HttpCreditCardRepository.fromDio(stub.dio).create(
          name: 'Gold',
          currencyCode: 'BRL',
          creditLimit: '5000.00',
          closingDay: 25,
          dueDay: 5,
        );

        expect(result, const Success<void>(null));
        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/credit-cards');
        expect(stub.body, {
          'closingDay': 25,
          'creditLimit': '5000.00',
          'currencyCode': 'BRL',
          'dueDay': 5,
          'issuer': null,
          'lastFourDigits': null,
          'name': 'Gold',
        });
      },
    );

    test('Given a new card with its issuer and last digits '
        'When it is created '
        'Then both are sent', () async {
      final stub = ApiStub.data({'id': 'c1'}, status: 201);

      await HttpCreditCardRepository.fromDio(stub.dio).create(
        name: 'Gold',
        currencyCode: 'BRL',
        creditLimit: '5000.00',
        closingDay: 25,
        dueDay: 5,
        issuer: 'Neo Bank',
        lastFourDigits: '4242',
      );

      final body = stub.body! as Map<String, Object?>;
      expect(body['issuer'], 'Neo Bank');
      expect(body['lastFourDigits'], '4242');
    });

    test('Given the API refuses the day combination '
        'When a card is created '
        "Then the API's reason is the failure (UC-15 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The due day must follow the closing day.']),
      );

      final result = await HttpCreditCardRepository.fromDio(stub.dio).create(
        name: 'Gold',
        currencyCode: 'BRL',
        creditLimit: '5000.00',
        closingDay: 25,
        dueDay: 25,
      );

      expect(
        result,
        const Failure<void>(
          message: 'The due day must follow the closing day.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given the API refuses a duplicate name '
        'When a card is created '
        "Then the API's reason is the failure (UC-15 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A card with that name already exists.']),
      );

      final result = await HttpCreditCardRepository.fromDio(stub.dio).create(
        name: 'Gold',
        currencyCode: 'BRL',
        creditLimit: '5000.00',
        closingDay: 25,
        dueDay: 5,
      );

      expect(
        result,
        const Failure<void>(
          message: 'A card with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('HttpCreditCardRepository.update', () {
    test('Given an edited card '
        'When it is saved '
        'Then it is put to its own address without a currency', () async {
      final stub = ApiStub.data({'id': 'c1'});

      final result = await HttpCreditCardRepository.fromDio(stub.dio).update(
        id: 'c1',
        name: 'Platinum',
        creditLimit: '8000',
        closingDay: 20,
        dueDay: 1,
        issuer: 'Neo Bank',
      );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/credit-cards/c1');
      expect(stub.body, {
        'closingDay': 20,
        'creditLimit': '8000',
        'currencyCode': null,
        'dueDay': 1,
        'issuer': 'Neo Bank',
        'name': 'Platinum',
      });
    });

    test('Given the API refuses the edit '
        'When it is saved '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The limit must be positive.']),
      );

      final result = await HttpCreditCardRepository.fromDio(stub.dio).update(
        id: 'c1',
        name: 'Platinum',
        creditLimit: '0',
        closingDay: 20,
        dueDay: 1,
      );

      expect(
        result,
        const Failure<void>(
          message: 'The limit must be positive.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('HttpCreditCardRepository.delete', () {
    test('Given a card '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 'c1'});

      final result = await HttpCreditCardRepository.fromDio(stub.dio)
          .delete('c1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/credit-cards/c1');
    });

    test('Given records still referencing the card '
        'When it is deleted '
        "Then the API's reason is the failure (UC-15 AF-05)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['The card still has statements.']),
      );

      final result = await HttpCreditCardRepository.fromDio(stub.dio)
          .delete('c1');

      expect(
        result,
        const Failure<void>(
          message: 'The card still has statements.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a card is deleted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCreditCardRepository.fromDio(stub.dio)
          .delete('c1');

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

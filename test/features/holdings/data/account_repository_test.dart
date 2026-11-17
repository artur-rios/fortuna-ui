import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> accountOutput({
  Object? accountType = 2,
  Object? institution = 'Neo Bank',
  Object? isDeleted,
}) => {
  'id': 'a1',
  'name': 'Savings',
  'accountType': ?accountType,
  'currencyCode': 'BRL',
  'openingBalance': '1500.25',
  'institution': ?institution,
  'isDeleted': ?isDeleted,
};

void main() {
  group('HttpAccountRepository.list', () {
    test(
      'Given more accounts than one page holds '
      'When they are listed '
      'Then every page is read and the list is whole (UC-14 step 1)',
      () async {
        final stub = ApiStub((request) {
          final page = requestedPage(request);
          return paginated(
            [
              {...accountOutput(), 'id': 'p$page'},
            ],
            pageNumber: page,
            totalPages: 2,
          );
        });

        final result = await HttpAccountRepository.fromDio(stub.dio).list();

        expect(
          [
            for (final request in stub.requests)
              request.queryParameters['PageNumber'],
          ],
          [1, 2],
        );
        expect([for (final item in result.valueOrNull!) item.id], ['p1', 'p2']);
      },
    );

    test('Given the API lists an account '
        'When the accounts are listed '
        'Then it is fetched from the accounts route and mapped as sent '
        '(UC-14 main flow)', () async {
      final stub = ApiStub.data([accountOutput(isDeleted: true)]);

      final result = await HttpAccountRepository.fromDio(stub.dio).list();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/accounts');
      expect(stub.request.queryParameters, {'PageNumber': 1, 'PageSize': 100});
      final account = result.valueOrNull!.single;
      expect(account.id, 'a1');
      expect(account.name, 'Savings');
      expect(account.type, AccountType.savings);
      expect(account.currencyCode, 'BRL');
      expect(
        account.openingBalance,
        Money(amount: Decimal.parse('1500.25'), currencyCode: 'BRL'),
      );
      expect(account.institution, 'Neo Bank');
      expect(account.isDeleted, isTrue);
    });

    test(
      'Given accounts of every type the contract numbers '
      'When they are listed '
      'Then each number maps to its type and anything else reads as other',
      () async {
        final stub = ApiStub.data([
          for (final type in [1, 2, 3, 4, 99, null])
            accountOutput(accountType: type),
        ]);

        final result = await HttpAccountRepository.fromDio(stub.dio).list();

        expect(result.valueOrNull!.map((account) => account.type), [
          AccountType.checking,
          AccountType.savings,
          AccountType.cash,
          AccountType.other,
          AccountType.other,
          AccountType.other,
        ]);
      },
    );

    test(
      'Given an account with every optional field missing '
      'When it is listed '
      'Then the gaps read as empty, a zero opening balance and not deleted',
      () async {
        final stub = ApiStub.data([<String, Object?>{}]);

        final account = (await HttpAccountRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!.single;

        expect(account.id, '');
        expect(account.name, '');
        expect(account.type, AccountType.other);
        expect(account.currencyCode, '');
        expect(account.openingBalance, Money.zero(''));
        expect(account.institution, isNull);
        expect(account.isDeleted, isFalse);
      },
    );

    test('Given an answer with no data '
        'When the accounts are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpAccountRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given the API fails on its side '
        'When the accounts are listed '
        "Then the API's reason is a server failure", () async {
      final stub = ApiStub((_) => refusal(500, ['Something broke.']));

      final result = await HttpAccountRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<FinancialAccount>>(
          message: 'Something broke.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the accounts are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpAccountRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<FinancialAccount>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpAccountRepository.read', () {
    test(
      'Given an account that exists '
      'When it is read '
      'Then it is fetched by its id, live records only, and mapped',
      () async {
        final stub = ApiStub.data(accountOutput());

        final result = await HttpAccountRepository.fromDio(stub.dio).read('a1');

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/accounts/a1');
        expect(stub.request.queryParameters, {'includeDeleted': false});
        expect(result.valueOrNull!.name, 'Savings');
        expect(result.valueOrNull!.type, AccountType.savings);
      },
    );

    test('Given an answer with no data '
        'When an account is read '
        'Then it is not found (UC-14 AF-04)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpAccountRepository.fromDio(stub.dio).read('a1');

      expect(
        result,
        const Failure<FinancialAccount>(
          message: 'That account was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When an account is read '
        "Then the API's reason is the failure (UC-14 AF-04)", () async {
      final stub = ApiStub((_) => refusal(404, ['Account not found.']));

      final result = await HttpAccountRepository.fromDio(stub.dio).read('a1');

      expect(
        result,
        const Failure<FinancialAccount>(
          message: 'Account not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpAccountRepository.balance', () {
    test(
      'Given the API reports a balance '
      'When it is asked for '
      'Then the decimal string and its moment are kept exactly as sent',
      () async {
        final stub = ApiStub.data({
          'id': 'a1',
          'balance': '1234567.89',
          'currencyCode': 'BRL',
          'asOf': '2026-03-05T10:30:00.000',
        });

        final result = await HttpAccountRepository.fromDio(stub.dio)
            .balance('a1');

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/accounts/a1/balance');
        expect(stub.request.queryParameters, isEmpty);
        final balance = result.valueOrNull!;
        expect(
          balance.balance,
          Money(amount: Decimal.parse('1234567.89'), currencyCode: 'BRL'),
        );
        expect(balance.asOf, DateTime(2026, 3, 5, 10, 30));
      },
    );

    test(
      'Given a balance without a currency or a moment '
      'When it is asked for '
      'Then the amount is kept with an empty currency and no moment',
      () async {
        final stub = ApiStub.data({'balance': '10'});

        final result = await HttpAccountRepository.fromDio(stub.dio)
            .balance('a1');

        expect(result.valueOrNull!.balance, Money.parse('10', ''));
        expect(result.valueOrNull!.asOf, isNull);
      },
    );

    test('Given an answer with no balance in it '
        'When it is asked for '
        'Then no balance is invented (UC-14 AF-07)', () async {
      final stub = ApiStub.data({'id': 'a1', 'currencyCode': 'BRL'});

      final result = await HttpAccountRepository.fromDio(stub.dio)
          .balance('a1');

      expect(
        result,
        const Failure<AccountBalance>(
          message: 'The balance could not be read.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an answer with no data '
        'When the balance is asked for '
        'Then no balance is invented (UC-14 AF-07)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpAccountRepository.fromDio(stub.dio)
          .balance('a1');

      expect(
        result,
        const Failure<AccountBalance>(
          message: 'The balance could not be read.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given the API answers 404 '
        'When the balance is asked for '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(404, ['Account not found.']));

      final result = await HttpAccountRepository.fromDio(stub.dio)
          .balance('a1');

      expect(
        result,
        const Failure<AccountBalance>(
          message: 'Account not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpAccountRepository.create', () {
    test(
      'Given a new account without an institution '
      'When it is created '
      'Then the opening balance is sent as typed with the type as its number',
      () async {
        final stub = ApiStub.data({'id': 'a1'}, status: 201);

        final result = await HttpAccountRepository.fromDio(stub.dio).create(
          name: 'Wallet',
          type: AccountType.cash,
          currencyCode: 'BRL',
          openingBalance: '100.10',
        );

        expect(result, const Success<void>(null));
        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/accounts');
        expect(stub.body, {
          'accountType': 3,
          'currencyCode': 'BRL',
          'name': 'Wallet',
          'openingBalance': '100.10',
        });
      },
    );

    test('Given accounts of each type '
        'When they are created '
        'Then each type travels as the number the contract gives it', () async {
      final stub = ApiStub.data({'id': 'a1'}, status: 201);
      final repository = HttpAccountRepository.fromDio(stub.dio);

      for (final type in AccountType.values) {
        await repository.create(
          name: 'Account',
          type: type,
          currencyCode: 'BRL',
          openingBalance: '0',
          institution: 'Neo Bank',
        );
      }

      expect(
        stub.requests.map(
          (request) => (request.data as Map<String, Object?>)['accountType'],
        ),
        [1, 2, 3, 4],
      );
      expect(
        (stub.requests.first.data as Map<String, Object?>)['institution'],
        'Neo Bank',
      );
    });

    test('Given the API refuses a duplicate name '
        'When an account is created '
        "Then the API's reason is the failure (UC-14 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['An account with that name already exists.']),
      );

      final result = await HttpAccountRepository.fromDio(stub.dio).create(
        name: 'Wallet',
        type: AccountType.cash,
        currencyCode: 'BRL',
        openingBalance: '0',
      );

      expect(
        result,
        const Failure<void>(
          message: 'An account with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('HttpAccountRepository.update', () {
    test('Given an edited account '
        'When it is saved '
        'Then it is put to its own address without a currency', () async {
      final stub = ApiStub.data({'id': 'a1'});

      final result = await HttpAccountRepository.fromDio(stub.dio).update(
        id: 'a1',
        name: 'Checking',
        type: AccountType.checking,
        institution: 'Old Bank',
      );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/accounts/a1');
      expect(stub.body, {
        'accountType': 1,
        'currencyCode': null,
        'institution': 'Old Bank',
        'name': 'Checking',
        'openingBalance': null,
        'ownerId': null,
      });
    });

    test('Given an account whose institution was removed '
        'When it is saved '
        'Then the institution travels as null, which clears it offline as '
        'online', () async {
      final stub = ApiStub.data({'id': 'a1'});

      await HttpAccountRepository.fromDio(stub.dio)
          .update(id: 'a1', name: 'Checking', type: AccountType.checking);

      expect(stub.body, containsPair('institution', null));
    });

    test('Given the API refuses the edit '
        'When it is saved '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(400, ['The name is required.']));

      final result = await HttpAccountRepository.fromDio(stub.dio)
          .update(id: 'a1', name: '', type: AccountType.other);

      expect(
        result,
        const Failure<void>(
          message: 'The name is required.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('HttpAccountRepository.delete', () {
    test('Given an account '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 'a1'});

      final result = await HttpAccountRepository.fromDio(stub.dio).delete('a1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/accounts/a1');
    });

    test('Given records still referencing the account '
        'When it is deleted '
        "Then the API's reason is the failure (UC-14 AF-05)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['The account still has transactions.']),
      );

      final result = await HttpAccountRepository.fromDio(stub.dio).delete('a1');

      expect(
        result,
        const Failure<void>(
          message: 'The account still has transactions.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When an account is deleted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpAccountRepository.fromDio(stub.dio).delete('a1');

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

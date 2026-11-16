import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

import '../../../support/api_stub.dart';

void main() {
  group('HttpCurrencyRepository.listSupported', () {
    test('Given the currencies the instance supports '
        'When they are listed '
        "Then each keeps the API's code, name and minor units, in order "
        '(UC-13, FR-PS-07)', () async {
      final stub = ApiStub.data({
        'currencies': [
          {'code': 'BRL', 'name': 'Brazilian real', 'minorUnitDigits': 2},
          {'code': 'JPY', 'name': 'Japanese yen', 'minorUnitDigits': 0},
          {'code': 'KWD', 'name': 'Kuwaiti dinar', 'minorUnitDigits': 3},
        ],
      });

      final result = await HttpCurrencyRepository.fromDio(stub.dio)
          .listSupported();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/currencies');
      final currencies = result.valueOrNull!;
      expect(
        [
          for (final currency in currencies)
            (currency.code, currency.name, currency.minorUnitDigits),
        ],
        [
          ('BRL', 'Brazilian real', 2),
          ('JPY', 'Japanese yen', 0),
          ('KWD', 'Kuwaiti dinar', 3),
        ],
      );
    });

    test('Given a currency with no name and no minor units '
        'When it is listed '
        'Then it is named by its code with two decimal places', () async {
      final stub = ApiStub.data({
        'currencies': [
          {'code': 'XYZ'},
        ],
      });

      final result = await HttpCurrencyRepository.fromDio(stub.dio)
          .listSupported();

      final currency = result.valueOrNull!.single;
      expect(currency.code, 'XYZ');
      expect(currency.name, 'XYZ');
      expect(currency.minorUnitDigits, 2);
    });

    test('Given a currency with no code '
        'When the currencies are listed '
        'Then it is left out and the rest are kept', () async {
      final stub = ApiStub.data({
        'currencies': [
          {'name': 'Nameless', 'minorUnitDigits': 2},
          {'code': 'EUR', 'name': 'Euro', 'minorUnitDigits': 2},
        ],
      });

      final result = await HttpCurrencyRepository.fromDio(stub.dio)
          .listSupported();

      expect(result.valueOrNull!.map((currency) => currency.code), ['EUR']);
    });

    test('Given an answer with no data or no list '
        'When the currencies are listed '
        'Then there are none', () async {
      for (final data in [null, <String, Object?>{}]) {
        final stub = ApiStub.data(data);

        final result = await HttpCurrencyRepository.fromDio(stub.dio)
            .listSupported();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      }
    });

    test('Given the API refuses the request '
        'When the currencies are listed '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(401, ['The session has expired.']));

      final result = await HttpCurrencyRepository.fromDio(stub.dio)
          .listSupported();

      expect(
        result,
        const Failure<List<SupportedCurrency>>(
          message: 'The session has expired.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the currencies are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCurrencyRepository.fromDio(stub.dio)
          .listSupported();

      expect(
        result,
        const Failure<List<SupportedCurrency>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}

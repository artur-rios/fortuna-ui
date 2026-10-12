import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/format/money_formatter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(initializeDateFormatting);

  group('MoneyFormatter', () {
    test('Given the same amount '
        'When it is formatted in each supported locale '
        'Then only the rendering differs, never the value (FR-PS-03)', () {
      final money = Money.parse('1234.56', 'USD');

      final us = MoneyFormatter('en_US').formatAmount(money);
      final br = MoneyFormatter('pt_BR').formatAmount(money);

      expect(us, '1,234.56');
      expect(br, '1.234,56');
      expect(money.asApiString, '1234.56');
    });

    test(
      'Given an amount with more decimals than the currency allows '
      'When it is formatted '
      'Then it is rounded for display only and the held value is unchanged',
      () {
        final money = Money.parse('10.567', 'USD');
        final formatter = MoneyFormatter('en_US');

        expect(formatter.formatAmount(money), '10.57');
        expect(money.asApiString, '10.567');
      },
    );

    test('Given a negative amount '
        'When it is formatted '
        "Then it carries the locale's own minus sign", () {
      expect(
        MoneyFormatter('en_US').formatAmount(Money.parse('-42.50', 'USD')),
        '-42.50',
      );
    });

    test('Given a large amount '
        'When it is formatted '
        'Then every group is separated', () {
      final money = Money.parse('9876543210.99', 'USD');

      expect(MoneyFormatter('en_US').formatAmount(money), '9,876,543,210.99');
      expect(MoneyFormatter('pt_BR').formatAmount(money), '9.876.543.210,99');
    });

    test('Given amounts below one '
        'When they are formatted '
        'Then the leading zero is kept', () {
      expect(
        MoneyFormatter('en_US').formatAmount(Money.parse('0.05', 'USD')),
        '0.05',
      );
    });

    test('Given an amount '
        'When it is formatted with its currency '
        'Then the symbol is present (FR-PS-04)', () {
      final formatted = MoneyFormatter('en_US')
          .format(Money.parse('12.00', 'USD'));

      expect(formatted, contains('12.00'));
      expect(formatted, contains(r'$'));
    });

    test('Given a value at the rounding boundary '
        'When it is formatted '
        'Then it rounds half away from zero rather than drifting', () {
      final formatter = MoneyFormatter('en_US');

      expect(formatter.formatAmount(Money.parse('2.345', 'USD')), '2.35');
      expect(formatter.formatAmount(Money.parse('2.344', 'USD')), '2.34');
    });

    test('Given a negative amount '
        'When it is formatted with its currency '
        'Then the sign leads, as the locale writes it, not wedged between the '
        'symbol and the digits', () {
      expect(
        MoneyFormatter('en_US').format(Money.parse('-1234.5', 'USD')),
        r'-$1,234.50',
      );
      expect(
        MoneyFormatter('pt_BR').format(Money.parse('-1234.5', 'BRL')),
        '-R\$\u00a01.234,50',
      );
    });

    test('Given an amount '
        'When it is formatted with its currency in pt-BR '
        "Then the locale's own spacing between symbol and number is used", () {
      expect(
        MoneyFormatter('pt_BR').format(Money.parse('1234.5', 'BRL')),
        'R\$\u00a01.234,50',
      );
    });

    test('Given a currency the locale has no symbol for '
        'When it is formatted '
        'Then its code is kept apart from the digits', () {
      expect(
        MoneyFormatter('en_US').format(Money.parse('12', 'XYZ')),
        'XYZ 12.00',
      );
    });

    test('Given a negative amount that rounds to zero '
        'When it is formatted '
        'Then no minus sign is shown on a zero', () {
      expect(
        MoneyFormatter('en_US').format(Money.parse('-0.001', 'USD')),
        r'$0.00',
      );
    });

    test(
      "Given the instance's own precision for a currency "
      'When the amount alone is formatted '
      'Then it rounds to that precision, as the symbol form does (FR-PS-06)',
      () {
        final formatter = MoneyFormatter('en_US', minorUnitDigits: {'USD': 3});
        final money = Money.parse('1.2345', 'USD');

        expect(formatter.formatAmount(money), '1.235');
        expect(formatter.format(money), r'$1.235');
      },
    );
  });
}

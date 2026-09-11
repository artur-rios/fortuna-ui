import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money_parser.dart';

void main() {
  final enUS = MoneyParser('en_US');
  final enGB = MoneyParser('en_GB');
  final en150 = MoneyParser('en_150');
  final ptBR = MoneyParser('pt_BR');

  group('MoneyParser in a dot-decimal locale', () {
    test('Given a plain amount '
        'When it is parsed '
        'Then it is the exact decimal it denotes', () {
      expect(enUS.parse('1234.56'), Decimal.parse('1234.56'));
      expect(enUS.parse('0.01'), Decimal.parse('0.01'));
      expect(enUS.parse('7'), Decimal.parse('7'));
    });

    test('Given grouping separators '
        'When it is parsed '
        'Then they are punctuation and carry no value', () {
      expect(enUS.parse('1,234.56'), Decimal.parse('1234.56'));
      expect(enUS.parse('1,234,567.89'), Decimal.parse('1234567.89'));
    });

    test('Given a leading minus '
        'When it is parsed '
        'Then the amount is negative', () {
      expect(enUS.parse('-1234.56'), Decimal.parse('-1234.56'));
    });
  });

  group('MoneyParser in a comma-decimal locale', () {
    test('Given an amount written the Brazilian way '
        'When it is parsed '
        'Then the comma is the decimal separator', () {
      expect(ptBR.parse('1234,56'), Decimal.parse('1234.56'));
      expect(ptBR.parse('0,01'), Decimal.parse('0.01'));
    });

    test('Given grouping dots and a decimal comma '
        'When it is parsed '
        'Then the dots are punctuation and the comma is the separator', () {
      expect(ptBR.parse('1.234,56'), Decimal.parse('1234.56'));
      expect(ptBR.parse('1.234.567,89'), Decimal.parse('1234567.89'));
    });
  });

  group('MoneyParser across locales (AF-08)', () {
    test('Given the same amount written as each locale writes it '
        'When each is parsed in its own locale '
        'Then the stored value is identical', () {
      final expected = Decimal.parse('1234.56');

      expect(enUS.parse('1,234.56'), expected);
      expect(enGB.parse('1,234.56'), expected);
      expect(en150.parse('1,234.56'), expected);
      expect(ptBR.parse('1.234,56'), expected);
    });

    test('Given an amount a double would not represent exactly '
        'When it is parsed in every locale '
        'Then every locale yields the same exact decimal', () {
      // 0.1 + 0.2 is the canonical floating-point failure. Held exactly here.
      expect(enUS.parse('0.1')! + enUS.parse('0.2')!, Decimal.parse('0.3'));
      expect(ptBR.parse('0,1')! + ptBR.parse('0,2')!, Decimal.parse('0.3'));
    });

    test('Given a large amount with more decimals than the currency shows '
        'When it is parsed '
        'Then every digit survives', () {
      expect(enUS.parse('9,876,543.219'), Decimal.parse('9876543.219'));
      expect(ptBR.parse('9.876.543,219'), Decimal.parse('9876543.219'));
    });
  });

  group('MoneyParser refusals (AF-01)', () {
    test('Given nothing at all '
        'When it is parsed '
        'Then it reads as no amount rather than as zero', () {
      expect(enUS.parse(''), isNull);
      expect(enUS.parse('   '), isNull);
    });

    test('Given something that is not a number '
        'When it is parsed '
        'Then it reads as no amount', () {
      expect(enUS.parse('abc'), isNull);
      expect(enUS.parse('12abc'), isNull);
      expect(enUS.parse(r'$12.00'), isNull);
      expect(enUS.parse('1.2.3'), isNull);
      expect(enUS.parse('--5'), isNull);
    });

    test('Given a separator the locale does not use as a decimal point '
        'When it is parsed in that locale '
        'Then it is read as the locale would read it, not guessed at', () {
      // In pt-BR a dot groups, so "1.2" is 12 — not one-point-two. The parser
      // follows the chosen locale rather than trying to detect intent.
      expect(ptBR.parse('1.2'), Decimal.parse('12'));
    });

    test('Given whitespace inside the number '
        'When it is parsed '
        'Then spaces used as grouping are tolerated', () {
      expect(enUS.parse('1 234.56'), Decimal.parse('1234.56'));
    });
  });

  group('MoneyParser.isPositive', () {
    test('Given an amount greater than zero '
        'When it is checked '
        'Then it is accepted', () {
      expect(enUS.isPositive('0.01'), isTrue);
      expect(ptBR.isPositive('0,01'), isTrue);
      expect(enUS.isPositive('1,000,000'), isTrue);
    });

    test('Given zero '
        'When it is checked '
        'Then it is refused although it parses perfectly well', () {
      expect(enUS.parse('0'), Decimal.zero);
      expect(enUS.isPositive('0'), isFalse);
      expect(enUS.isPositive('0.00'), isFalse);
      expect(ptBR.isPositive('0,00'), isFalse);
    });

    test('Given a negative amount or nothing '
        'When it is checked '
        'Then it is refused', () {
      expect(enUS.isPositive('-1.00'), isFalse);
      expect(enUS.isPositive(''), isFalse);
      expect(enUS.isPositive('abc'), isFalse);
    });
  });
}

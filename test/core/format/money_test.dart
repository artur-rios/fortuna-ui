import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';

void main() {
  group('Money', () {
    test('Given an amount a double cannot represent exactly '
        'When it is parsed and read back '
        'Then it is unchanged to the last digit', () {
      // 0.1 + 0.2 is the canonical float defect. These values are chosen so
      // that a double round trip anywhere in the type would show up here.
      const exact = '0.1';
      final money = Money.parse(exact, 'BRL');

      expect(money.asApiString, exact);
      expect(
        (Money.parse('0.1', 'BRL') + Money.parse('0.2', 'BRL')).asApiString,
        '0.3',
      );
    });

    test('Given a value with more precision than any binary float holds '
        'When it survives a parse and serialize round trip '
        'Then no precision is lost', () {
      const value = '12345678901234567890.123456789';

      expect(Money.parse(value, 'USD').asApiString, value);
    });

    test('Given two amounts in the same currency '
        'When they are added '
        'Then the sum is exact and keeps the currency', () {
      final sum = Money.parse('99.99', 'USD') + Money.parse('0.01', 'USD');

      // Asserted numerically, not as a string: Decimal normalizes trailing
      // zeros, so "100.00" serializes as "100". That is the same exact value —
      // asserting the string form would be testing the rendering, and the
      // rendering is MoneyFormatter's job, not this type's.
      expect(sum.amount, Decimal.parse('100'));
      expect(sum.currencyCode, 'USD');
    });

    test('Given two amounts in different currencies '
        'When they are added '
        'Then the operation is refused rather than converted (BR-07)', () {
      expect(
        () => Money.parse('10.00', 'USD') + Money.parse('10.00', 'BRL'),
        throwsArgumentError,
      );
    });

    test('Given two amounts in different currencies '
        'When they are compared '
        'Then the comparison is refused rather than answered', () {
      expect(
        () =>
            Money.parse('10.00', 'USD').compareTo(Money.parse('10.00', 'BRL')),
        throwsArgumentError,
      );
    });

    test('Given a projected amount '
        'When it is combined with a recorded one '
        'Then the result is marked projected, so the distinction survives', () {
      final projected = Money.parse('5.00', 'USD').asProjected();
      final recorded = Money.parse('5.00', 'USD');

      expect((recorded + projected).isProjected, isTrue);
      expect((recorded + recorded).isProjected, isFalse);
    });

    test('Given two amounts in the same currency '
        'When one is subtracted from the other '
        'Then the difference is exact, may go below zero and keeps the '
        'currency', () {
      final difference = Money.parse('0.3', 'BRL') - Money.parse('0.1', 'BRL');
      final negative = Money.parse('0.01', 'BRL') - Money.parse('0.02', 'BRL');

      expect(difference.amount, Decimal.parse('0.2'));
      expect(difference.currencyCode, 'BRL');
      expect(negative.amount, Decimal.parse('-0.01'));
      expect(negative.isPositive, isFalse);
    });

    test('Given two amounts in different currencies '
        'When one is subtracted from the other '
        'Then the operation is refused rather than converted (BR-07)', () {
      expect(
        () => Money.parse('10.00', 'USD') - Money.parse('10.00', 'BRL'),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('"-" to USD and BRL'),
          ),
        ),
      );
    });

    test('Given a projected amount '
        'When a recorded one is subtracted from it, or it from a recorded one '
        'Then the result is marked projected either way', () {
      final projected = Money.parse('5.00', 'USD').asProjected();
      final recorded = Money.parse('2.00', 'USD');

      expect((projected - recorded).isProjected, isTrue);
      expect((recorded - projected).isProjected, isTrue);
      expect((recorded - recorded).isProjected, isFalse);
    });

    test('Given a recorded amount '
        'When it is marked projected '
        'Then the amount and currency are unchanged', () {
      final projected = Money.parse('12.34', 'EUR').asProjected();

      expect(projected.amount, Decimal.parse('12.34'));
      expect(projected.currencyCode, 'EUR');
      expect(projected.isProjected, isTrue);
    });

    test('Given amounts in the same currency '
        'When they are compared '
        'Then they order by value, and equal values compare as equal', () {
      final small = Money.parse('9.99', 'USD');
      final large = Money.parse('10.00', 'USD');

      expect(small.compareTo(large), lessThan(0));
      expect(large.compareTo(small), greaterThan(0));
      expect(large.compareTo(Money.parse('10', 'USD')), 0);
      expect([large, small]..sort(), [small, large]);
    });

    test('Given two equal amounts '
        'When they are hashed '
        'Then they hash alike, so they can key a map', () {
      expect(
        Money.parse('1.00', 'USD').hashCode,
        Money.parse('1', 'USD').hashCode,
      );
      expect(
        {Money.parse('1.00', 'USD'): 'one'}[Money.parse('1', 'USD')],
        'one',
      );
    });

    test('Given a recorded and a projected amount '
        'When they are written out for a log '
        'Then each names its currency, and only the projection says so', () {
      expect(Money.parse('10.50', 'USD').toString(), 'USD 10.5');
      expect(
        Money.parse('10.50', 'USD').asProjected().toString(),
        'USD 10.5 (projected)',
      );
    });

    test('Given a malformed amount '
        'When it is parsed '
        'Then it throws rather than guessing at a value', () {
      expect(() => Money.parse('not a number', 'USD'), throwsFormatException);
    });

    test('Given a zero amount '
        'When it is asked whether it is positive '
        'Then it is not — forms requiring "greater than zero" reject it', () {
      expect(Money.zero('USD').isPositive, isFalse);
      expect(Money.parse('0.01', 'USD').isPositive, isTrue);
    });

    test('Given the money type '
        'When its surface is examined '
        'Then the amount is a Decimal, never a double', () {
      expect(Money.parse('1.00', 'USD').amount, isA<Decimal>());
    });

    test('Given two equal amounts '
        'When they are compared for equality '
        'Then currency and projection are part of the identity', () {
      expect(Money.parse('1.00', 'USD'), Money.parse('1.00', 'USD'));
      expect(Money.parse('1.00', 'USD'), isNot(Money.parse('1.00', 'BRL')));
      expect(
        Money.parse('1.00', 'USD'),
        isNot(Money.parse('1.00', 'USD').asProjected()),
      );
    });
  });
}

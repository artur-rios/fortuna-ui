/// The application's only representation of a monetary amount (IR-05, BR-06).
///
/// An exact [Decimal] and its currency, together. There is deliberately **no**
/// conversion to or from `double` on this type — not a getter, not a factory,
/// not a helper "just for charts". `tool/check_boundaries.dart` fails the build
/// if one appears (IR-14), because a convenient `toDouble()` is exactly the
/// change that would otherwise pass review and silently corrupt a history the
/// API stored perfectly.
///
/// An amount is never carried without its currency: a bare number invites the
/// arithmetic `BR-07` forbids, where two currencies are summed because nothing
/// in the type said they could not be.
library;

import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';

/// An exact monetary amount in a single currency.
@immutable
final class Money implements Comparable<Money> {
  const Money({
    required this.amount,
    required this.currencyCode,
    this.isProjected = false,
  });

  /// Parses the API's representation, which is a **string** precisely so that
  /// no JSON number ever passes through a binary float on the way here.
  ///
  /// Throws [FormatException] on anything that is not an exact decimal: a
  /// malformed amount is a contract violation, not a value to guess at.
  factory Money.parse(
    String amount,
    String currencyCode, {
    bool isProjected = false,
  }) => Money(
    amount: Decimal.parse(amount),
    currencyCode: currencyCode,
    isProjected: isProjected,
  );

  /// Zero in [currencyCode]. Used for an empty total, never as a fallback for a
  /// figure that failed to load — that is an error state, not a zero.
  factory Money.zero(String currencyCode) =>
      Money(amount: Decimal.zero, currencyCode: currencyCode);

  /// The exact amount. Never a `double`, at any point.
  final Decimal amount;

  /// The ISO 4217 code this amount is denominated in.
  final String currencyCode;

  /// Whether this figure is a forecast rather than something recorded.
  ///
  /// Carried on the value itself so that a view mixing projections with records
  /// cannot lose the distinction on the way to the screen (`BR-11`,
  /// `FR-PS-12`).
  final bool isProjected;

  /// This amount serialized for the API — a string, for the reason
  /// [Money.parse] takes one.
  ///
  /// Normalized, not fixed-point: `100.00` serializes as `100`, which is the
  /// same exact value. Do not assert on this for display purposes — padding an
  /// amount to a currency's minor units is [MoneyFormatter]'s job, and doing it
  /// here would put a presentation decision inside the value.
  String get asApiString => amount.toString();

  /// Whether the amount is greater than zero, which most forms require.
  bool get isPositive => amount > Decimal.zero;

  /// Adds two amounts of the **same** currency.
  ///
  /// Throws [ArgumentError] on a currency mismatch rather than converting:
  /// an implied conversion is an invented number (`BR-07`). Conversion is the
  /// API's, and it records the rate it used.
  Money operator +(Money other) {
    _assertSameCurrency(other, '+');
    return Money(
      amount: amount + other.amount,
      currencyCode: currencyCode,
      isProjected: isProjected || other.isProjected,
    );
  }

  /// Subtracts an amount of the same currency. Throws on a mismatch, as [+].
  Money operator -(Money other) {
    _assertSameCurrency(other, '-');
    return Money(
      amount: amount - other.amount,
      currencyCode: currencyCode,
      isProjected: isProjected || other.isProjected,
    );
  }

  /// Marks this figure as projected, for a view that mixes it with records.
  Money asProjected() =>
      Money(amount: amount, currencyCode: currencyCode, isProjected: true);

  void _assertSameCurrency(Money other, String operation) {
    if (other.currencyCode != currencyCode) {
      throw ArgumentError(
        'Cannot apply "$operation" to $currencyCode and ${other.currencyCode}: '
        'amounts in different currencies are never combined without an '
        'explicit conversion by the API (BR-07).',
      );
    }
  }

  @override
  int compareTo(Money other) {
    _assertSameCurrency(other, 'compareTo');
    return amount.compareTo(other.amount);
  }

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.amount == amount &&
      other.currencyCode == currencyCode &&
      other.isProjected == isProjected;

  @override
  int get hashCode => Object.hash(amount, currencyCode, isProjected);

  @override
  String toString() =>
      '$currencyCode ${amount.toString()}${isProjected ? ' (projected)' : ''}';
}

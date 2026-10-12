/// Locale-aware formatting for [Money] (IR-06, FR-PS-02, FR-PS-06).
///
/// The awkward part, and the reason this is hand-rolled rather than a call to
/// `NumberFormat.currency().format()`: `intl` formats `num`, and putting a
/// monetary amount through `num` is precisely what `BR-06` forbids. So this
/// takes the *symbols* from `intl` — the grouping separator, the decimal
/// separator, the currency symbol and the currency's minor-unit precision, all
/// of which are genuinely locale data — and assembles the digits itself from
/// the exact [Decimal].
///
/// Rounding happens here and only here, at display, to the currency's own
/// precision (`FR-PS-06`). The rounded value is never returned to a caller, so
/// it can never be carried onward into a total that then fails to match the sum
/// of its parts.
library;

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

import 'money.dart';

/// Formats [Money] for display in a given locale.
class MoneyFormatter {
  MoneyFormatter(this.locale, {this.minorUnitDigits = const {}});

  /// The BCP 47 locale tag, one of the four the application supports.
  final String locale;

  /// Minor-unit precision per currency code, as the **API** reports it.
  ///
  /// Consulted before `intl`'s own table, because `FR-PS-06` says rounding is
  /// to the currency's own precision and the instance is the authority on the
  /// currencies it accepts. A library's table and an instance's list can
  /// disagree; when they do, the instance is right.
  final Map<String, int> minorUnitDigits;

  /// Formats [money] with its currency symbol, e.g. `R$ 1.234,56` in `pt-BR`
  /// and `-$1,234.56` in `en-US`.
  String format(Money money) {
    final pattern = NumberFormat.simpleCurrency(
      locale: locale,
      name: money.currencyCode,
    );
    final digits = _digitsFor(money.currencyCode, pattern.decimalDigits);
    final rounded = money.amount.round(scale: digits);
    final negative = rounded < Decimal.zero;
    final number = _digits(rounded.abs(), digits);

    // Where the sign, the symbol and the spacing between them and the number
    // go is locale data: `-$1,234.56` in `en-US`, `-R$ 1.234,56` in `pt-BR`.
    // It is read from a constant `intl` formats — never from the amount, which
    // does not pass through `num` — and the exact digits are put where the
    // constant's digits were.
    final template = pattern.format(negative ? -1 : 1);
    final first = template.indexOf(_digit);
    final last = template.lastIndexOf(_digit);
    var prefix = template.substring(0, first);
    var suffix = template.substring(last + 1);

    // A symbol that is a code rather than a sign (`XYZ`, or any currency the
    // locale has no symbol for) is kept apart from the digits, as CLDR's
    // currency spacing does; `intl` does not apply that rule itself.
    if (prefix.isNotEmpty && _letter.hasMatch(prefix[prefix.length - 1])) {
      prefix = '$prefix ';
    }
    if (suffix.isNotEmpty && _letter.hasMatch(suffix[0])) {
      suffix = ' $suffix';
    }

    return '$prefix$number$suffix';
  }

  /// Formats the amount alone, with no currency symbol — for a column whose
  /// header already names the currency, or a chart axis.
  ///
  /// Rounded to the same precision [format] uses: the instance's figure for
  /// the currency where it has one, unless [decimalDigits] says otherwise.
  String formatAmount(Money money, {int? decimalDigits}) {
    final digits =
        decimalDigits ??
        _digitsFor(
          money.currencyCode,
          NumberFormat.simpleCurrency(
            locale: locale,
            name: money.currencyCode,
          ).decimalDigits,
        );

    final rounded = money.amount.round(scale: digits);
    final body = _digits(rounded.abs(), digits);

    return rounded < Decimal.zero
        ? '${NumberFormat.decimalPattern(locale).symbols.MINUS_SIGN}$body'
        : body;
  }

  /// [amount], which is not negative, with [digits] decimals and the locale's
  /// grouping and decimal separators.
  String _digits(Decimal amount, int digits) {
    final symbols = NumberFormat.decimalPattern(locale).symbols;
    final fixed = amount.toStringAsFixed(digits);

    final parts = fixed.split('.');
    final grouped = _group(parts.first, symbols.GROUP_SEP);
    return parts.length > 1
        ? '$grouped${symbols.DECIMAL_SEP}${parts[1]}'
        : grouped;
  }

  static final _digit = RegExp(r'\d');
  static final _letter = RegExp(r'\p{L}', unicode: true);

  /// The precision for [currencyCode]: the API's figure where it has one, then
  /// the formatting library's, then two.
  int _digitsFor(String currencyCode, int? fromIntl) =>
      minorUnitDigits[currencyCode] ?? fromIntl ?? 2;

  /// Inserts [groupSeparator] every three digits from the right.
  String _group(String integerDigits, String groupSeparator) {
    final buffer = StringBuffer();
    for (var i = 0; i < integerDigits.length; i++) {
      if (i > 0 && (integerDigits.length - i) % 3 == 0) {
        buffer.write(groupSeparator);
      }
      buffer.write(integerDigits[i]);
    }
    return buffer.toString();
  }
}

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
  MoneyFormatter(this.locale);

  /// The BCP 47 locale tag, one of the four the application supports.
  final String locale;

  /// Formats [money] with its currency symbol, e.g. `R$ 1.234,56` in `pt-BR`
  /// and `$1,234.56` in `en-US`.
  String format(Money money) {
    final pattern = NumberFormat.simpleCurrency(
      locale: locale,
      name: money.currencyCode,
    );
    final symbol = pattern.currencySymbol;
    final digits = pattern.decimalDigits ?? 2;
    final number = formatAmount(money, decimalDigits: digits);

    // Where the symbol precedes the number in this locale, `intl` reports a
    // pattern beginning with the currency placeholder. Following it keeps
    // `pt-BR`'s "R$ 1.234,56" and `en-US`'s "$1,234.56" both correct.
    final symbolFirst = pattern.format(0).trimLeft().startsWith(symbol);
    final separator = symbol.length > 1 ? ' ' : '';
    return symbolFirst ? '$symbol$separator$number' : '$number $symbol';
  }

  /// Formats the amount alone, with no currency symbol — for a column whose
  /// header already names the currency, or a chart axis.
  String formatAmount(Money money, {int? decimalDigits}) {
    final digits =
        decimalDigits ??
        (NumberFormat.simpleCurrency(
              locale: locale,
              name: money.currencyCode,
            ).decimalDigits ??
            2);

    final symbols = NumberFormat.decimalPattern(locale).symbols;
    final rounded = money.amount.round(scale: digits);
    final negative = rounded < Decimal.zero;
    final fixed = rounded.abs().toStringAsFixed(digits);

    final parts = fixed.split('.');
    final grouped = _group(parts.first, symbols.GROUP_SEP);
    final body = parts.length > 1
        ? '$grouped${symbols.DECIMAL_SEP}${parts[1]}'
        : grouped;

    return negative ? '${symbols.MINUS_SIGN}$body' : body;
  }

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

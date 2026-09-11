/// Locale-aware parsing of a typed amount (FR-MM-02, UC-19 AF-08).
///
/// The inverse of [MoneyFormatter], and hand-rolled for the same reason: `intl`
/// parses to `num`, and putting a monetary amount through `num` is precisely
/// what `BR-06` forbids. So this takes the *symbols* from `intl` — the grouping
/// separator, the decimal separator and the minus sign, all genuinely locale
/// data — and assembles an exact [Decimal] from the digits itself.
///
/// `AF-08` is the requirement this exists to satisfy: `1.234,56` typed in
/// `pt-BR` and `1,234.56` typed in `en-US` are the same amount, and both must
/// store the identical exact value. A parser that assumed one convention would
/// silently read the other's thousands separator as a decimal point — turning
/// R$ 1.234,56 into 1.23, which is the kind of defect that looks like a typo
/// and costs real money.
library;

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

/// Parses what a user typed into an exact [Decimal], in a given locale.
class MoneyParser {
  MoneyParser(this.locale);

  /// The BCP 47 locale tag, one of the four the application supports.
  final String locale;

  /// The exact amount [text] denotes, or `null` where it denotes none.
  ///
  /// `null` means "not a number" — which `AF-01` reports as a form error
  /// rather than treating as zero. Returning zero for unparseable input is the
  /// mistake this signature exists to prevent: zero is a value a user might
  /// legitimately mean, and it cannot also stand for "I could not read that".
  Decimal? parse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final symbols = NumberFormat.decimalPattern(locale).symbols;
    final decimalSeparator = symbols.DECIMAL_SEP;
    final groupSeparator = symbols.GROUP_SEP;

    var body = trimmed;
    var negative = false;

    // A leading minus in either the locale's sign or the plain ASCII one. A
    // user typing on a keyboard produces the latter whatever their locale.
    for (final sign in {symbols.MINUS_SIGN, '-'}) {
      if (sign.isNotEmpty && body.startsWith(sign)) {
        negative = true;
        body = body.substring(sign.length);
        break;
      }
    }

    // Grouping separators carry no value — they are punctuation for the eye.
    // Removed before anything else so `1.234,56` and `1234,56` take the same
    // path from here.
    if (groupSeparator.isNotEmpty) {
      body = body.replaceAll(groupSeparator, '');
    }

    // Non-breaking spaces are a grouping separator in some locales, and are
    // what a paste from a spreadsheet often carries.
    body = body.replaceAll(' ', '').replaceAll(' ', '');

    if (decimalSeparator.isNotEmpty) {
      body = body.replaceAll(decimalSeparator, '.');
    }

    // Exactly one optional decimal point, digits on at least one side of it,
    // and nothing else. Anything the shape does not admit is not a number —
    // including a second separator, a stray letter or a currency symbol.
    if (!RegExp(r'^\d+(\.\d+)?$|^\.\d+$|^\d+\.$').hasMatch(body)) return null;

    // `Decimal.parse` wants digits on both sides.
    if (body.startsWith('.')) body = '0$body';
    if (body.endsWith('.')) body = body.substring(0, body.length - 1);

    final parsed = Decimal.tryParse(body);
    if (parsed == null) return null;

    return negative ? -parsed : parsed;
  }

  /// Whether [text] denotes an amount greater than zero (`AF-01`, `FR-MM-03`).
  ///
  /// Distinct from [parse] returning non-null: `0` parses perfectly well and
  /// is still refused, because a transaction of nothing is not a transaction.
  bool isPositive(String text) {
    final parsed = parse(text);
    return parsed != null && parsed > Decimal.zero;
  }
}

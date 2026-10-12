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

    // A decimal separator at most once; whatever follows it is the fraction.
    final pieces = decimalSeparator.isEmpty
        ? [body]
        : body.split(decimalSeparator);
    if (pieces.length > 2) return null;

    final integer = _integerDigits(pieces.first, groupSeparator);
    final fraction = pieces.length == 2 ? pieces.last : '';
    if (integer == null || !_digits.hasMatch(fraction)) return null;

    // Digits on at least one side of the separator: `12`, `12,` and `,5` are
    // numbers, a separator on its own is not.
    if (integer.isEmpty && fraction.isEmpty) return null;

    // `Decimal.parse` wants digits on both sides.
    body =
        '${integer.isEmpty ? '0' : integer}'
        '${fraction.isEmpty ? '' : '.$fraction'}';

    final parsed = Decimal.tryParse(body);
    if (parsed == null) return null;

    return negative ? -parsed : parsed;
  }

  static final _digits = RegExp(r'^\d*$');

  /// Grouping as people write it: the separator, or a space — a plain one or
  /// the non-breaking ones a paste from a spreadsheet or another application
  /// often carries.
  static String _groupingPattern(String groupSeparator) =>
      '[${RegExp.escape(groupSeparator)}\u0020\u00A0\u202F]';

  /// The integer digits of [text] with its grouping removed, or `null` where
  /// the grouping is not where the locale puts it.
  ///
  /// Grouping carries no value, but it does carry meaning: it only ever
  /// separates thousands. A separator anywhere else means the text was written
  /// in another convention — `10.50` typed in `pt-BR`, or `1,5` in `en-US` —
  /// and reading it anyway silently multiplies the amount by a hundred or ten.
  /// Such text is refused as unreadable rather than guessed at (`AF-01`).
  static String? _integerDigits(String text, String groupSeparator) {
    final groups = text.split(RegExp(_groupingPattern(groupSeparator)));
    if (groups.length == 1) {
      return _digits.hasMatch(text) ? text : null;
    }

    final first = groups.first;
    if (first.isEmpty || first.length > 3 || !_digits.hasMatch(first)) {
      return null;
    }
    for (final group in groups.skip(1)) {
      if (group.length != 3 || !_digits.hasMatch(group)) return null;
    }

    return groups.join();
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

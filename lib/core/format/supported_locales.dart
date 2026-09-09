/// The four locales this application supports (IR-06, FR-PS-01).
///
/// `en-150` is English as used in Europe — the standard code for what the
/// brainstorm called "EU English". It differs from `en-GB` in number and date
/// formatting rather than in wording, which is precisely the kind of difference
/// that matters in a finance application and nowhere else.
library;

import 'dart:ui' show Locale;

abstract final class SupportedLocales {
  static const enUS = Locale('en', 'US');
  static const enGB = Locale('en', 'GB');

  /// English (Europe). `150` is the UN M.49 region code for Europe.
  static const en150 = Locale('en', '150');
  static const ptBR = Locale('pt', 'BR');

  static const List<Locale> all = [enUS, enGB, en150, ptBR];

  /// The fallback when nothing the platform asks for is supported.
  static const Locale fallback = enUS;

  /// The BCP 47 tag for [locale], as `intl` expects it.
  static String tagOf(Locale locale) =>
      '${locale.languageCode}_${locale.countryCode}';

  /// Resolves the platform's preferred locales against [all].
  ///
  /// Prefers an exact language-and-region match, then any locale sharing the
  /// language, then [fallback]. Returning the platform's own locale unchanged
  /// would leave formatting to a locale this application has no data for.
  static Locale resolve(List<Locale>? preferred, Iterable<Locale> supported) {
    for (final locale in preferred ?? const <Locale>[]) {
      for (final candidate in all) {
        if (candidate.languageCode == locale.languageCode &&
            candidate.countryCode == locale.countryCode) {
          return candidate;
        }
      }
    }

    for (final locale in preferred ?? const <Locale>[]) {
      for (final candidate in all) {
        if (candidate.languageCode == locale.languageCode) return candidate;
      }
    }

    return fallback;
  }

  /// Parses a stored preference tag such as `pt_BR` back to a locale.
  static Locale? tryParse(String? tag) {
    if (tag == null) return null;
    for (final candidate in all) {
      if (tagOf(candidate) == tag) return candidate;
    }
    return null;
  }
}

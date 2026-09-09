import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/supported_locales.dart';

void main() {
  group('SupportedLocales', () {
    test('Given the supported set '
        'When it is listed '
        'Then it is exactly the four the specification names (FR-PS-01)', () {
      expect(SupportedLocales.all, hasLength(4));
      expect(SupportedLocales.all.map(SupportedLocales.tagOf).toList(), [
        'en_US',
        'en_GB',
        'en_150',
        'pt_BR',
      ]);
    });

    test('Given a platform locale that is supported exactly '
        'When it is resolved '
        'Then that locale is chosen', () {
      expect(
        SupportedLocales.resolve(const [
          Locale('pt', 'BR'),
        ], SupportedLocales.all),
        SupportedLocales.ptBR,
      );
    });

    test('Given a platform locale sharing only the language '
        'When it is resolved '
        'Then a locale of that language is chosen over the fallback', () {
      expect(
        SupportedLocales.resolve(const [
          Locale('pt', 'PT'),
        ], SupportedLocales.all),
        SupportedLocales.ptBR,
      );
    });

    test('Given a platform locale that is not supported at all '
        'When it is resolved '
        'Then the fallback is chosen rather than the unsupported locale', () {
      expect(
        SupportedLocales.resolve(const [
          Locale('ja', 'JP'),
        ], SupportedLocales.all),
        SupportedLocales.fallback,
      );
    });

    test('Given no platform preference at all '
        'When it is resolved '
        'Then the fallback is chosen', () {
      expect(
        SupportedLocales.resolve(null, SupportedLocales.all),
        SupportedLocales.fallback,
      );
      expect(
        SupportedLocales.resolve(const [], SupportedLocales.all),
        SupportedLocales.fallback,
      );
    });

    test('Given a stored preference tag '
        'When it is parsed '
        'Then it round-trips, and an unknown tag is null', () {
      for (final locale in SupportedLocales.all) {
        expect(
          SupportedLocales.tryParse(SupportedLocales.tagOf(locale)),
          locale,
        );
      }
      expect(SupportedLocales.tryParse('ja_JP'), isNull);
      expect(SupportedLocales.tryParse(null), isNull);
    });
  });
}

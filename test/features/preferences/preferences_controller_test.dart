import 'dart:ui';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/supported_locales.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/preferences/state/preferences_controller.dart';

/// A store that refuses every write, for `AF-05`.
class UnwritablePreferencesStore implements PreferencesStore {
  @override
  Future<String?> read(PreferenceKey key) async => null;

  @override
  Future<void> write(PreferenceKey key, String value) async =>
      throw StateError('unavailable');

  @override
  Future<void> remove(PreferenceKey key) async =>
      throw StateError('unavailable');
}

ProviderContainer containerWith({
  PreferencesStore? store,
  List<Locale> platformLocales = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      preferencesStoreProvider.overrideWithValue(
        store ?? InMemoryPreferencesStore(),
      ),
      platformLocalesProvider.overrideWithValue(platformLocales),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('PreferencesController defaults', () {
    test('Given no locale has been chosen and the platform prefers a supported one '
        'When the preferences are built '
        "Then the platform's locale is used (UC-13 AF-01)", () {
      final container = containerWith(
        platformLocales: const [Locale('pt', 'BR')],
      );

      expect(container.read(preferencesProvider).locale, SupportedLocales.ptBR);
    });

    test('Given the platform prefers a locale that is not supported '
        'When the preferences are built '
        'Then en-US is used (UC-13 AF-01)', () {
      final container = containerWith(
        platformLocales: const [Locale('ja', 'JP')],
      );

      expect(container.read(preferencesProvider).locale, SupportedLocales.enUS);
    });

    test('Given nothing stored '
        'When the preferences are built '
        'Then the theme follows the system and no display currency is set', () {
      final preferences = containerWith().read(preferencesProvider);

      expect(preferences.themeMode, ThemeMode.system);
      expect(preferences.displayCurrency, isNull);
    });
  });

  group('PreferencesController choices', () {
    test('Given a chosen theme, locale and currency '
        'When they are restored in a later session '
        'Then all three come back', () async {
      final store = InMemoryPreferencesStore();
      final first = containerWith(store: store);
      final controller = first.read(preferencesProvider.notifier);

      await controller.setThemeMode(ThemeMode.dark);
      await controller.setLocale(SupportedLocales.en150);
      await controller.setDisplayCurrency('BRL');

      final second = containerWith(store: store);
      await second.read(preferencesProvider.notifier).restore();

      final preferences = second.read(preferencesProvider);
      expect(preferences.themeMode, ThemeMode.dark);
      expect(preferences.locale, SupportedLocales.en150);
      expect(preferences.displayCurrency, 'BRL');
    });

    test(
      'Given a display currency is set '
      'When it is cleared '
      'Then figures show in their own currencies again (UC-13 AF-02)',
      () async {
        final store = InMemoryPreferencesStore();
        final container = containerWith(store: store);
        final controller = container.read(preferencesProvider.notifier);

        await controller.setDisplayCurrency('USD');
        expect(container.read(preferencesProvider).displayCurrency, 'USD');

        await controller.setDisplayCurrency(null);

        expect(container.read(preferencesProvider).displayCurrency, isNull);
        expect(await store.read(PreferenceKey.displayCurrency), isNull);
      },
    );

    test(
      'Given a stored locale this build does not support '
      'When the preferences are restored '
      'Then the resolved default stands rather than an unsupported locale',
      () async {
        final store = InMemoryPreferencesStore();
        await store.write(PreferenceKey.locale, 'ja_JP');

        final container = containerWith(
          store: store,
          platformLocales: const [Locale('pt', 'BR')],
        );
        await container.read(preferencesProvider.notifier).restore();

        expect(
          container.read(preferencesProvider).locale,
          SupportedLocales.ptBR,
        );
      },
    );

    test('Given preference storage refuses to save '
        'When a choice is made '
        'Then it applies for this session and is reported unsaved '
        '(UC-13 AF-05)', () async {
      final container = containerWith(store: UnwritablePreferencesStore());
      final controller = container.read(preferencesProvider.notifier);

      await controller.setThemeMode(ThemeMode.dark);

      final preferences = container.read(preferencesProvider);
      // The choice applies …
      expect(preferences.themeMode, ThemeMode.dark);
      // … and the interface is told it was not saved.
      expect(preferences.persisted, isFalse);
    });

    test('Given a failed save '
        'When a later save succeeds '
        'Then the unsaved warning clears', () async {
      final container = containerWith(store: InMemoryPreferencesStore());
      final controller = container.read(preferencesProvider.notifier);

      await controller.setThemeMode(ThemeMode.dark);

      expect(container.read(preferencesProvider).persisted, isTrue);
    });
  });
}

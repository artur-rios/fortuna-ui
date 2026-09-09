/// The user's presentation choices (UC-13).
///
/// Theme, locale and display currency. All three are presentation: none of them
/// changes a value, only how it reads (`FR-PS-03`). None of them is a
/// credential, which is why they live in ordinary preference storage and the
/// token does not (`FR-PS-09`).
library;

import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/config/instance_config.dart';
import '../../../core/format/supported_locales.dart';
import '../../../core/storage/preferences_store.dart';

@immutable
class Preferences {
  const Preferences({
    required this.themeMode,
    required this.locale,
    this.displayCurrency,
    this.persisted = true,
  });

  final ThemeMode themeMode;

  /// The chosen locale. Never null: `AF-01` resolves the platform's preference
  /// against the supported four, falling back to `en-US`.
  final Locale locale;

  /// The currency the user reads figures in, or `null` for "each in its own"
  /// (`AF-02`).
  final String? displayCurrency;

  /// Whether the last change reached storage.
  ///
  /// `AF-05`: when preference storage is unavailable the choices still apply
  /// for this session, and the interface says they could not be saved rather
  /// than silently forgetting them at the next start.
  final bool persisted;

  Preferences copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    String? displayCurrency,
    bool clearDisplayCurrency = false,
    bool? persisted,
  }) => Preferences(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
    displayCurrency: clearDisplayCurrency
        ? null
        : displayCurrency ?? this.displayCurrency,
    persisted: persisted ?? this.persisted,
  );
}

/// The platform's preferred locales, injected so tests need no platform.
final platformLocalesProvider = Provider<List<Locale>>(
  (ref) => const <Locale>[],
);

final preferencesProvider =
    NotifierProvider<PreferencesController, Preferences>(
      PreferencesController.new,
    );

class PreferencesController extends Notifier<Preferences> {
  @override
  Preferences build() => Preferences(
    themeMode: ThemeMode.system,
    // AF-01, applied before anything is read from storage: the platform's
    // locale where it is one of the four, otherwise en-US.
    locale: SupportedLocales.resolve(
      ref.watch(platformLocalesProvider),
      SupportedLocales.all,
    ),
  );

  /// Loads the stored choices, keeping the resolved defaults for anything
  /// absent or unrecognized.
  Future<void> restore() async {
    final store = ref.read(preferencesStoreProvider);

    try {
      final theme = await store.read(PreferenceKey.themeMode);
      final locale = await store.read(PreferenceKey.locale);
      final currency = await store.read(PreferenceKey.displayCurrency);

      state = state.copyWith(
        themeMode: _themeFrom(theme),
        locale: SupportedLocales.tryParse(locale),
        displayCurrency: currency,
      );
    } on Object {
      // AF-05 at start-up: the defaults stand, and nothing is reported yet —
      // the user has not asked for anything to be saved.
      state = state.copyWith(persisted: false);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode, persisted: true);
    await _write(PreferenceKey.themeMode, mode.name);
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale, persisted: true);
    await _write(PreferenceKey.locale, SupportedLocales.tagOf(locale));
  }

  /// Sets the display currency, or clears it when [code] is `null` (`AF-02`).
  Future<void> setDisplayCurrency(String? code) async {
    state = state.copyWith(
      displayCurrency: code,
      clearDisplayCurrency: code == null,
      persisted: true,
    );

    if (code == null) {
      await _remove(PreferenceKey.displayCurrency);
    } else {
      await _write(PreferenceKey.displayCurrency, code);
    }
  }

  /// Writes a preference, recording an unavailable store rather than throwing.
  ///
  /// The state is set **before** this runs, so the choice applies immediately
  /// either way — which is what `AF-05` means by the choices applying for the
  /// session even when they cannot be saved.
  Future<void> _write(PreferenceKey key, String value) async {
    try {
      await ref.read(preferencesStoreProvider).write(key, value);
    } on Object {
      state = state.copyWith(persisted: false);
    }
  }

  Future<void> _remove(PreferenceKey key) async {
    try {
      await ref.read(preferencesStoreProvider).remove(key);
    } on Object {
      state = state.copyWith(persisted: false);
    }
  }

  static ThemeMode? _themeFrom(String? value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    'system' => ThemeMode.system,
    _ => null,
  };
}

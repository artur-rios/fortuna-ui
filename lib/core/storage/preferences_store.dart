/// Preference storage (IR-07, FR-PS-09).
///
/// Presentation choices only — theme, locale, display currency, and the
/// self-hosted instance address. **Never a token and never a credential**;
/// those belong in secure storage, and the separation is the point of having
/// two stores rather than one.
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Reads and writes the user's non-sensitive preferences.
abstract interface class PreferencesStore {
  Future<String?> read(PreferenceKey key);
  Future<void> write(PreferenceKey key, String value);
  Future<void> remove(PreferenceKey key);
}

/// The preferences this application stores. An enum rather than free strings so
/// that a token cannot be smuggled in under an ad-hoc key.
enum PreferenceKey {
  themeMode('fortuna.preference.themeMode'),
  locale('fortuna.preference.locale'),
  displayCurrency('fortuna.preference.displayCurrency'),
  instanceAddress('fortuna.preference.instanceAddress');

  const PreferenceKey(this.storageKey);

  final String storageKey;
}

/// The platform-backed implementation.
class SharedPreferencesStore implements PreferencesStore {
  SharedPreferencesStore(this._preferences);

  /// Opens the platform store. Called once, during start-up.
  static Future<SharedPreferencesStore> open() async =>
      SharedPreferencesStore(await SharedPreferences.getInstance());

  final SharedPreferences _preferences;

  @override
  Future<String?> read(PreferenceKey key) async =>
      _preferences.getString(key.storageKey);

  @override
  Future<void> write(PreferenceKey key, String value) async {
    await _preferences.setString(key.storageKey, value);
  }

  @override
  Future<void> remove(PreferenceKey key) async {
    await _preferences.remove(key.storageKey);
  }
}

/// An in-memory [PreferencesStore] for tests.
class InMemoryPreferencesStore implements PreferencesStore {
  final Map<PreferenceKey, String> _values = {};

  @override
  Future<String?> read(PreferenceKey key) async => _values[key];

  @override
  Future<void> write(PreferenceKey key, String value) async =>
      _values[key] = value;

  @override
  Future<void> remove(PreferenceKey key) async => _values.remove(key);
}

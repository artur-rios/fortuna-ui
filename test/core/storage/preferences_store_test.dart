import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // The plugin's own in-memory store, set per test and emptied after, because
  // it is process-wide and test files share one isolate when run together.
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => SharedPreferences.setMockInitialValues({}));

  group('SharedPreferencesStore', () {
    test('Given a preference stored on an earlier run '
        'When the store is opened and the preference read '
        'Then it is found under its own namespaced key, and an unset one is '
        'absent', () async {
      SharedPreferences.setMockInitialValues({
        'fortuna.preference.locale': 'pt-BR',
      });

      final store = await SharedPreferencesStore.open();

      expect(await store.read(PreferenceKey.locale), 'pt-BR');
      expect(await store.read(PreferenceKey.themeMode), isNull);
    });

    test(
      'Given a preference '
      'When it is written '
      'Then it reads back and is held under its storage key (FR-PS-09)',
      () async {
        final store = await SharedPreferencesStore.open();

        await store.write(PreferenceKey.themeMode, 'dark');

        expect(await store.read(PreferenceKey.themeMode), 'dark');
        expect(
          (await SharedPreferences.getInstance()).getString(
            'fortuna.preference.themeMode',
          ),
          'dark',
        );
      },
    );

    test('Given a stored preference '
        'When it is removed '
        'Then it is gone and the others are kept', () async {
      SharedPreferences.setMockInitialValues({
        'fortuna.preference.instanceAddress': 'https://mine.example',
        'fortuna.preference.displayCurrency': 'EUR',
      });
      final store = await SharedPreferencesStore.open();

      await store.remove(PreferenceKey.instanceAddress);

      expect(await store.read(PreferenceKey.instanceAddress), isNull);
      expect(await store.read(PreferenceKey.displayCurrency), 'EUR');
    });
  });

  group('PreferenceKey', () {
    test('Given every preference '
        'When their storage keys are listed '
        'Then each is distinct and in the preference namespace', () {
      final keys = [for (final key in PreferenceKey.values) key.storageKey];

      expect(keys.toSet(), hasLength(keys.length));
      expect(keys, everyElement(startsWith('fortuna.preference.')));
    });
  });
}

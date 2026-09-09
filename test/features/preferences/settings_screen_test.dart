import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/preferences/state/preferences_controller.dart';
import 'package:fortuna_ui/features/preferences/ui/settings_screen.dart';

class _Currencies implements CurrencyRepository {
  _Currencies(this._result);

  final Result<List<SupportedCurrency>> _result;

  @override
  Future<Result<List<SupportedCurrency>>> listSupported() async => _result;
}

class _UnwritableStore implements PreferencesStore {
  @override
  Future<String?> read(PreferenceKey key) async => null;

  @override
  Future<void> write(PreferenceKey key, String value) async =>
      throw StateError('unavailable');

  @override
  Future<void> remove(PreferenceKey key) async =>
      throw StateError('unavailable');
}

Future<ProviderContainer> pumpSettings(
  WidgetTester tester, {
  PreferencesStore? store,
  Result<List<SupportedCurrency>> currencies = const Success([
    SupportedCurrency(code: 'USD', name: 'US Dollar', minorUnitDigits: 2),
    SupportedCurrency(code: 'BRL', name: 'Brazilian Real', minorUnitDigits: 2),
  ]),
}) async {
  // A tall surface so the whole list is built: a ListView does not build its
  // offscreen children, and the currency section sits below an 800px fold.
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      preferencesStoreProvider.overrideWithValue(
        store ?? InMemoryPreferencesStore(),
      ),
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      currencyRepositoryProvider.overrideWithValue(_Currencies(currencies)),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: SettingsScreen()),
    ),
  );
  await tester.pumpAndSettle();

  return container;
}

void main() {
  group('SettingsScreen', () {
    testWidgets('Given the screen is open '
        'When it settles '
        'Then all three choices are presented (UC-13 main flow)', (
      tester,
    ) async {
      await pumpSettings(tester);

      expect(find.text('Match the system'), findsOneWidget);
      expect(find.text('English (Europe)'), findsOneWidget);
      expect(find.text('Português (Brasil)'), findsOneWidget);
      expect(find.text('Each in its own currency'), findsOneWidget);
      expect(find.text('USD — US Dollar'), findsOneWidget);
    });

    testWidgets('Given a locale is chosen '
        'When it is selected '
        'Then it is applied immediately', (tester) async {
      final container = await pumpSettings(tester);

      await tester.tap(find.text('Português (Brasil)'));
      await tester.pumpAndSettle();

      expect(container.read(preferencesProvider).locale.countryCode, 'BR');
    });

    testWidgets('Given a display currency is chosen '
        'When it is selected '
        'Then it is applied immediately', (tester) async {
      final container = await pumpSettings(tester);

      await tester.tap(find.text('BRL — Brazilian Real'));
      await tester.pumpAndSettle();

      expect(container.read(preferencesProvider).displayCurrency, 'BRL');
    });

    testWidgets('Given the instance cannot supply the currency list '
        'When the screen settles '
        'Then it says so, keeps the current choice, and offers a retry '
        '(UC-13 AF-03)', (tester) async {
      await pumpSettings(
        tester,
        currencies: const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
      // The "each in its own currency" choice is still offered — the list
      // failing does not take the setting away.
      expect(find.text('Each in its own currency'), findsOneWidget);
    });

    testWidgets('Given preference storage refuses to save '
        'When a choice is made '
        'Then the screen says the choices will not be remembered '
        '(UC-13 AF-05)', (tester) async {
      await pumpSettings(tester, store: _UnwritableStore());

      expect(find.textContaining('could not be saved'), findsNothing);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(find.textContaining('could not be saved'), findsOneWidget);
    });
  });
}

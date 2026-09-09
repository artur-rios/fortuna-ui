import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/format/supported_locales.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/preferences/state/preferences_controller.dart';
import 'package:fortuna_ui/shared/widgets/money_text.dart';

class _Currencies implements CurrencyRepository {
  _Currencies(this._result);

  final Result<List<SupportedCurrency>> _result;

  @override
  Future<Result<List<SupportedCurrency>>> listSupported() async => _result;
}

Future<void> pumpMoney(
  WidgetTester tester,
  Money money, {
  String? displayCurrency,
  Locale locale = SupportedLocales.enUS,
  List<SupportedCurrency> currencies = const [],
}) async {
  final store = InMemoryPreferencesStore();
  final container = ProviderContainer(
    overrides: [
      preferencesStoreProvider.overrideWithValue(store),
      platformLocalesProvider.overrideWithValue([locale]),
      currencyRepositoryProvider.overrideWithValue(
        _Currencies(Success(currencies)),
      ),
    ],
  );
  addTearDown(container.dispose);

  if (displayCurrency != null) {
    await container
        .read(preferencesProvider.notifier)
        .setDisplayCurrency(displayCurrency);
  }

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: Scaffold(body: MoneyText(money))),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('MoneyText', () {
    testWidgets('Given an amount '
        'When it is rendered '
        'Then it shows with its currency (FR-PS-04)', (tester) async {
      await pumpMoney(tester, Money.parse('1234.5', 'USD'));

      expect(find.textContaining('1,234.50'), findsOneWidget);
      expect(find.textContaining(r'$'), findsOneWidget);
    });

    testWidgets('Given the same amount under a different locale '
        'When it is rendered '
        'Then only the rendering differs (FR-PS-03)', (tester) async {
      await pumpMoney(
        tester,
        Money.parse('1234.5', 'BRL'),
        locale: SupportedLocales.ptBR,
      );

      expect(find.textContaining('1.234,50'), findsOneWidget);
    });

    testWidgets('Given a figure not in the chosen display currency '
        'When it is rendered '
        'Then it shows in its own currency and is marked unconverted '
        '(UC-13 AF-04)', (tester) async {
      await pumpMoney(
        tester,
        Money.parse('10.00', 'BRL'),
        displayCurrency: 'USD',
      );

      // Shown in its own currency — never converted here.
      expect(find.textContaining('10.00'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);

      final semantics = tester.getSemantics(find.byType(MoneyText));
      expect(semantics.label, contains('not converted to USD'));
    });

    testWidgets('Given a figure already in the chosen display currency '
        'When it is rendered '
        'Then it carries no unconverted marker', (tester) async {
      await pumpMoney(
        tester,
        Money.parse('10.00', 'USD'),
        displayCurrency: 'USD',
      );

      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets('Given a projected figure '
        'When it is rendered '
        'Then it is distinguishable by more than colour (FR-PS-12, NFR-17)', (
      tester,
    ) async {
      await pumpMoney(tester, Money.parse('10.00', 'USD').asProjected());

      // A symbol, and italics — not colour alone.
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontStyle, FontStyle.italic);

      // And a screen reader hears it too.
      final semantics = tester.getSemantics(find.byType(MoneyText));
      expect(semantics.label, contains('projected'));
    });

    testWidgets('Given a recorded figure '
        'When it is rendered '
        'Then it carries no projection marker', (tester) async {
      await pumpMoney(tester, Money.parse('10.00', 'USD'));

      expect(find.byIcon(Icons.trending_up), findsNothing);
    });

    testWidgets('Given the instance reports a currency with no decimal places '
        'When an amount in it is rendered '
        "Then the instance's precision is used, not the library's guess "
        '(FR-PS-06)', (tester) async {
      await pumpMoney(
        tester,
        Money.parse('1234.56', 'XTS'),
        currencies: const [
          SupportedCurrency(code: 'XTS', name: 'Test', minorUnitDigits: 0),
        ],
      );

      expect(find.textContaining('1,235'), findsOneWidget);
      expect(find.textContaining('1,234.56'), findsNothing);
    });
  });
}

/// The settings screen (UC-13).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/money.dart';
import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../session/ui/sign_out_action.dart';
import '../state/currency_providers.dart';
import '../state/preferences_controller.dart';

const _localeNames = {
  'en_US': 'English (United States)',
  'en_GB': 'English (United Kingdom)',
  'en_150': 'English (Europe)',
  'pt_BR': 'Português (Brasil)',
};

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);
    final controller = ref.read(preferencesProvider.notifier);
    final currencies = ref.watch(supportedCurrenciesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [SignOutAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (!preferences.persisted)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _NotSavedNotice(),
            ),

          const _SectionHeader('Appearance'),
          RadioGroup<ThemeMode>(
            groupValue: preferences.themeMode,
            onChanged: (value) => unawaited(
              controller.setThemeMode(value ?? preferences.themeMode),
            ),
            child: Column(
              children: [
                for (final mode in ThemeMode.values)
                  RadioListTile<ThemeMode>(
                    value: mode,
                    title: Text(switch (mode) {
                      ThemeMode.system => 'Match the system',
                      ThemeMode.light => 'Light',
                      ThemeMode.dark => 'Dark',
                    }),
                  ),
              ],
            ),
          ),

          const Divider(),
          const _SectionHeader('Language and formatting'),
          RadioGroup<Locale>(
            groupValue: preferences.locale,
            onChanged: (value) =>
                unawaited(controller.setLocale(value ?? preferences.locale)),
            child: Column(
              children: [
                for (final locale in SupportedLocales.all)
                  RadioListTile<Locale>(
                    value: locale,
                    title: Text(_localeNames[SupportedLocales.tagOf(locale)]!),
                    subtitle: Text(SupportedLocales.tagOf(locale)),
                  ),
              ],
            ),
          ),

          const Divider(),
          const _SectionHeader('Display currency'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Figures are converted by the instance, which records the rate it '
              'used. Anything it cannot convert is shown in its own currency.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          RadioGroup<String?>(
            groupValue: preferences.displayCurrency,
            onChanged: (value) =>
                unawaited(controller.setDisplayCurrency(value)),
            child: Column(
              children: [
                const RadioListTile<String?>(
                  value: null,
                  title: Text('Each in its own currency'),
                ),
                ...currencies.maybeWhen(
                  data: (list) => [
                    for (final currency in list)
                      RadioListTile<String?>(
                        value: currency.code,
                        title: Text('${currency.code} — ${currency.name}'),
                      ),
                  ],
                  orElse: () => const <Widget>[],
                ),
              ],
            ),
          ),
          ...currencies.when(
            data: (_) => const <Widget>[],
            loading: () => const [
              ListTile(
                leading: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                title: Text('Loading currencies…'),
              ),
            ],
            // AF-03. The choice already made stands; only the list is missing.
            error: (error, _) => [
              _CurrencyListUnavailable(
                message: error is CurrencyListUnavailable
                    ? error.message
                    : 'The currency list could not be loaded.',
                current: preferences.displayCurrency,
                onRetry: () => ref.invalidate(supportedCurrenciesProvider),
              ),
            ],
          ),

          const Divider(),
          const _SectionHeader('Preview'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                MoneyText(Money.parse('1234.5', 'USD')),
                const SizedBox(width: 24),
                MoneyText(Money.parse('1234.5', 'BRL').asProjected()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
    ),
  );
}

/// `AF-05`. The choice applies; it just did not reach storage.
class _NotSavedNotice extends StatelessWidget {
  const _NotSavedNotice();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.warning_amber_outlined, color: scheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'These choices apply now but could not be saved on this '
                'device, so they will not be remembered next time.',
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyListUnavailable extends StatelessWidget {
  const _CurrencyListUnavailable({
    required this.message,
    required this.current,
    required this.onRetry,
  });

  final String message;
  final String? current;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.cloud_off_outlined),
    title: Text(message),
    subtitle: Text(
      current == null
          ? 'Figures continue to show in their own currencies.'
          : 'Your choice of $current still applies.',
    ),
    trailing: TextButton(onPressed: onRetry, child: const Text('Retry')),
  );
}

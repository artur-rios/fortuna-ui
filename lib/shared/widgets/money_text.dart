/// Renders a monetary amount (FR-PS-04, FR-PS-12, UC-13 AF-04).
///
/// The one widget every figure in the application goes through, so that the
/// three rules about showing money hold everywhere rather than screen by
/// screen: the currency is always shown, a projection is always distinguishable
/// from a record, and an amount that is not in the chosen display currency says
/// so instead of being converted here.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/money.dart';
import '../../core/format/money_formatter.dart';
import '../../core/format/supported_locales.dart';
import '../../features/preferences/state/currency_providers.dart';
import '../../features/preferences/state/preferences_controller.dart';

class MoneyText extends ConsumerWidget {
  const MoneyText(this.money, {this.style, super.key});

  final Money money;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);
    final formatter = MoneyFormatter(
      SupportedLocales.tagOf(preferences.locale),
      minorUnitDigits: ref.watch(minorUnitDigitsProvider),
    );

    final displayCurrency = preferences.displayCurrency;

    // AF-04. The API converts; this client never does. Where a figure is not in
    // the currency the user asked to read in, it is shown in its own and marked
    // — an unconverted figure the user can see is honest, a locally converted
    // one is an invented number (BR-07).
    final unconverted =
        displayCurrency != null && money.currencyCode != displayCurrency;

    final text = formatter.format(money);
    final theme = Theme.of(context);

    // Not colour alone (NFR-17): a projection is marked with a symbol and a
    // semantics label as well, so it survives a colourblind reader and a
    // screen reader both.
    final label = [
      text,
      if (money.isProjected) 'projected',
      if (unconverted) 'not converted to $displayCurrency',
    ].join(', ');

    return Semantics(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (money.isProjected)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.trending_up,
                size: 14,
                color: theme.colorScheme.outline,
              ),
            ),
          Text(
            text,
            style: (style ?? theme.textTheme.bodyMedium)?.copyWith(
              fontStyle: money.isProjected ? FontStyle.italic : null,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (unconverted)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Tooltip(
                message:
                    'Not converted to $displayCurrency — the instance did not '
                    'supply a rate, so this is shown in its own currency.',
                child: Icon(
                  Icons.info_outline,
                  size: 14,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

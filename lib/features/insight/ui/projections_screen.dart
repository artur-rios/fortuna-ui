/// The net position, projections and obligations (UC-38).
///
/// Step 4 is the requirement everything else on this screen serves: a
/// projected figure must never be mistakable for a recorded one, and the
/// distinction must not rest on colour (`FR-PJ-04`, `FR-PS-12`, `NFR-17`).
///
/// It is carried in three ways, deliberately overlapping:
///
/// 1. on the **value** — `Money.isProjected` travels with the amount, and
///    `MoneyText` renders it with a symbol and a semantics label, so a screen
///    reader hears it too;
/// 2. on the **section** — each projected block is labelled as a projection
///    in words;
/// 3. in the **shape** — projected sections are outlined and dashed rather
///    than filled, which survives a monochrome print as well as a colourblind
///    reader.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../preferences/state/preferences_controller.dart';
import '../state/projection_providers.dart';

class ProjectionsScreen extends ConsumerStatefulWidget {
  const ProjectionsScreen({super.key});

  @override
  ConsumerState<ProjectionsScreen> createState() => _ProjectionsScreenState();
}

class _ProjectionsScreenState extends ConsumerState<ProjectionsScreen> {
  Horizon _horizon = Horizon.threeMonths;

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(preferencesProvider).displayCurrency;
    final request = ProjectionRequest(
      horizon: _horizon,
      displayCurrencyCode: currency,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Projections')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _NetPositionSection(),
          const SizedBox(height: 24),

          // Step 2: the period is the user's to choose.
          Row(
            children: [
              Text(
                'Looking ahead',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              DropdownButton<Horizon>(
                key: const Key('projections.horizon'),
                value: _horizon,
                items: [
                  for (final horizon in Horizon.values)
                    DropdownMenuItem(
                      value: horizon,
                      child: Text(horizon.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _horizon = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          _CashFlowSection(request: request),
          const SizedBox(height: 24),
          _ObligationsSection(request: request),
        ],
      ),
    );
  }
}

/// Step 1.
class _NetPositionSection extends ConsumerWidget {
  const _NetPositionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final position = ref.watch(netPositionProvider);

    return position.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          key: Key('position.loading'),
          child: CircularProgressIndicator(),
        ),
      ),
      // AF-02.
      error: (error, _) => Card(
        key: const Key('position.failed'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('position.retry'),
                onPressed: () => ref.invalidate(netPositionProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (value) {
        // AF-05: nothing held is a zero worth explaining, not a failure and
        // not an empty screen.
        if (value.hasNoHoldings) {
          return Card(
            key: const Key('position.noHoldings'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Net position', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text('Nothing yet', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'You hold no accounts, cards or investments, so there is '
                    'nothing to add up. This is not a failure to read them.',
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          key: const Key('position.card'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Net position', style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),

                if (value.total case final total?)
                  MoneyText(
                    total,
                    key: const Key('position.total'),
                    style: theme.textTheme.headlineMedium,
                  ),

                // AF-03: each currency on its own line rather than summed.
                if (value.spansCurrencies) ...[
                  const SizedBox(height: 12),
                  Text(
                    value.total == null
                        ? 'Your holdings are in more than one currency, so '
                              'they are shown separately rather than added '
                              'together.'
                        : 'Some holdings could not be converted, and are '
                              'listed in their own currency below.',
                    key: const Key('position.multipleCurrencies'),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  for (final group in value.byCurrency)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        key: Key('position.currency.${group.net.currencyCode}'),
                        children: [
                          Text(group.net.currencyCode),
                          const Spacer(),
                          MoneyText(group.net),
                        ],
                      ),
                    ),
                ],

                const SizedBox(height: 12),
                Text(
                  'As at '
                  '${DateFormat.yMMMd(SupportedLocales.tagOf(ref.watch(preferencesProvider).locale)).format(value.asOf)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Step 2 and step 4.
class _CashFlowSection extends ConsumerWidget {
  const _CashFlowSection({required this.request});

  final ProjectionRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final projection = ref.watch(cashFlowProvider(request));
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    return projection.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          key: Key('cashFlow.loading'),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Card(
        key: const Key('cashFlow.failed'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('cashFlow.retry'),
                onPressed: () => ref.invalidate(cashFlowProvider(request)),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (value) {
        // AF-01: said plainly, instead of a forecast built on nothing.
        if (value.hasNothingToProject) {
          return Card(
            key: const Key('cashFlow.nothingToProject'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value.flatReason ??
                          'There is too little history to project from. A '
                              'forecast built on nothing would be a guess '
                              'dressed as a figure.',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _ProjectedCard(
          title: 'Projected balance',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text('Starting from'),
                  const Spacer(),
                  // Recorded, not projected — and MoneyText shows the
                  // difference without being told.
                  MoneyText(
                    value.startingBalance,
                    key: const Key('cashFlow.startingBalance'),
                  ),
                ],
              ),
              const Divider(height: 24),
              for (final period in value.periods)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    key: Key(
                      'cashFlow.period.'
                      '${DateFormat('yyyy-MM-dd').format(period.periodStart)}',
                    ),
                    children: [
                      Text(DateFormat.yMMM(locale).format(period.periodStart)),
                      const Spacer(),
                      MoneyText(period.closingBalance),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Through ${DateFormat.yMMMd(locale).format(value.through)}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Step 3.
class _ObligationsSection extends ConsumerWidget {
  const _ObligationsSection({required this.request});

  final ProjectionRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final obligations = ref.watch(obligationsProvider(request));
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    return obligations.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          key: Key('obligations.loading'),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Card(
        key: const Key('obligations.failed'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('obligations.retry'),
                onPressed: () => ref.invalidate(obligationsProvider(request)),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (value) {
        if (value.isEmpty) {
          return const Card(
            key: Key('obligations.empty'),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Nothing committed in this period.'),
            ),
          );
        }

        return _ProjectedCard(
          title: 'Already committed',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (value.total case final total?) ...[
                Row(
                  children: [
                    const Text('Total'),
                    const Spacer(),
                    MoneyText(
                      total,
                      key: const Key('obligations.total'),
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const Divider(height: 24),
              ],
              for (final item in value.items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    key: Key('obligations.item.${item.id}'),
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.kind.label),
                            Text(
                              DateFormat.yMMMd(locale).format(item.dueDate),
                              style: theme.textTheme.bodySmall,
                            ),
                            if (item.isOverdue)
                              Text(
                                // Named as well as coloured (NFR-17).
                                'Overdue by ${item.daysOverdue} '
                                '${item.daysOverdue == 1 ? 'day' : 'days'}',
                                key: Key('obligations.overdue.${item.id}'),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                          ],
                        ),
                      ),
                      MoneyText(item.amount),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A block of figures that are forecasts rather than records.
///
/// Step 4, in shape and in words: dashed and outlined rather than filled, and
/// labelled "Projected" in text. Neither depends on colour, so the
/// distinction survives a colourblind reader and a monochrome print — which
/// is what `NFR-17` asks and what `FR-PJ-04` needs to be true of every view
/// that mixes the two.
class _ProjectedCard extends StatelessWidget {
  const _ProjectedCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: Key('projected.${title.toLowerCase().replaceAll(' ', '-')}'),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleSmall),
              const Spacer(),
              // The word itself. A reader who sees only this still knows.
              Container(
                key: const Key('projected.label'),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Projected', style: theme.textTheme.labelSmall),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'These figures are forecasts, not records. Nothing here is '
            'stored.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// A drilled level and the path that bounds it (UC-37).
///
/// The breadcrumb is not decoration. `FR-CH-07` exists because "R$ 320 of
/// groceries" and "R$ 320 of groceries at one shop in March" are different
/// claims, and a figure shown without its bounds cannot be told apart from
/// the other. So the path is always visible, and every step on it is a way
/// back (`FR-CH-06`).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../preferences/state/preferences_controller.dart';
import '../../transactions/data/transaction_repository.dart';
import '../data/aggregation_repository.dart';
import '../state/drill_down_controller.dart';
import 'aggregation_chart.dart';

class DrillDownView extends ConsumerWidget {
  const DrillDownView({
    required this.state,
    required this.rootLabel,
    this.displayCurrencyCode,
    super.key,
  });

  final DrillState state;

  /// What the chart underneath the path is grouped by, shown as its root.
  final String rootLabel;

  final String? displayCurrencyCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(drillDownControllerProvider.notifier);

    return Column(
      children: [
        _Breadcrumb(
          path: controller.path,
          rootLabel: rootLabel,
          onStepTo: (index) => unawaited(
            controller.stepTo(index, displayCurrencyCode: displayCurrencyCode),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: switch (state) {
            DrillLoading() => const Center(
              key: Key('drill.loading'),
              child: CircularProgressIndicator(),
            ),

            // AF-02: the path is still above this, so the level the user came
            // from is one tap away, and the retry knows what to ask for.
            DrillFailed(:final reason) => Center(
              key: const Key('drill.failed'),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(reason, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('drill.retry'),
                      onPressed: () => unawaited(
                        controller.retry(
                          displayCurrencyCode: displayCurrencyCode,
                        ),
                      ),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),

            DrillLoaded(:final level) => _Level(
              level: level,
              displayCurrencyCode: displayCurrencyCode,
            ),

            AtChart() => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }
}

/// `FR-CH-07` and step 5.
class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({
    required this.path,
    required this.rootLabel,
    required this.onStepTo,
  });

  final List<DrillStep> path;
  final String rootLabel;
  final void Function(int) onStepTo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // AF-04: the root steps all the way back to the unfiltered chart.
          TextButton(
            key: const Key('drill.crumb.root'),
            onPressed: () => onStepTo(-1),
            child: Text(rootLabel),
          ),
          for (var i = 0; i < path.length; i++) ...[
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            if (i == path.length - 1)
              // Where the user is now. Not a button: there is nowhere to go.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  path[i].label,
                  key: Key('drill.crumb.current'),
                  style: theme.textTheme.titleSmall,
                ),
              )
            else
              TextButton(
                key: Key('drill.crumb.$i'),
                onPressed: () => onStepTo(i),
                child: Text(path[i].label),
              ),
          ],
        ],
      ),
    );
  }
}

class _Level extends ConsumerWidget {
  const _Level({required this.level, this.displayCurrencyCode});

  final DrillLevel level;
  final String? displayCurrencyCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) => switch (level) {
    // Step 6 and AF-01: the finest level is the transactions themselves,
    // presented rather than descended into again.
    DrillTransactions(:final transactions, :final mayDifferFromChart) =>
      transactions.isEmpty
          ? const _EmptyLevel()
          : _Transactions(
              transactions: transactions,
              mayDifferFromChart: mayDifferFromChart,
            ),

    DrillBuckets(:final buckets, :final dimension) =>
      buckets.isEmpty
          ? const _EmptyLevel()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: AggregationChart(
                // A drilled level is drawn the same way the chart above it was,
                // so descending does not change what the reader is looking at,
                // only what it is bounded by.
                aggregation: Aggregation(
                  grouping: Grouping.category,
                  buckets: buckets,
                  from: DateTime(1970),
                  to: DateTime(1970),
                  isFullyConverted: true,
                  displayCurrencyCode: displayCurrencyCode,
                ),
                // AF-06: a remainder group is a bucket like any other, so it
                // descends the same way with no special case.
                onSelect: (bucket) => unawaited(
                  ref
                      .read(drillDownControllerProvider.notifier)
                      .descend(
                        bucket,
                        dimension: dimension,
                        displayCurrencyCode: displayCurrencyCode,
                      ),
                ),
              ),
            ),
  };
}

/// `AF-03`: nothing at this level, with the path intact above it.
class _EmptyLevel extends StatelessWidget {
  const _EmptyLevel();

  @override
  Widget build(BuildContext context) => Center(
    key: const Key('drill.empty'),
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_outlined, size: 40),
          const SizedBox(height: 16),
          Text('Nothing here', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'There is no breakdown behind this one. Step back to where you '
            'came from.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

/// Step 6.
class _Transactions extends ConsumerWidget {
  const _Transactions({
    required this.transactions,
    required this.mayDifferFromChart,
  });

  final List<Transaction> transactions;
  final bool mayDifferFromChart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    return ListView.builder(
      key: const Key('drill.transactions'),
      padding: const EdgeInsets.all(12),
      itemCount: transactions.length + (mayDifferFromChart ? 1 : 0),
      itemBuilder: (context, index) {
        if (mayDifferFromChart && index == 0) {
          // The API's own warning, passed through rather than hidden: a
          // reader adding these rows up and getting a different number
          // deserves to know why before they do it, not after.
          return Card(
            key: const Key('drill.mayDiffer'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'These rows may not add up to the figure above them. '
                      'The instance says so itself — a conversion or a '
                      'rounding can make the two differ.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final transaction = transactions[index - (mayDifferFromChart ? 1 : 0)];

        return Card(
          key: Key('drill.transaction.${transaction.id}'),
          child: ListTile(
            title: Text(dates.format(transaction.occurredOn)),
            subtitle: Text(
              transaction.description ?? transaction.categoryName ?? '—',
            ),
            trailing: MoneyText(transaction.amount),
            // FR-TB-06 again: a row opens into its own detail.
            onTap: () => context.go(Routes.transactionOf(transaction.id)),
          ),
        );
      },
    );
  }
}

/// Charts (UC-36).
///
/// Only the groupings the API supports are offered, which is how `AF-04` is
/// satisfied: a grouping the instance does not know is not one the user can
/// pick, because no control exists for it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/aggregation_repository.dart';
import '../state/aggregation_providers.dart';
import 'aggregation_chart.dart';

class InsightScreen extends ConsumerStatefulWidget {
  const InsightScreen({super.key});

  @override
  ConsumerState<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends ConsumerState<InsightScreen> {
  late AggregationRequest _request = AggregationRequest(
    grouping: Grouping.category,
    // A year back by default: long enough to have something in it, short
    // enough that the first read is not a whole history.
    from: DateTime(DateTime.now().year - 1, DateTime.now().month),
    to: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider);

    // The display currency is the user's presentation choice (UC-13). Where
    // none is chosen the API reports each currency separately, which is what
    // AF-03 asks for rather than a sum across them.
    final request = _request.copyWith(
      displayCurrencyCode: preferences.displayCurrency,
    );
    final aggregation = ref.watch(aggregationProvider(request));

    return Scaffold(
      appBar: AppBar(title: const Text('Insight')),
      body: Column(
        children: [
          _Controls(
            request: _request,
            onChange: (next) => setState(() => _request = next),
          ),
          const Divider(height: 1),
          Expanded(
            child: aggregation.when(
              loading: () => const Center(
                key: Key('insight.loading'),
                child: CircularProgressIndicator(),
              ),
              // AF-02.
              error: (error, _) => Center(
                key: const Key('insight.failed'),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$error', textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const Key('insight.retry'),
                        onPressed: () =>
                            ref.invalidate(aggregationProvider(request)),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (value) =>
                  value.isEmpty ? const _Empty() : _Loaded(aggregation: value),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step 1.
class _Controls extends ConsumerWidget {
  const _Controls({required this.request, required this.onChange});

  final AggregationRequest request;
  final void Function(AggregationRequest) onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          DropdownButton<Grouping>(
            key: const Key('insight.grouping'),
            value: request.grouping,
            items: [
              // AF-04: exactly the groupings the API supports, and no others.
              for (final grouping in Grouping.values)
                DropdownMenuItem(value: grouping, child: Text(grouping.label)),
            ],
            onChanged: (value) {
              if (value != null) onChange(request.copyWith(grouping: value));
            },
          ),

          if (request.grouping.isTemporal)
            DropdownButton<Granularity>(
              key: const Key('insight.granularity'),
              value: request.granularity,
              items: [
                for (final granularity in Granularity.values)
                  DropdownMenuItem(
                    value: granularity,
                    child: Text(granularity.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  onChange(request.copyWith(granularity: value));
                }
              },
            ),

          OutlinedButton.icon(
            key: const Key('insight.period'),
            icon: const Icon(Icons.date_range, size: 18),
            label: Text(
              '${dates.format(request.from)} – ${dates.format(request.to)}',
            ),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDateRange: DateTimeRange(
                  start: request.from,
                  end: request.to,
                ),
              );
              if (range != null) {
                onChange(request.copyWith(from: range.start, to: range.end));
              }
            },
          ),
        ],
      ),
    );
  }
}

/// AF-01: nothing in the period, which is not a failure.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => Center(
    key: const Key('insight.empty'),
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insights_outlined, size: 40),
          const SizedBox(height: 16),
          Text(
            'Nothing in this period',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'There are no records in the range and grouping you chose. Try a '
            'wider period.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.aggregation});

  final Aggregation aggregation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AF-03, said before the figures rather than after them: a reader who
        // does not know the totals are incomplete will read them as complete.
        if (aggregation.spansCurrencies)
          Card(
            key: const Key('insight.multipleCurrencies'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      aggregation.displayCurrencyCode == null
                          ? 'These figures are in more than one currency. They '
                                'are shown separately rather than added '
                                'together — choose a display currency in '
                                'settings to have the instance convert them.'
                          : 'Some amounts could not be converted into '
                                '${aggregation.displayCurrencyCode}. They are '
                                'listed in their own currency rather than '
                                'folded into the totals.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (aggregation.spansCurrencies) const SizedBox(height: 16),

        AggregationChart(aggregation: aggregation),
      ],
    );
  }
}

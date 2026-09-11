/// Drawing an aggregation (UC-36, steps 3 and 4).
///
/// Two rules shape every choice here.
///
/// **`FR-CH-08`: a coordinate is presentation only.** What is plotted is the
/// API's *share* — a proportion, not an amount — so a bar's height carries no
/// monetary meaning at all and there is no figure to read back out of it. The
/// amount beside each element comes from the bucket it was built from. The
/// requirement is therefore satisfied by construction rather than by
/// remembering to obey it.
///
/// **`FR-CH-09`: legible in both themes.** Every colour comes from the active
/// `ColorScheme`, and nothing is distinguished by colour alone — each element
/// carries its label and its figure as text beside it (`NFR-17`).
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/money_text.dart';
import '../data/aggregation_repository.dart';

/// An aggregation drawn in the form its grouping suits.
class AggregationChart extends StatelessWidget {
  const AggregationChart({required this.aggregation, this.onSelect, super.key});

  final Aggregation aggregation;

  /// What UC-37 hangs on: which element was touched, identified by the
  /// bucket rather than by where the tap landed.
  final void Function(AggregationBucket)? onSelect;

  @override
  Widget build(BuildContext context) => aggregation.grouping.isTemporal
      ? _TemporalChart(aggregation: aggregation, onSelect: onSelect)
      : _CategoricalChart(aggregation: aggregation, onSelect: onSelect);
}

/// A period aggregation reads as a line: the order means something.
class _TemporalChart extends StatelessWidget {
  const _TemporalChart({required this.aggregation, this.onSelect});

  final Aggregation aggregation;
  final void Function(AggregationBucket)? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buckets = aggregation.buckets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            key: const Key('chart.line'),
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < buckets.length; i++)
                      // The y value is a share in thousandths, scaled to a
                      // fraction. No monetary value reaches this axis.
                      FlSpot(
                        i.toDouble(),
                        (buckets[i].sharePermille ?? 0) / 1000,
                      ),
                  ],
                  isCurved: false,
                  color: theme.colorScheme.primary,
                  barWidth: 2,
                  dotData: const FlDotData(),
                ),
              ],
              minY: 0,
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 || index >= buckets.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          buckets[index].label,
                          style: theme.textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                horizontalInterval: 0.25,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.colorScheme.outlineVariant,
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchCallback: (event, response) {
                  final spot = response?.lineBarSpots?.firstOrNull;
                  if (spot == null || !event.isInterestedForInteractions) {
                    return;
                  }

                  // FR-CH-08: the bucket is found by index, and every figure
                  // reported onward comes from it — never from the spot's y.
                  final index = spot.x.round();
                  if (index >= 0 && index < buckets.length) {
                    onSelect?.call(buckets[index]);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // The figures themselves, as text. The chart shows the shape; this
        // shows the numbers, and the numbers are the data's own.
        _Legend(aggregation: aggregation, onSelect: onSelect),
      ],
    );
  }
}

/// A categorical aggregation reads as bars: the order is by size, not time.
class _CategoricalChart extends StatelessWidget {
  const _CategoricalChart({required this.aggregation, this.onSelect});

  final Aggregation aggregation;
  final void Function(AggregationBucket)? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buckets = aggregation.buckets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 220,
          child: BarChart(
            key: const Key('chart.bars'),
            BarChartData(
              maxY: 1,
              barGroups: [
                for (var i = 0; i < buckets.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        // A share, scaled for drawing. Nothing monetary.
                        toY: (buckets[i].sharePermille ?? 0) / 1000,
                        color: theme.colorScheme.primary,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
              ],
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 || index >= buckets.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          buckets[index].label,
                          style: theme.textTheme.labelSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                horizontalInterval: 0.25,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.colorScheme.outlineVariant,
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchCallback: (event, response) {
                  final index = response?.spot?.touchedBarGroupIndex;
                  if (index == null || !event.isInterestedForInteractions) {
                    return;
                  }

                  // FR-CH-08 again: the element identifies a bucket, and the
                  // bucket carries the figure.
                  if (index >= 0 && index < buckets.length) {
                    onSelect?.call(buckets[index]);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _Legend(aggregation: aggregation, onSelect: onSelect),
      ],
    );
  }
}

/// Every element as a row: its label, its figure, and its currency.
///
/// This is where `FR-CH-10` and step 5 are actually satisfied — a chart can
/// show a shape, but only text can carry a currency, and an amount without one
/// is what `BR-07` forbids.
class _Legend extends StatelessWidget {
  const _Legend({required this.aggregation, this.onSelect});

  final Aggregation aggregation;
  final void Function(AggregationBucket)? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (final bucket in aggregation.buckets)
          ListTile(
            key: Key('chart.bucket.${bucket.label}'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(bucket.label),
            subtitle: bucket.unconverted.isEmpty
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AF-03: shown in their own currencies, beside the
                      // total rather than inside it. Adding them would be
                      // summing across currencies, which is the one thing
                      // this must not do.
                      for (final amount in bucket.unconverted)
                        Row(
                          key: Key(
                            'chart.unconverted.'
                            '${bucket.label}.${amount.amount.currencyCode}',
                          ),
                          children: [
                            const Text('Not converted: '),
                            MoneyText(
                              amount.amount,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
            trailing: bucket.total == null
                ? Text('—', key: Key('chart.noTotal.${bucket.label}'))
                : MoneyText(
                    bucket.total!,
                    key: Key('chart.total.${bucket.label}'),
                  ),
            onTap: bucket.canDrillDown && onSelect != null
                ? () => onSelect!(bucket)
                : null,
          ),
      ],
    );
  }
}

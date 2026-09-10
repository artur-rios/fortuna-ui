/// One investment: its position and what is known about it (UC-17, steps 4
/// and 5).
///
/// The screen shows the position the API reports and the latest valuation the
/// user recorded, and where there is no valuation it states that plainly
/// (`AF-05`). It does not fill the gap with the position, or with anything
/// derived from it — `FR-HO-12` forbids this client from pricing an
/// instrument, and presenting contributions as a valuation would be exactly
/// that, done implicitly.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/investment_repository.dart';
import '../state/investment_providers.dart';
import 'investment_editor.dart';
import 'investment_record_sheet.dart';

class InvestmentScreen extends ConsumerWidget {
  const InvestmentScreen({required this.investmentId, super.key});

  final String investmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investment = ref.watch(investmentProvider(investmentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment'),
        actions: [
          if (investment case AsyncData<Investment>(:final value))
            IconButton(
              key: const Key('investment.edit'),
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => unawaited(
                showInvestmentEditor(context, ref, investment: value),
              ),
            ),
        ],
      ),
      body: investment.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // AF-03: not found, and belonging to someone else, are one answer.
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$error',
                  key: const Key('investment.error'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('investment.retry'),
                  onPressed: () =>
                      ref.invalidate(investmentProvider(investmentId)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (value) => _Investment(investment: value),
      ),
    );
  }
}

class _Investment extends ConsumerWidget {
  const _Investment({required this.investment});

  final Investment investment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(investment.instrument, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          [
            investment.type.label,
            investment.currencyCode,
            if (investment.institution case final institution?
                when institution.isNotEmpty)
              institution,
          ].join(' · '),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Position', style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                MoneyText(
                  investment.position,
                  key: const Key('investment.position'),
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'What has been contributed and withdrawn, as the instance '
                  'reports it.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (investment.latestValuation case final valuation?)
          Card(
            key: const Key('investment.valuation'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latest valuation', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 4),
                  MoneyText(
                    valuation.value,
                    style: theme.textTheme.headlineSmall,
                  ),
                  if (valuation.asOf case final asOf?) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Recorded for ${DateFormat.yMMMd(locale).format(asOf)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          )
        else
          // AF-05. Stated, not filled in. The position above is what was put
          // in and taken out; it is not a valuation, and the two are not
          // interchangeable.
          Card(
            key: const Key('investment.noValuation'),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No valuation has been recorded for this investment. '
                      'The position above is what was contributed and '
                      'withdrawn — it is not a current value, and this '
                      'application does not price instruments.',
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 16),

        // UC-18 step 1: the two things that can be recorded, offered as two
        // actions because they mean two different things.
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('investment.recordMovement'),
                icon: const Icon(Icons.swap_vert),
                label: const Text('Record movement'),
                onPressed: () => unawaited(
                  showInvestmentRecordSheet(
                    context,
                    ref,
                    investment: investment,
                    kind: RecordKind.movement,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('investment.recordValuation'),
                icon: const Icon(Icons.assessment_outlined),
                label: const Text('Record valuation'),
                onPressed: () => unawaited(
                  showInvestmentRecordSheet(
                    context,
                    ref,
                    investment: investment,
                    kind: RecordKind.valuation,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        _ValuationHistory(investmentId: investment.id, locale: locale),
      ],
    );
  }
}

/// What has been recorded, most recent first. Read-only: the history is the
/// evidence behind the position, and editing it here would be editing the
/// past rather than recording the present.
class _ValuationHistory extends ConsumerWidget {
  const _ValuationHistory({required this.investmentId, required this.locale});

  final String investmentId;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final valuations = ref.watch(investmentValuationsProvider(investmentId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recorded valuations', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        valuations.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) =>
              Text('$error', key: const Key('investment.valuations.error')),
          data: (list) {
            if (list.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Nothing recorded yet.',
                  key: Key('investment.valuations.empty'),
                ),
              );
            }

            return Column(
              children: [
                for (final valuation in list)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      valuation.asOf == null
                          ? 'Undated'
                          : DateFormat.yMMMd(locale).format(valuation.asOf!),
                    ),
                    trailing: MoneyText(valuation.value),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

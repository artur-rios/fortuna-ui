/// Investments (UC-17, steps 1 and 5).
///
/// The position on each row is the API's figure. Where no valuation has been
/// recorded the row says so (`AF-05`) rather than presenting the position as
/// though it were a current market value — this client does not price an
/// instrument (`FR-HO-12`), and a number that looks like a valuation but is
/// not one is worse than no number at all.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/widgets/money_text.dart';
import '../data/investment_repository.dart';
import '../state/investment_providers.dart';
import 'investment_editor.dart';

class InvestmentsScreen extends ConsumerWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investments = ref.watch(investmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Investments')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('investments.add'),
        onPressed: () => unawaited(showInvestmentEditor(context, ref)),
        icon: const Icon(Icons.add),
        label: const Text('New investment'),
      ),
      body: investments.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('investments.retry'),
                  onPressed: () => ref.invalidate(investmentsProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (list) {
          // AF-06.
          if (list.isEmpty) {
            return Center(
              key: const Key('investments.empty'),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.savings_outlined, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      'No investments yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add an investment to record what you put in, take out '
                      'and value it at.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('investments.emptyAdd'),
                      onPressed: () =>
                          unawaited(showInvestmentEditor(context, ref)),
                      child: const Text('Add an investment'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) =>
                _InvestmentTile(investment: list[index]),
          );
        },
      ),
    );
  }
}

class _InvestmentTile extends ConsumerWidget {
  const _InvestmentTile({required this.investment});

  final Investment investment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      key: Key('investments.item.${investment.id}'),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(investment.instrument, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              [
                investment.type.label,
                if (investment.institution case final institution?
                    when institution.isNotEmpty)
                  institution,
              ].join(' · '),
              style: theme.textTheme.bodySmall,
            ),
            // AF-05, said on the row rather than only on the detail screen:
            // a list of positions where one of them means something different
            // must say which one.
            if (investment.hasNoValuation) ...[
              const SizedBox(height: 4),
              Text(
                'No valuation recorded',
                key: Key('investments.noValuation.${investment.id}'),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        trailing: MoneyText(
          investment.position,
          key: Key('investments.position.${investment.id}'),
          style: theme.textTheme.titleMedium,
        ),
        onTap: () => context.go(Routes.investmentOf(investment.id)),
      ),
    );
  }
}

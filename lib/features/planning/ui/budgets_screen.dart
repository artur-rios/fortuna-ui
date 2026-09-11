/// Budgets (UC-28, steps 1 and 5).
///
/// Every figure on this screen is the API's. The bar is drawn from spent and
/// the ceiling, but nothing is read back out of it — a proportion is a drawing
/// instruction, not a number about money (`FR-CH-08`, `IR-14`), and the same
/// rule the credit card screen follows applies here.
///
/// Where consumption is missing the row says so (`AF-04`) instead of showing a
/// zero. "You have spent nothing" and "we could not tell you what you spent"
/// are different claims, and only one of them is reassuring.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../categories/state/category_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/budget_repository.dart';
import '../state/budget_providers.dart';
import 'budget_editor.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsProvider);
    final categories = ref.watch(categoryTreeProvider);

    // AF-06: a budget covers a category, so without one the form cannot be
    // completed. Saying so beats offering an empty picker.
    final hasNoCategories = switch (categories) {
      AsyncData(:final value) => value.isEmpty,
      _ => false,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      floatingActionButton: hasNoCategories
          ? null
          : FloatingActionButton.extended(
              key: const Key('budgets.add'),
              onPressed: () => unawaited(showBudgetEditor(context, ref)),
              icon: const Icon(Icons.add),
              label: const Text('New budget'),
            ),
      body: hasNoCategories
          ? const _NoCategories()
          : budgets.when(
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
                        key: const Key('budgets.retry'),
                        onPressed: () => ref.invalidate(budgetsProvider),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    key: const Key('budgets.empty'),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.pie_chart_outline, size: 40),
                          const SizedBox(height: 16),
                          Text(
                            'No budgets yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Set a ceiling for a category and see what is '
                            'spent against it.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            key: const Key('budgets.emptyAdd'),
                            onPressed: () =>
                                unawaited(showBudgetEditor(context, ref)),
                            child: const Text('Add a budget'),
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
                      _BudgetTile(budget: list[index]),
                );
              },
            ),
    );
  }
}

/// AF-06.
class _NoCategories extends StatelessWidget {
  const _NoCategories();

  @override
  Widget build(BuildContext context) => Center(
    key: const Key('budgets.noCategories'),
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.category_outlined, size: 40),
          const SizedBox(height: 16),
          Text(
            'Create a category first',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'A budget is a ceiling for a category, so there needs to be one '
            'to budget for.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('budgets.createCategory'),
            onPressed: () => context.go(Routes.categories),
            child: const Text('Go to categories'),
          ),
        ],
      ),
    ),
  );
}

class _BudgetTile extends ConsumerWidget {
  const _BudgetTile({required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final consumption = budget.consumption;

    return Card(
      key: Key('budgets.item.${budget.id}'),
      child: InkWell(
        onTap: () => unawaited(showBudgetEditor(context, ref, budget: budget)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      budget.categoryNames.isEmpty
                          ? 'Uncategorized'
                          : budget.categoryNames.join(', '),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(budget.period.label, style: theme.textTheme.bodySmall),
                ],
              ),
              if (budget.includeDescendants)
                Text(
                  'Includes sub-categories',
                  style: theme.textTheme.bodySmall,
                ),
              const SizedBox(height: 12),

              // AF-04: stated, not filled in with a zero.
              if (budget.hasNoConsumption) ...[
                Row(
                  key: Key('budgets.noConsumption.${budget.id}'),
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'What has been spent could not be read. The ceiling is '
                        'shown on its own.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Ceiling', style: theme.textTheme.labelSmall),
                    const Spacer(),
                    MoneyText(
                      budget.amount,
                      key: Key('budgets.amount.${budget.id}'),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: _Figure(
                        label: 'Spent',
                        child: MoneyText(
                          consumption!.spent!,
                          key: Key('budgets.spent.${budget.id}'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _Figure(
                        label: budget.isExceeded ? 'Over by' : 'Remaining',
                        child: MoneyText(
                          // Both the API's figures. Neither is derived from
                          // the ceiling and the other.
                          budget.isExceeded
                              ? (consumption.overage ?? consumption.remaining!)
                              : consumption.remaining!,
                          key: Key('budgets.remaining.${budget.id}'),
                          style: budget.isExceeded
                              ? TextStyle(color: theme.colorScheme.error)
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _Figure(
                        label: 'Ceiling',
                        child: MoneyText(
                          budget.amount,
                          key: Key('budgets.amount.${budget.id}'),
                        ),
                      ),
                    ),
                  ],
                ),

                if (budget.isExceeded) ...[
                  const SizedBox(height: 8),
                  Row(
                    key: Key('budgets.exceeded.${budget.id}'),
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Over the budget',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 8),
                Text(
                  '${DateFormat.yMMMd(locale).format(consumption.periodStart)}'
                  ' – '
                  '${DateFormat.yMMMd(locale).format(consumption.periodEnd)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelSmall),
      const SizedBox(height: 2),
      child,
    ],
  );
}

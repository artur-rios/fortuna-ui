/// Goals (UC-29, steps 1 and 5).
///
/// The bar is drawn from the proportion the API computed, and nothing is read
/// back out of it — a proportion is a drawing instruction, not a number about
/// money (`FR-CH-08`, `IR-14`).
///
/// A goal whose date has passed stays on the list, marked as elapsed and
/// carrying the progress it reached (`AF-04`). Removing it would erase the
/// answer to the only question worth asking afterwards: how close did I get?
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/goal_repository.dart';
import '../state/goal_providers.dart';
import 'goal_editor.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('goals.add'),
        onPressed: () => unawaited(showGoalEditor(context, ref)),
        icon: const Icon(Icons.add),
        label: const Text('New goal'),
      ),
      body: goals.when(
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
                  key: const Key('goals.retry'),
                  onPressed: () => ref.invalidate(goalsProvider),
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
              key: const Key('goals.empty'),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flag_outlined, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      'No goals yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Set a target and a date, and track what you have put '
                      'aside toward it.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('goals.emptyAdd'),
                      onPressed: () => unawaited(showGoalEditor(context, ref)),
                      child: const Text('Add a goal'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) => _GoalTile(goal: list[index]),
          );
        },
      ),
    );
  }
}

class _GoalTile extends ConsumerWidget {
  const _GoalTile({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);
    final progress = goal.progress;
    final elapsed = goal.hasElapsed(now: DateTime.now());

    return Card(
      key: Key('goals.item.${goal.id}'),
      child: InkWell(
        onTap: () => unawaited(showGoalEditor(context, ref, goal: goal)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(goal.name, style: theme.textTheme.titleMedium),
                  ),
                  if (goal.isReached)
                    Row(
                      key: Key('goals.reached.${goal.id}'),
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('Reached', style: theme.textTheme.labelMedium),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 4),

              // AF-04: kept, marked, and still carrying its progress.
              if (elapsed)
                Row(
                  key: Key('goals.elapsed.${goal.id}'),
                  children: [
                    Icon(
                      Icons.history,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        goal.isReached
                            ? 'The date has passed, and the target was met.'
                            : 'The date has passed. This is how far it got.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'By ${dates.format(goal.targetDate)}',
                  style: theme.textTheme.bodySmall,
                ),

              const SizedBox(height: 12),

              // AF-03: stated, not filled in with a zero.
              if (goal.hasNoProgress) ...[
                Row(
                  key: Key('goals.noProgress.${goal.id}'),
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Progress toward this goal could not be read. The '
                        'target is shown on its own.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Target', style: theme.textTheme.labelSmall),
                    const Spacer(),
                    MoneyText(
                      goal.targetAmount,
                      key: Key('goals.target.${goal.id}'),
                    ),
                  ],
                ),
              ] else ...[
                if (progress!.proportionPermille case final permille?)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: LinearProgressIndicator(
                      key: Key('goals.bar.${goal.id}'),
                      // A unitless ratio in thousandths, divided into a
                      // fraction here and nowhere else. No monetary value
                      // becomes a float on this path; the bar is a drawing
                      // instruction, and nothing is ever read back out of it.
                      value: _drawable(permille),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: _Figure(
                        label: 'Saved',
                        child: MoneyText(
                          progress.currentAmount!,
                          key: Key('goals.saved.${goal.id}'),
                        ),
                      ),
                    ),
                    if (progress.remaining case final remaining?)
                      Expanded(
                        child: _Figure(
                          label: 'Remaining',
                          child: MoneyText(
                            remaining,
                            key: Key('goals.remaining.${goal.id}'),
                          ),
                        ),
                      ),
                    Expanded(
                      child: _Figure(
                        label: 'Target',
                        child: MoneyText(
                          goal.targetAmount,
                          key: Key('goals.target.${goal.id}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (goal.accountNames.isNotEmpty ||
                  goal.investmentNames.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'From ${[...goal.accountNames, ...goal.investmentNames].join(', ')}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Thousandths as the fraction the indicator wants.
  ///
  /// Clamped because a goal can be overshot, and a bar drawn past its end
  /// reads as a fault rather than a success. The input is already a plain
  /// integer, so no money is converted here — see `proportionPermille`.
  static double _drawable(int permille) {
    if (permille <= 0) return 0;
    if (permille >= 1000) return 1;

    return permille / 1000;
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

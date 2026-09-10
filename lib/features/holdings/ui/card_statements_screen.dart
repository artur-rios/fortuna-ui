/// A card's billing cycles (UC-16, steps 1 and 6).
///
/// Each cycle is one row: its period, its total and its state. The state is
/// the API's, and it is what decides which actions the statement screen will
/// offer — so it is shown here rather than left for the reader to infer from
/// dates.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/statement_repository.dart';
import '../state/statement_providers.dart';

class CardStatementsScreen extends ConsumerWidget {
  const CardStatementsScreen({required this.creditCardId, super.key});

  final String creditCardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statements = ref.watch(cardStatementsProvider(creditCardId));

    return Scaffold(
      appBar: AppBar(title: const Text('Statements')),
      body: statements.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // AF-05 lands here too: a card that is not yours reads as not found.
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('statements.retry'),
                  onPressed: () =>
                      ref.invalidate(cardStatementsProvider(creditCardId)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (list) {
          // AF-06: no cycles yet is not a failure, and saying why is the
          // difference between an empty screen and an explained one.
          if (list.isEmpty) {
            return const Center(
              key: Key('statements.empty'),
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 40),
                    SizedBox(height: 16),
                    Text('No statements yet'),
                    SizedBox(height: 8),
                    Text(
                      'Billing cycles appear here once the card has charges.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) => _StatementTile(
              statement: list[index],
              creditCardId: creditCardId,
            ),
          );
        },
      ),
    );
  }
}

class _StatementTile extends ConsumerWidget {
  const _StatementTile({required this.statement, required this.creditCardId});

  final CardStatement statement;
  final String creditCardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    return Card(
      key: Key('statements.item.${statement.id}'),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          '${dates.format(statement.periodStart)} – '
          '${dates.format(statement.periodEnd)}',
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Due ${dates.format(statement.dueDate)}'),
            const SizedBox(height: 6),
            Row(
              children: [
                _StatusChip(
                  status: statement.status,
                  statementId: statement.id,
                ),
                if (statement.hasLateArrivals) ...[
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'Contains a late-arriving charge',
                    child: Icon(
                      Icons.schedule_outlined,
                      key: Key('statements.late.${statement.id}'),
                      size: 16,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: MoneyText(
          statement.amountDue,
          key: Key('statements.due.${statement.id}'),
          style: theme.textTheme.titleMedium,
        ),
        onTap: () => context.go(
          Routes.statementOf(
            creditCardId: creditCardId,
            statementId: statement.id,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.statementId});

  final StatementStatus status;
  final String statementId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Not colour alone (NFR-17): the state is named as well as tinted.
    final (background, foreground) = switch (status) {
      StatementStatus.open => (
        scheme.surfaceContainerHighest,
        scheme.onSurface,
      ),
      StatementStatus.closed => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      StatementStatus.settled => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
    };

    return Container(
      key: Key('statements.status.$statementId'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: foreground),
      ),
    );
  }
}

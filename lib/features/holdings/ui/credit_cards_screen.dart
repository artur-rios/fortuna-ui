/// Credit cards (UC-15).
///
/// The limit, what is used and what is left are three figures the API sends,
/// shown as three figures. The bar is drawn from them but nothing is read back
/// out of it — a proportion is a drawing instruction, not a number about money
/// (`FR-CH-08`, `IR-14`).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../shared/widgets/money_text.dart';
import '../data/credit_card_repository.dart';
import '../state/credit_card_providers.dart';
import 'credit_card_editor.dart';

class CreditCardsScreen extends ConsumerWidget {
  const CreditCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(creditCardsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Credit cards')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('cards.add'),
        onPressed: () => unawaited(showCreditCardEditor(context, ref)),
        icon: const Icon(Icons.add),
        label: const Text('New card'),
      ),
      body: cards.when(
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
                  key: const Key('cards.retry'),
                  onPressed: () => ref.invalidate(creditCardsProvider),
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
              key: const Key('cards.empty'),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.credit_card_outlined, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      'No cards yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a card to track its statements and what you owe.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('cards.emptyAdd'),
                      onPressed: () =>
                          unawaited(showCreditCardEditor(context, ref)),
                      child: const Text('Add a card'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) => _CardTile(card: list[index]),
          );
        },
      ),
    );
  }
}

class _CardTile extends ConsumerWidget {
  const _CardTile({required this.card});

  final CreditCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      key: Key('cards.item.${card.id}'),
      child: InkWell(
        onTap: () => unawaited(showCreditCardEditor(context, ref, card: card)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(card.name, style: theme.textTheme.titleMedium),
                  ),
                  if (card.lastFourDigits case final digits?
                      when digits.isNotEmpty)
                    Text('•••• $digits', style: theme.textTheme.bodySmall),
                ],
              ),
              if (card.issuer case final issuer? when issuer.isNotEmpty)
                Text(issuer, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),

              // Three figures, all the API's.
              Row(
                children: [
                  Expanded(
                    child: _Figure(
                      label: 'Used',
                      child: MoneyText(
                        card.usedAmount,
                        key: Key('cards.used.${card.id}'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _Figure(
                      label: 'Available',
                      child: MoneyText(
                        card.availableAmount,
                        key: Key('cards.available.${card.id}'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _Figure(
                      label: 'Limit',
                      child: MoneyText(
                        card.creditLimit,
                        key: Key('cards.limit.${card.id}'),
                      ),
                    ),
                  ),
                ],
              ),

              // The overage is its own line because it is its own figure: it
              // is not visible in the other three, and a card over its limit
              // should say so rather than leave the reader to subtract.
              if (card.isOverLimit) ...[
                const SizedBox(height: 8),
                Row(
                  key: Key('cards.overage.${card.id}'),
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    const Text('Over the limit by '),
                    MoneyText(
                      card.overageAmount,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Closes on day ${card.closingDay} · '
                      'due on day ${card.dueDay}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  // UC-16 step 1: the cycles are reached by opening the card,
                  // which is the only place they mean anything.
                  TextButton.icon(
                    key: Key('cards.statements.${card.id}'),
                    icon: const Icon(Icons.receipt_long_outlined, size: 18),
                    label: const Text('Statements'),
                    onPressed: () => context.go(Routes.statementsOf(card.id)),
                  ),
                ],
              ),
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

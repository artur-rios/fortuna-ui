/// One transaction: what it says, where it came from, and what may be done to
/// it (UC-20).
///
/// Two things this screen refuses to do, both of them deliberate:
///
/// - **It never edits the imported record.** That record is the evidence the
///   import is reconciled against (`AF-04`); if it could be changed it would
///   stop being evidence of anything. It is shown read-only, beside the
///   transaction's own values, so a correction reads as a difference rather
///   than quietly replacing what the institution actually said.
/// - **It never offers editing on a deleted transaction** (`AF-05`). What a
///   deleted record needs is restoration, which is UC-40's job.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../../core/result/result.dart';
import '../../../shared/widgets/money_text.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/transaction_repository.dart';
import '../state/transaction_providers.dart';
import 'transaction_editor.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionProvider(transactionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        actions: [
          // AF-05: editing is not offered on something that is deleted.
          if (transaction case AsyncData(value: final value)
              when value.isEditable)
            IconButton(
              key: const Key('transaction.edit'),
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  unawaited(showTransactionEditor(context, ref, value)),
            ),
        ],
      ),
      body: transaction.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // AF-02.
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$error',
                  key: const Key('transaction.error'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('transaction.retry'),
                  onPressed: () =>
                      ref.invalidate(transactionProvider(transactionId)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (value) => _Detail(transaction: value),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AF-05, stated before anything else: what this record is now.
        if (transaction.isDeleted)
          Card(
            key: const Key('transaction.deleted'),
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This transaction is deleted. It no longer appears in '
                      'any view except deleted records, where it can be '
                      'restored.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (transaction.isDeleted) const SizedBox(height: 16),

        MoneyText(
          transaction.amount,
          key: const Key('transaction.amount'),
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          // FR-MM-08: a transfer is neither an earning nor an expense, so it
          // is named as what it is rather than forced into a direction.
          transaction.isTransfer ? 'Transfer' : transaction.direction.label,
          key: const Key('transaction.direction'),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 24),

        _Field(
          label: 'Date',
          value: dates.format(transaction.occurredOn),
          fieldKey: 'transaction.date',
        ),
        if (transaction.categoryName case final name? when name.isNotEmpty)
          _Field(
            label: 'Category',
            value: name,
            fieldKey: 'transaction.category',
          ),
        if (transaction.holdingName case final name? when name.isNotEmpty)
          _Field(
            label: 'Account or card',
            value: name,
            fieldKey: 'transaction.holding',
          ),
        if (transaction.description case final text? when text.isNotEmpty)
          _Field(
            label: 'Description',
            value: text,
            fieldKey: 'transaction.description',
          ),
        if (transaction.counterpartyName case final name? when name.isNotEmpty)
          _Field(
            label: 'Counterparty',
            value: name,
            fieldKey: 'transaction.counterparty',
          ),
        if (transaction.tags.isNotEmpty)
          _Field(
            label: 'Tags',
            value: transaction.tags.join(', '),
            fieldKey: 'transaction.tags',
          ),

        const SizedBox(height: 16),

        // FR-MM-13: where this came from, always — a hand-entered record and
        // an imported one are different kinds of claim, and the reader should
        // not have to guess which they are looking at.
        Card(
          key: const Key('transaction.source'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Source', style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(transaction.source.label),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        _Reconciliation(transaction: transaction),

        // FR-MM-13 and AF-04: the raw record, read-only, with the reason.
        if (transaction.importedRecord case final record?) ...[
          const SizedBox(height: 16),
          _ImportedRecordCard(
            record: record,
            dates: dates,
            wasCorrected: transaction.isManuallyCorrected,
          ),
        ],
      ],
    );
  }
}

/// Reconciliation (UC-24).
///
/// `AF-01` and `AF-02` are both about saying what is true rather than showing
/// a control. A reconciled transaction states **which kind** of reconciliation
/// happened, because "an institution reported this" and "the user vouched for
/// it" are different claims that a single tick would flatten into one.
class _Reconciliation extends ConsumerStatefulWidget {
  const _Reconciliation({required this.transaction});

  final Transaction transaction;

  @override
  ConsumerState<_Reconciliation> createState() => _ReconciliationState();
}

class _ReconciliationState extends ConsumerState<_Reconciliation> {
  String? _error;
  var _busy = false;

  Future<void> _reconcile() async {
    setState(() {
      _error = null;
      _busy = true;
    });

    final record = widget.transaction.importedRecord;

    final result = await ref
        .read(transactionActionsProvider)
        .reconcile(
          id: widget.transaction.id,
          // Where the API proposed a match, it is what gets reconciled
          // against; where it did not, the user is confirming the transaction
          // themselves (AF-02).
          importedRecordId: record?.recordId,
          importJobId: record?.importJobId,
        );

    if (!mounted) return;

    switch (result) {
      // Step 4: the provider was invalidated, so the new state arrives on its
      // own and this widget rebuilds into the reconciled branch.
      case Success<Transaction>():
        setState(() => _busy = false);
      // AF-03 and AF-04, in the API's own words.
      case Failure<Transaction>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transaction = widget.transaction;

    // AF-01: the action is not offered, and the state is shown instead.
    if (transaction.reconciliationKind case final kind?) {
      return Card(
        key: const Key('transaction.reconciled'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.verified_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reconciled', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    // AF-02: which kind, said rather than implied.
                    Text(
                      kind.label,
                      key: const Key('transaction.reconciliationKind'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!transaction.canReconcile) return const SizedBox.shrink();

    final record = transaction.importedRecord;

    return Card(
      key: const Key('transaction.reconcile'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Not yet reconciled', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              // Step 2 and AF-02 say different things here, so the screen
              // does too: with a record, reconciling confirms a match; with
              // none, it is the user's own word and should read that way.
              record == null
                  ? 'No imported record matches this transaction. You can '
                        'still confirm it yourself — it will be recorded as '
                        'your own confirmation rather than as a match.'
                  : 'The instance proposes the imported record below as its '
                        'match. Reconciling confirms the two describe the '
                        'same movement.',
              key: const Key('transaction.reconcile.explanation'),
              style: theme.textTheme.bodySmall,
            ),

            if (_error case final message?) ...[
              const SizedBox(height: 12),
              Text(
                message,
                key: const Key('transaction.reconcile.error'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],

            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('transaction.reconcile.confirm'),
              icon: const Icon(Icons.check),
              label: Text(record == null ? 'Confirm it myself' : 'Reconcile'),
              onPressed: _busy ? null : () => unawaited(_reconcile()),
            ),
          ],
        ),
      ),
    );
  }
}

/// `AF-04`. Presented as evidence rather than as fields: there is no control
/// here to change anything, and the card says why.
class _ImportedRecordCard extends StatelessWidget {
  const _ImportedRecordCard({
    required this.record,
    required this.dates,
    required this.wasCorrected,
  });

  final ImportedRecord record;
  final DateFormat dates;
  final bool wasCorrected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: const Key('transaction.importedRecord'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_outline, size: 18),
                const SizedBox(width: 8),
                Text('The imported record', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This is what was imported, exactly as it arrived. It cannot be '
              'edited: it is the evidence the import is reconciled against, '
              'and a record that can be changed is evidence of nothing.',
              key: const Key('transaction.importedRecord.reason'),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (record.amount case final amount?)
              Row(
                children: [
                  const Text('Amount as imported'),
                  const Spacer(),
                  MoneyText(
                    amount,
                    key: const Key('transaction.importedRecord.amount'),
                  ),
                ],
              ),
            if (record.occurredOn case final date?) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Date as imported'),
                  const Spacer(),
                  Text(dates.format(date)),
                ],
              ),
            ],
            if (wasCorrected) ...[
              const SizedBox(height: 12),
              Row(
                key: const Key('transaction.manuallyCorrected'),
                children: [
                  Icon(
                    Icons.edit_note_outlined,
                    size: 16,
                    color: theme.colorScheme.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A value above was corrected after import. The original '
                      'is kept here.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.value,
    required this.fieldKey,
  });

  final String label;
  final String value;
  final String fieldKey;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
        Expanded(child: Text(value, key: Key(fieldKey))),
      ],
    ),
  );
}

/// A failure that the detail screen reports without losing the record.
void showTransactionFailure(BuildContext context, Result<void> result) {
  if (result case Failure(:final message)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

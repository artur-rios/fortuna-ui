/// One statement: its composition, its charges, and what may be done to it
/// (UC-16, steps 2 to 6).
///
/// Which actions appear is decided by the statement's state and nothing else.
/// An open statement can be closed; a closed one can be settled; a settled one
/// is frozen and offers neither (`AF-02`, `AF-04`). The screen never compares
/// dates to reach that conclusion — the instance's clock is the one that
/// counts, and it has already answered in the status.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/money.dart';
import '../../../core/format/supported_locales.dart';
import '../../../core/result/result.dart';
import '../../../shared/widgets/money_text.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/statement_repository.dart';
import '../state/account_providers.dart';
import '../state/statement_providers.dart';

class StatementScreen extends ConsumerWidget {
  const StatementScreen({
    required this.creditCardId,
    required this.statementId,
    super.key,
  });

  final String creditCardId;
  final String statementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.watch(statementProvider(statementId));

    return Scaffold(
      appBar: AppBar(title: const Text('Statement')),
      body: statement.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // AF-05: not found, and not yours, are the same answer.
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$error',
                  key: const Key('statement.error'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('statement.retry'),
                  onPressed: () => ref.invalidate(statementProvider(statementId)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (value) => _Statement(
          statement: value,
          creditCardId: creditCardId,
        ),
      ),
    );
  }
}

class _Statement extends ConsumerWidget {
  const _Statement({required this.statement, required this.creditCardId});

  final CardStatement statement;
  final String creditCardId;

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
        Text(
          '${dates.format(statement.periodStart)} – '
          '${dates.format(statement.periodEnd)}',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'Closes ${dates.format(statement.closingDate)} · '
          'due ${dates.format(statement.dueDate)}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),

        // The composition, as the API sent it. Six figures, no arithmetic.
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _Line(
                  label: 'Previous balance',
                  amount: statement.previousBalance,
                  fieldKey: 'statement.previousBalance',
                ),
                _Line(
                  label: 'Purchases',
                  amount: statement.purchaseTotal,
                  fieldKey: 'statement.purchaseTotal',
                ),
                _Line(
                  label: 'Payments received',
                  amount: statement.paymentsReceived,
                  fieldKey: 'statement.paymentsReceived',
                ),
                _Line(
                  label: 'Foreign tax',
                  amount: statement.foreignTaxTotal,
                  fieldKey: 'statement.foreignTaxTotal',
                ),
                _Line(
                  label: 'Other entries',
                  amount: statement.otherEntries,
                  fieldKey: 'statement.otherEntries',
                ),
                const Divider(height: 24),
                _Line(
                  label: 'Amount due',
                  amount: statement.amountDue,
                  fieldKey: 'statement.amountDue',
                  emphasized: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        _Actions(statement: statement, creditCardId: creditCardId),
        const SizedBox(height: 24),

        Text('Charges', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (statement.charges.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              key: Key('statement.noCharges'),
              child: Text('No charges in this period.'),
            ),
          )
        else
          for (final charge in statement.charges)
            _Charge(charge: charge, dates: dates),
      ],
    );
  }
}

/// Step 3, 4, and the reasons those steps are sometimes not offered.
class _Actions extends ConsumerWidget {
  const _Actions({required this.statement, required this.creditCardId});

  final CardStatement statement;
  final String creditCardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AF-04: settled is the end of the line. Say so, and offer nothing.
    if (statement.isFrozen) {
      return Card(
        key: const Key('statement.frozen'),
        child: const ListTile(
          leading: Icon(Icons.lock_outline),
          title: Text('Settled'),
          subtitle: Text(
            'This statement is paid and its composition is fixed. '
            'It can no longer be closed or settled.',
          ),
        ),
      );
    }

    if (statement.canClose) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AF-02: settlement is not offered, and the statement says why
          // rather than leaving a disabled control unexplained.
          Card(
            key: const Key('statement.notClosed'),
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Still open'),
              subtitle: Text(
                'Close this statement before settling it. Settling is offered '
                'once the composition is fixed.',
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            key: const Key('statement.close'),
            icon: const Icon(Icons.lock_clock_outlined),
            label: const Text('Close this statement'),
            onPressed: () => unawaited(_confirmClose(context, ref)),
          ),
        ],
      );
    }

    return FilledButton.icon(
      key: const Key('statement.settle'),
      icon: const Icon(Icons.swap_horiz),
      label: const Text('Settle this statement'),
      onPressed: () => unawaited(_openSettlement(context, ref)),
    );
  }

  /// Step 3: closing is irreversible and is presented as such (`FR-HO-07`).
  Future<void> _confirmClose(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close this statement?'),
        content: const Text(
          'Closing fixes what this statement contains. Charges that arrive '
          'afterwards go to the next cycle, and this cannot be undone.',
        ),
        actions: [
          TextButton(
            key: const Key('statement.close.cancel'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it open'),
          ),
          FilledButton(
            key: const Key('statement.close.confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Close it'),
          ),
        ],
      ),
    );

    if (!(confirmed ?? false)) return;

    final result = await ref
        .read(statementActionsProvider)
        .close(statementId: statement.id, creditCardId: creditCardId);

    // AF-01: closing too early is refused in the API's own words.
    if (result case Failure(:final message)) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _openSettlement(BuildContext context, WidgetRef ref) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _SettlementSheet(
            statement: statement,
            creditCardId: creditCardId,
          ),
        ),
      );
}

/// Step 4 and step 5: choosing the account the payment comes from, and saying
/// plainly that this is a transfer rather than an expense (`FR-HO-08`).
class _SettlementSheet extends ConsumerStatefulWidget {
  const _SettlementSheet({required this.statement, required this.creditCardId});

  final CardStatement statement;
  final String creditCardId;

  @override
  ConsumerState<_SettlementSheet> createState() => _SettlementSheetState();
}

class _SettlementSheetState extends ConsumerState<_SettlementSheet> {
  String? _accountId;
  late DateTime _paymentDate = DateTime.now();
  var _submitting = false;
  String? _reason;

  @override
  Widget build(BuildContext context) {
    final statement = widget.statement;
    final theme = Theme.of(context);
    final accounts = ref.watch(selectableAccountsProvider);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Settle this statement', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),

            // Step 5. Said in words, because the distinction is the point:
            // this money moves between the user's own things, and counting it
            // as spending would count the same money twice.
            Row(
              key: const Key('statement.settle.transferNotice'),
              children: [
                const Icon(Icons.swap_horiz, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recorded as a transfer between your accounts, not as an '
                    'expense — the charges were already counted when they '
                    'were made.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Text('Amount due'),
                const Spacer(),
                MoneyText(
                  statement.amountDue,
                  key: const Key('statement.settle.amount'),
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            accounts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('$error'),
              data: (list) => DropdownButtonFormField<String>(
                key: const Key('statement.settle.account'),
                initialValue: _accountId,
                decoration: const InputDecoration(
                  labelText: 'Pay from',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final account in list)
                    DropdownMenuItem(
                      value: account.id,
                      child: Text('${account.name} · ${account.currencyCode}'),
                    ),
                ],
                onChanged: (value) => setState(() => _accountId = value),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              key: const Key('statement.settle.date'),
              icon: const Icon(Icons.event_outlined),
              label: Text(
                'Paid on ${DateFormat.yMMMd(locale).format(_paymentDate)}',
              ),
              onPressed: _submitting ? null : _pickDate,
            ),

            if (_reason case final reason?) ...[
              const SizedBox(height: 16),
              // AF-03 arrives here: a different currency is the API's refusal
              // to state, and nothing is converted on the way to showing it.
              Text(
                reason,
                key: const Key('statement.settle.reason'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],

            const SizedBox(height: 20),
            FilledButton(
              key: const Key('statement.settle.confirm'),
              onPressed: (_accountId == null || _submitting) ? null : _settle,
              child: _submitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Settle'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) setState(() => _paymentDate = picked);
  }

  Future<void> _settle() async {
    final accountId = _accountId;
    if (accountId == null) return;

    setState(() {
      _submitting = true;
      _reason = null;
    });

    final navigator = Navigator.of(context);
    final result = await ref
        .read(statementActionsProvider)
        .settle(
          statementId: widget.statement.id,
          creditCardId: widget.creditCardId,
          financialAccountId: accountId,
          // The amount as the API stated it, handed straight back. Never
          // re-derived, never rounded on the way through.
          amount: widget.statement.amountDue.asApiString,
          paymentDate: _paymentDate,
        );

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        navigator.pop();
      case Failure<void>(:final message):
        setState(() {
          _submitting = false;
          _reason = message;
        });
    }
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.amount,
    required this.fieldKey,
    this.emphasized = false,
  });

  final String label;
  final Money amount;
  final String fieldKey;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasized
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          MoneyText(amount, key: Key(fieldKey), style: style),
        ],
      ),
    );
  }
}

class _Charge extends StatelessWidget {
  const _Charge({required this.charge, required this.dates});

  final StatementCharge charge;
  final DateFormat dates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      key: Key('statement.charge.${charge.id}'),
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(dates.format(charge.occurredOn)),
          // FR-HO-09: marked in the statement that received it, with a word
          // rather than a colour alone.
          if (charge.isLateArriving) ...[
            const SizedBox(width: 8),
            Container(
              key: Key('statement.charge.late.${charge.id}'),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Late arrival',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: charge.wasConverted
          ? Row(
              key: Key('statement.charge.converted.${charge.id}'),
              children: [
                const Text('Charged as '),
                MoneyText(
                  charge.originalAmount!,
                  style: theme.textTheme.bodySmall,
                ),
                if (charge.appliedRate case final rate?)
                  Text(' at $rate', style: theme.textTheme.bodySmall),
              ],
            )
          : null,
      trailing: MoneyText(charge.amount),
    );
  }
}

/// Recording a transfer (UC-21).
///
/// Step 5 is the part that matters most and is easiest to get wrong: the
/// result is presented **as a transfer**, not as two transactions. Money the
/// user moves between their own accounts is neither income nor spending, and
/// showing it as either would inflate both totals by the same amount — a
/// distortion that looks plausible on every screen it reaches.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/format/money_parser.dart';
import '../../../core/format/supported_locales.dart';
import '../../../core/result/result.dart';
import '../../../shared/widgets/money_text.dart';
import '../../holdings/data/account_repository.dart';
import '../../holdings/state/account_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/transfer_repository.dart';
import '../state/transfer_form.dart';

class RecordTransferScreen extends ConsumerStatefulWidget {
  const RecordTransferScreen({super.key});

  @override
  ConsumerState<RecordTransferScreen> createState() =>
      _RecordTransferScreenState();
}

class _RecordTransferScreenState extends ConsumerState<RecordTransferScreen> {
  final _amount = TextEditingController();

  DateTime _date = DateTime.now();
  String? _originId;
  String? _destinationId;

  String? _error;
  var _busy = false;
  Transfer? _recorded;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  MoneyParser get _parser =>
      MoneyParser(SupportedLocales.tagOf(ref.read(preferencesProvider).locale));

  Future<void> _submit() async {
    final problem = TransferRules.validate(
      amountText: _amount.text,
      originAccountId: _originId,
      destinationAccountId: _destinationId,
      parser: _parser,
    );

    if (problem != null) {
      setState(() => _error = problem.message);
      return;
    }

    setState(() {
      _error = null;
      _busy = true;
    });

    final result = await ref
        .read(transferActionsProvider)
        .submit(
          originAccountId: _originId!,
          destinationAccountId: _destinationId!,
          amount: _parser.parse(_amount.text)!,
          occurredOn: _date,
        );

    if (!mounted) return;

    switch (result) {
      case Success<Transfer>(:final value):
        setState(() {
          _recorded = value;
          _busy = false;
        });
      // AF-03, AF-04 and AF-05 all arrive here in the API's own words, with
      // the entry kept so another attempt costs nothing.
      case Failure<Transfer>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(selectableAccountsProvider);

    final recorded = _recorded;
    if (recorded != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transferred')),
        body: _Confirmation(transfer: recorded),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Record a transfer')),
      body: accounts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text('$error', textAlign: TextAlign.center),
          ),
        ),
        data: (list) {
          // AF-06: a transfer needs two accounts, and saying so beats
          // presenting two pickers that cannot both be satisfied.
          if (list.length < accountsNeededForTransfer) {
            return _NotEnoughAccounts(held: list.length);
          }

          return _buildForm(list);
        },
      ),
    );
  }

  Widget _buildForm(List<FinancialAccount> accounts) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          key: const Key('recordTransfer.origin'),
          initialValue: _originId,
          decoration: const InputDecoration(
            labelText: 'From',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final account in accounts)
              DropdownMenuItem(
                value: account.id,
                child: Text('${account.name} · ${account.currencyCode}'),
              ),
          ],
          onChanged: _busy
              ? null
              : (value) => setState(() => _originId = value),
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          key: const Key('recordTransfer.destination'),
          initialValue: _destinationId,
          decoration: const InputDecoration(
            labelText: 'To',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final account in accounts)
              DropdownMenuItem(
                value: account.id,
                child: Text('${account.name} · ${account.currencyCode}'),
              ),
          ],
          onChanged: _busy
              ? null
              : (value) => setState(() => _destinationId = value),
        ),
        const SizedBox(height: 12),

        TextField(
          key: const Key('recordTransfer.amount'),
          controller: _amount,
          enabled: !_busy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount',
            // The origin's currency: the amount is what leaves that account.
            // Where the destination differs the API converts, and says so in
            // the confirmation (AF-03).
            suffixText: _currencyOf(accounts, _originId),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        OutlinedButton.icon(
          key: const Key('recordTransfer.date'),
          icon: const Icon(Icons.event_outlined),
          label: Text(DateFormat.yMMMd(locale).format(_date)),
          onPressed: _busy ? null : _pickDate,
        ),

        if (_error case final message?) ...[
          const SizedBox(height: 16),
          Text(
            message,
            key: const Key('recordTransfer.error'),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],

        const SizedBox(height: 20),
        FilledButton(
          key: const Key('recordTransfer.submit'),
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Transfer'),
        ),
      ],
    );
  }

  String _currencyOf(List<FinancialAccount> accounts, String? id) {
    if (id == null) return '';
    for (final account in accounts) {
      if (account.id == id) return account.currencyCode;
    }
    return '';
  }
}

/// AF-06.
class _NotEnoughAccounts extends StatelessWidget {
  const _NotEnoughAccounts({required this.held});

  final int held;

  @override
  Widget build(BuildContext context) => Center(
    key: const Key('recordTransfer.notEnoughAccounts'),
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.swap_horiz, size: 40),
          const SizedBox(height: 16),
          Text(
            'A transfer needs two accounts',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            held == 0
                ? 'You have no accounts yet. Create two, then come back.'
                : 'You have one account. Money moves between two of your own '
                      'accounts, so create another to transfer between them.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('recordTransfer.createAccount'),
            onPressed: () => context.go(Routes.accounts),
            child: const Text('Go to accounts'),
          ),
        ],
      ),
    ),
  );
}

/// Step 5: presented as a transfer, and said in words.
class _Confirmation extends StatelessWidget {
  const _Confirmation({required this.transfer});

  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          key: const Key('recordTransfer.confirmation'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Transferred', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            MoneyText(
              transfer.outboundAmount,
              key: const Key('recordTransfer.outbound'),
              style: theme.textTheme.headlineSmall,
            ),

            // AF-03: where the API converted, both sides and the rate it used
            // are shown. The client converts nothing and invents no figure.
            if (transfer.wasConverted) ...[
              const SizedBox(height: 8),
              const Icon(Icons.arrow_downward, size: 18),
              const SizedBox(height: 8),
              MoneyText(
                transfer.inboundAmount,
                key: const Key('recordTransfer.inbound'),
                style: theme.textTheme.headlineSmall,
              ),
              if (transfer.appliedRate case final rate?) ...[
                const SizedBox(height: 8),
                Text(
                  'Converted by the instance at $rate',
                  key: const Key('recordTransfer.rate'),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],

            const SizedBox(height: 16),
            // Step 5, stated plainly. This is the sentence that keeps a
            // transfer from being read as income or spending.
            Text(
              'Recorded as a transfer between your own accounts. It counts as '
              'neither an earning nor an expense, so it does not appear in '
              'either total.',
              key: const Key('recordTransfer.notAnExpense'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),

            const SizedBox(height: 32),
            FilledButton(
              key: const Key('recordTransfer.done'),
              onPressed: () => context.go(Routes.accounts),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

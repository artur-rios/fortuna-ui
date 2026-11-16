/// Defining and editing a goal (UC-29, steps 2 to 4).
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/format/money_parser.dart';
import '../../../core/format/supported_locales.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';
import '../../holdings/data/account_repository.dart';
import '../../holdings/data/investment_repository.dart';
import '../../holdings/state/account_providers.dart';
import '../../holdings/state/investment_providers.dart';
import '../../preferences/state/currency_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/goal_repository.dart';
import '../state/goal_providers.dart';

Future<void> showGoalEditor(
  BuildContext context,
  WidgetRef ref, {
  Goal? goal,
}) => showDialog<void>(
  context: context,
  builder: (context) => GoalEditor(goal: goal),
);

class GoalEditor extends ConsumerStatefulWidget {
  const GoalEditor({this.goal, super.key});

  final Goal? goal;

  @override
  ConsumerState<GoalEditor> createState() => _GoalEditorState();
}

class _GoalEditorState extends ConsumerState<GoalEditor> {
  late final _name = TextEditingController(text: widget.goal?.name ?? '');
  late final _amount = TextEditingController(
    text: widget.goal?.targetAmount.asApiString ?? '',
  );

  late DateTime? _targetDate = widget.goal?.targetDate;
  late String? _currency = widget.goal?.targetAmount.currencyCode;

  /// What the goal tracks: its progress is what these hold (step 2).
  late final _accountIds = <String>{...?widget.goal?.accountIds};
  late final _investmentIds = <String>{...?widget.goal?.investmentIds};

  String? _error;
  var _busy = false;

  bool get _isNew => widget.goal == null;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  MoneyParser get _parser =>
      MoneyParser(SupportedLocales.tagOf(ref.read(preferencesProvider).locale));

  Future<void> _save() async {
    final parser = _parser;

    // Step 3, and AF-01 and AF-02.
    final problem = GoalRules.validate(
      name: _name.text,
      amountText: _amount.text,
      targetDate: _targetDate,
      holdingCount: _accountIds.length + _investmentIds.length,
      now: ref.now(),
      isReadableAmount: (text) => parser.parse(text) != null,
      isPositiveAmount: parser.isPositive,
    );

    if (problem != null) {
      setState(() => _error = problem.message);
      return;
    }

    if (_isNew && (_currency == null || _currency!.isEmpty)) {
      setState(() => _error = 'Choose the currency this goal is set in.');
      return;
    }

    setState(() {
      _error = null;
      _busy = true;
    });

    final actions = ref.read(goalActionsProvider);
    // The exact decimal, serialized. Never a number on the wire.
    final amount = parser.parse(_amount.text)!.toString();

    final result = _isNew
        ? await actions.create(
            name: _name.text.trim(),
            targetAmount: amount,
            currencyCode: _currency!,
            targetDate: _targetDate!,
            accountIds: _accountIds.toList(),
            investmentIds: _investmentIds.toList(),
          )
        : await actions.update(
            id: widget.goal!.id,
            name: _name.text.trim(),
            targetAmount: amount,
            currencyCode: widget.goal!.targetAmount.currencyCode,
            targetDate: _targetDate!,
            // Every link, kept or changed: the API replaces the goal's links
            // with what an update names.
            accountIds: _accountIds.toList(),
            investmentIds: _investmentIds.toList(),
          );

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  Future<void> _delete() async {
    final goal = widget.goal;
    if (goal == null) return;

    setState(() => _busy = true);
    final result = await ref.read(goalActionsProvider).delete(goal.id);

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  static void _toggle(Set<String> chosen, String id) {
    if (!chosen.remove(id)) chosen.add(id);
  }

  Future<void> _pickTargetDate() async {
    final tomorrow = ref.now().add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? tomorrow,
      // AF-02, prevented in the picker as well as checked in the rule: the
      // rule is what makes the refusal correct, this is what makes it rare.
      firstDate: tomorrow,
      lastDate: DateTime(2100),
    );

    if (picked != null) setState(() => _targetDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final currencies = ref.watch(supportedCurrenciesProvider);

    return AlertDialog(
      title: Text(_isNew ? 'New goal' : 'Edit goal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('goalEditor.name'),
              controller: _name,
              autofocus: true,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              key: const Key('goalEditor.amount'),
              controller: _amount,
              enabled: !_busy,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Target',
                suffixText:
                    _currency ?? widget.goal?.targetAmount.currencyCode ?? '',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            if (_isNew) ...[
              currencies.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) =>
                    Text('The supported currencies could not be read: $error'),
                data: (list) => DropdownButtonFormField<String>(
                  key: const Key('goalEditor.currency'),
                  initialValue: _currency,
                  decoration: const InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final currency in list)
                      DropdownMenuItem(
                        value: currency.code,
                        child: Text(currency.code),
                      ),
                  ],
                  onChanged: _busy
                      ? null
                      : (value) => setState(() => _currency = value),
                ),
              ),
              const SizedBox(height: 12),
            ],

            OutlinedButton.icon(
              key: const Key('goalEditor.targetDate'),
              icon: const Icon(Icons.event_outlined),
              label: Text(
                _targetDate == null
                    ? 'Choose the date to reach it by'
                    : 'By ${DateFormat.yMMMd(locale).format(_targetDate!)}',
              ),
              onPressed: _busy ? null : () => unawaited(_pickTargetDate()),
            ),
            const SizedBox(height: 16),

            Text('Tracks', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _Holdings(
              accounts: ref.watch(selectableAccountsProvider),
              investments: ref.watch(investmentsProvider),
              accountIds: _accountIds,
              investmentIds: _investmentIds,
              enabled: !_busy,
              onToggleAccount: (id) => setState(() => _toggle(_accountIds, id)),
              onToggleInvestment: (id) =>
                  setState(() => _toggle(_investmentIds, id)),
            ),

            if (_error case final message?) ...[
              const SizedBox(height: 16),
              Text(
                message,
                key: const Key('goalEditor.error'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isNew)
          TextButton(
            key: const Key('goalEditor.delete'),
            onPressed: _busy ? null : () => unawaited(_delete()),
            child: Text(
              'Delete',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        TextButton(
          key: const Key('goalEditor.cancel'),
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('goalEditor.save'),
          onPressed: _busy ? null : () => unawaited(_save()),
          child: Text(_isNew ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}

/// The accounts and investments a goal can track (step 2, `AF-07`, `AF-08`).
///
/// Only live ones are offered: a deleted account holds nothing a goal could
/// count, and the investments list already leaves deleted ones out.
class _Holdings extends StatelessWidget {
  const _Holdings({
    required this.accounts,
    required this.investments,
    required this.accountIds,
    required this.investmentIds,
    required this.enabled,
    required this.onToggleAccount,
    required this.onToggleInvestment,
  });

  final AsyncValue<List<FinancialAccount>> accounts;
  final AsyncValue<List<Investment>> investments;
  final Set<String> accountIds;
  final Set<String> investmentIds;
  final bool enabled;
  final void Function(String id) onToggleAccount;
  final void Function(String id) onToggleInvestment;

  @override
  Widget build(BuildContext context) {
    final failure = accounts.error ?? investments.error;
    if (failure != null) {
      return Text(
        'The accounts and investments could not be read: $failure',
        key: const Key('goalEditor.holdingsFailed'),
      );
    }

    final (accountList, investmentList) = (accounts.value, investments.value);
    if (accountList == null || investmentList == null) {
      return const LinearProgressIndicator();
    }

    // AF-08: a goal is measured by what is held somewhere, so with nothing
    // held there is nothing to offer, and the editor says where to start.
    if (accountList.isEmpty && investmentList.isEmpty) {
      return const Text(
        'There is no account or investment to track yet. Add one under '
        'Accounts or Investments first.',
        key: Key('goalEditor.noHoldings'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final account in accountList)
          FilterChip(
            key: Key('goalEditor.account.${account.id}'),
            avatar: const Icon(Icons.account_balance_outlined, size: 18),
            label: Text(account.name),
            selected: accountIds.contains(account.id),
            onSelected: enabled ? (_) => onToggleAccount(account.id) : null,
          ),
        for (final investment in investmentList)
          FilterChip(
            key: Key('goalEditor.investment.${investment.id}'),
            avatar: const Icon(Icons.trending_up, size: 18),
            label: Text(investment.instrument),
            selected: investmentIds.contains(investment.id),
            onSelected: enabled
                ? (_) => onToggleInvestment(investment.id)
                : null,
          ),
      ],
    );
  }
}

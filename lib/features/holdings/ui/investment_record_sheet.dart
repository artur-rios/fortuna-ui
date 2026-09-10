/// Recording a movement or a valuation against an investment (UC-18).
///
/// Two forms behind one sheet, because they are two answers to the same
/// question — what changed about this investment. A movement says money went
/// in or out; a valuation says what the holding was worth on a day. They are
/// deliberately not merged: recording a valuation as a contribution would
/// overstate what was put in, and the position would then be wrong in a way
/// nothing on screen could explain.
///
/// Both amounts are held and sent as the string the user typed. Neither is
/// parsed to a number anywhere on the path (`IR-14`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../../core/result/result.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/investment_repository.dart';
import '../state/account_providers.dart';
import '../state/investment_providers.dart';

/// Which of the two records is being made.
enum RecordKind { movement, valuation }

Future<void> showInvestmentRecordSheet(
  BuildContext context,
  WidgetRef ref, {
  required Investment investment,
  required RecordKind kind,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: InvestmentRecordSheet(investment: investment, kind: kind),
  ),
);

class InvestmentRecordSheet extends ConsumerStatefulWidget {
  const InvestmentRecordSheet({
    required this.investment,
    required this.kind,
    super.key,
  });

  final Investment investment;
  final RecordKind kind;

  @override
  ConsumerState<InvestmentRecordSheet> createState() =>
      _InvestmentRecordSheetState();
}

class _InvestmentRecordSheetState extends ConsumerState<InvestmentRecordSheet> {
  final _amount = TextEditingController();

  late DateTime _date = DateTime.now();
  MovementType _type = MovementType.contribution;
  String? _accountId;

  String? _error;
  var _busy = false;

  bool get _isMovement => widget.kind == RecordKind.movement;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  /// Step 3: the two rules the specification states, and no others. Whether a
  /// valuation already exists for this date is `AF-03`, which is the API's to
  /// answer, and whether the currency matches is `AF-05`, likewise.
  String? _validate() {
    if (!InvestmentRules.isPositiveAmount(_amount.text)) {
      return _isMovement
          ? 'The amount must be greater than zero.'
          : 'The value must be greater than zero.';
    }

    if (!InvestmentRules.isNotInFuture(_date, now: DateTime.now())) {
      return 'That date is in the future. Record it on or before today.';
    }

    return null;
  }

  Future<void> _submit() async {
    final problem = _validate();
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }

    setState(() {
      _error = null;
      _busy = true;
    });

    final actions = ref.read(investmentActionsProvider);

    final result = _isMovement
        ? await actions.recordMovement(
            investmentId: widget.investment.id,
            type: _type,
            // The string as typed, unrounded and unparsed.
            amount: _amount.text.trim(),
            occurredOn: _date,
            financialAccountId: _accountId,
          )
        : await actions.recordValuation(
            investmentId: widget.investment.id,
            value: _amount.text.trim(),
            valuedOn: _date,
          );

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-03, AF-04 and AF-05 all arrive here in the API's own words.
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      // AF-02, prevented in the picker as well as checked in the rule: the
      // rule is what makes the refusal correct, this is what makes it rare.
      lastDate: now,
    );

    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              _isMovement ? 'Record a movement' : 'Record a valuation',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              _isMovement
                  ? 'Money going into or out of ${widget.investment.instrument}.'
                  : 'What ${widget.investment.instrument} was worth on a day.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),

            if (_isMovement) ...[
              DropdownButtonFormField<MovementType>(
                key: const Key('investmentRecord.type'),
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Kind',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final type in MovementType.values)
                    DropdownMenuItem(value: type, child: Text(type.label)),
                ],
                onChanged: _busy
                    ? null
                    : (value) => setState(
                        () => _type = value ?? MovementType.contribution,
                      ),
              ),
              const SizedBox(height: 12),
            ],

            TextField(
              key: const Key('investmentRecord.amount'),
              controller: _amount,
              autofocus: true,
              enabled: !_busy,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: _isMovement ? 'Amount' : 'Value',
                // The investment's own currency, stated rather than chosen:
                // a movement in another currency is AF-05, and offering a
                // picker here would imply this client could convert it.
                suffixText: widget.investment.currencyCode,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              key: const Key('investmentRecord.date'),
              icon: const Icon(Icons.event_outlined),
              label: Text(DateFormat.yMMMd(locale).format(_date)),
              onPressed: _busy ? null : _pickDate,
            ),

            if (_isMovement) ...[
              const SizedBox(height: 12),
              accounts.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('$error'),
                data: (list) => DropdownButtonFormField<String>(
                  key: const Key('investmentRecord.account'),
                  initialValue: _accountId,
                  decoration: const InputDecoration(
                    labelText: 'From account (optional)',
                    border: OutlineInputBorder(),
                    helperText:
                        'Links this movement to where the money came '
                        'from or went.',
                  ),
                  items: [
                    for (final account in list)
                      DropdownMenuItem(
                        value: account.id,
                        child: Text(
                          '${account.name} · ${account.currencyCode}',
                        ),
                      ),
                  ],
                  onChanged: _busy
                      ? null
                      : (value) => setState(() => _accountId = value),
                ),
              ),
            ],

            if (_error case final message?) ...[
              const SizedBox(height: 16),
              Text(
                message,
                key: const Key('investmentRecord.error'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],

            const SizedBox(height: 20),
            FilledButton(
              key: const Key('investmentRecord.submit'),
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Record'),
            ),
          ],
        ),
      ),
    );
  }
}

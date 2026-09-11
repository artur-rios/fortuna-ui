/// Defining and editing a goal (UC-29, steps 2 to 4).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/money_parser.dart';
import '../../../core/format/supported_locales.dart';
import '../../../core/result/result.dart';
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
      now: DateTime.now(),
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
          )
        : await actions.update(
            id: widget.goal!.id,
            name: _name.text.trim(),
            targetAmount: amount,
            currencyCode: widget.goal!.targetAmount.currencyCode,
            targetDate: _targetDate!,
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

  Future<void> _pickTargetDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

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

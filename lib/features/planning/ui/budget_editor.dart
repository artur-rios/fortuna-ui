/// Defining and editing a budget (UC-28, steps 2 to 4).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/money_parser.dart';
import '../../../core/format/supported_locales.dart';
import '../../../core/result/result.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/state/category_providers.dart';
import '../../preferences/state/currency_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/budget_repository.dart';
import '../state/budget_providers.dart';

Future<void> showBudgetEditor(
  BuildContext context,
  WidgetRef ref, {
  Budget? budget,
}) => showDialog<void>(
  context: context,
  builder: (context) => BudgetEditor(budget: budget),
);

class BudgetEditor extends ConsumerStatefulWidget {
  const BudgetEditor({this.budget, super.key});

  final Budget? budget;

  @override
  ConsumerState<BudgetEditor> createState() => _BudgetEditorState();
}

class _BudgetEditorState extends ConsumerState<BudgetEditor> {
  late final _amount = TextEditingController(
    text: widget.budget?.amount.asApiString ?? '',
  );

  late BudgetPeriod _period = widget.budget?.period ?? BudgetPeriod.monthly;
  late DateTime? _periodStart = widget.budget?.periodStart;
  late String? _currency = widget.budget?.amount.currencyCode;
  late bool _includeDescendants = widget.budget?.includeDescendants ?? false;

  /// Seeded from the tree once it loads, because the budget carries its
  /// categories by name rather than by id.
  final _categoryIds = <String>{};
  var _seededCategories = false;

  String? _error;
  var _busy = false;

  bool get _isNew => widget.budget == null;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  MoneyParser get _parser =>
      MoneyParser(SupportedLocales.tagOf(ref.read(preferencesProvider).locale));

  Future<void> _save() async {
    final parser = _parser;

    // Step 3, and AF-01 and AF-02.
    final problem = BudgetRules.validate(
      amountText: _amount.text,
      periodStart: _periodStart,
      categoryIds: _categoryIds.toList(),
      isReadableAmount: (text) => parser.parse(text) != null,
      isPositiveAmount: parser.isPositive,
    );

    if (problem != null) {
      setState(() => _error = problem.message);
      return;
    }

    if (_isNew && (_currency == null || _currency!.isEmpty)) {
      setState(() => _error = 'Choose the currency this budget is set in.');
      return;
    }

    setState(() {
      _error = null;
      _busy = true;
    });

    final actions = ref.read(budgetActionsProvider);
    // The exact decimal, serialized. Never a number on the wire.
    final amount = parser.parse(_amount.text)!.toString();

    final result = _isNew
        ? await actions.create(
            categoryIds: _categoryIds.toList(),
            amount: amount,
            currencyCode: _currency!,
            period: _period,
            periodStart: _periodStart!,
            includeDescendants: _includeDescendants,
          )
        : await actions.update(
            id: widget.budget!.id,
            categoryIds: _categoryIds.toList(),
            amount: amount,
            currencyCode: widget.budget!.amount.currencyCode,
            period: _period,
            periodStart: _periodStart!,
            includeDescendants: _includeDescendants,
          );

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-03: an overlapping budget, in the API's own words.
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  Future<void> _delete() async {
    final budget = widget.budget;
    if (budget == null) return;

    setState(() => _busy = true);
    final result = await ref.read(budgetActionsProvider).delete(budget.id);

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

  Future<void> _pickPeriodStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _periodStart ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) setState(() => _periodStart = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final currencies = ref.watch(supportedCurrenciesProvider);

    final categories = switch (ref.watch(categoryTreeProvider)) {
      AsyncData(:final value) =>
        value.all.where((category) => !category.isDeleted).toList(),
      _ => const <Category>[],
    };

    // Tick the categories this budget already covers, once the tree is here
    // to match them against. Done by name because that is what the budget
    // payload carries; an id would be better and is worth asking the API for.
    if (!_seededCategories && categories.isNotEmpty) {
      final existing = widget.budget?.categoryNames ?? const <String>[];
      if (existing.isNotEmpty) {
        for (final category in categories) {
          if (existing.contains(category.name)) _categoryIds.add(category.id);
        }
      }
      _seededCategories = true;
    }

    return AlertDialog(
      title: Text(_isNew ? 'New budget' : 'Edit budget'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('budgetEditor.amount'),
                controller: _amount,
                autofocus: true,
                enabled: !_busy,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Ceiling',
                  suffixText:
                      _currency ?? widget.budget?.amount.currencyCode ?? '',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              if (_isNew)
                currencies.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, _) => Text(
                    'The supported currencies could not be read: $error',
                  ),
                  data: (list) => DropdownButtonFormField<String>(
                    key: const Key('budgetEditor.currency'),
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
              if (_isNew) const SizedBox(height: 12),

              DropdownButtonFormField<BudgetPeriod>(
                key: const Key('budgetEditor.period'),
                initialValue: _period,
                decoration: const InputDecoration(
                  labelText: 'Period',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final period in BudgetPeriod.values)
                    DropdownMenuItem(value: period, child: Text(period.label)),
                ],
                onChanged: _busy
                    ? null
                    : (value) => setState(
                        () => _period = value ?? BudgetPeriod.monthly,
                      ),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                key: const Key('budgetEditor.periodStart'),
                icon: const Icon(Icons.event_outlined),
                label: Text(
                  _periodStart == null
                      ? 'Choose when the period starts'
                      : 'Starts ${DateFormat.yMMMd(locale).format(_periodStart!)}',
                ),
                onPressed: _busy ? null : () => unawaited(_pickPeriodStart()),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text('Categories', style: theme.textTheme.titleSmall),
              ),
              for (final category in categories)
                CheckboxListTile(
                  key: Key('budgetEditor.category.${category.id}'),
                  value: _categoryIds.contains(category.id),
                  onChanged: _busy
                      ? null
                      : (on) => setState(() {
                          (on ?? false)
                              ? _categoryIds.add(category.id)
                              : _categoryIds.remove(category.id);
                        }),
                  title: Text(category.name),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),

              CheckboxListTile(
                key: const Key('budgetEditor.includeDescendants'),
                value: _includeDescendants,
                onChanged: _busy
                    ? null
                    : (on) => setState(() => _includeDescendants = on ?? false),
                title: const Text('Include sub-categories'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),

              if (_error case final message?) ...[
                const SizedBox(height: 16),
                Text(
                  message,
                  key: const Key('budgetEditor.error'),
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (!_isNew)
          TextButton(
            key: const Key('budgetEditor.delete'),
            onPressed: _busy ? null : () => unawaited(_delete()),
            child: Text(
              'Delete',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        TextButton(
          key: const Key('budgetEditor.cancel'),
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('budgetEditor.save'),
          onPressed: _busy ? null : () => unawaited(_save()),
          child: Text(_isNew ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}

/// Creating and editing an investment (UC-17, steps 2 and 4).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../preferences/state/currency_providers.dart';
import '../data/investment_repository.dart';
import '../state/investment_providers.dart';

Future<void> showInvestmentEditor(
  BuildContext context,
  WidgetRef ref, {
  Investment? investment,
}) => showDialog<void>(
  context: context,
  builder: (context) => InvestmentEditor(investment: investment),
);

class InvestmentEditor extends ConsumerStatefulWidget {
  const InvestmentEditor({this.investment, super.key});

  final Investment? investment;

  @override
  ConsumerState<InvestmentEditor> createState() => _InvestmentEditorState();
}

class _InvestmentEditorState extends ConsumerState<InvestmentEditor> {
  late final _instrument = TextEditingController(
    text: widget.investment?.instrument ?? '',
  );
  late final _institution = TextEditingController(
    text: widget.investment?.institution ?? '',
  );

  late String? _currency = widget.investment?.currencyCode;
  late InvestmentType _type = widget.investment?.type ?? InvestmentType.other;

  String? _error;
  var _busy = false;

  bool get _isNew => widget.investment == null;

  @override
  void dispose() {
    _instrument.dispose();
    _institution.dispose();
    super.dispose();
  }

  /// `AF-01`, and only `AF-01`. Whether the instrument duplicates another is
  /// the API's judgement (`AF-02`) — guessing at it here would refuse names
  /// the API would have accepted.
  String? _validate() {
    if (!InvestmentRules.isPresent(_instrument.text)) {
      return 'Name the instrument.';
    }
    if (_isNew && (_currency == null || _currency!.isEmpty)) {
      return 'Choose the currency this investment is held in.';
    }
    return null;
  }

  Future<void> _save() async {
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
    final institution = _institution.text.trim();

    final result = _isNew
        ? await actions.create(
            instrument: _instrument.text.trim(),
            currencyCode: _currency!,
            type: _type,
            institution: institution.isEmpty ? null : institution,
          )
        : await actions.update(
            id: widget.investment!.id,
            instrument: _instrument.text.trim(),
            type: _type,
            institution: institution.isEmpty ? null : institution,
          );

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-02, in the API's own words.
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  Future<void> _delete() async {
    final investment = widget.investment;
    if (investment == null) return;

    setState(() => _busy = true);
    final result = await ref
        .read(investmentActionsProvider)
        .delete(investment.id);

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-04: movements still reference it, in the API's words.
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencies = ref.watch(supportedCurrenciesProvider);

    return AlertDialog(
      title: Text(_isNew ? 'New investment' : 'Edit investment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('investmentEditor.instrument'),
              controller: _instrument,
              autofocus: true,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Instrument',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('investmentEditor.institution'),
              controller: _institution,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Institution (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<InvestmentType>(
              key: const Key('investmentEditor.type'),
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final type in InvestmentType.values)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: _busy
                  ? null
                  : (value) =>
                        setState(() => _type = value ?? InvestmentType.other),
            ),

            // The currency is fixed after creation, as it is for an account:
            // changing it would reinterpret every figure already recorded.
            if (_isNew) ...[
              const SizedBox(height: 12),
              currencies.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) =>
                    Text('The supported currencies could not be read: $error'),
                data: (list) => DropdownButtonFormField<String>(
                  key: const Key('investmentEditor.currency'),
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
            ],

            if (_error case final message?) ...[
              const SizedBox(height: 16),
              Text(
                message,
                key: const Key('investmentEditor.error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isNew)
          TextButton(
            key: const Key('investmentEditor.delete'),
            onPressed: _busy ? null : () => unawaited(_delete()),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        TextButton(
          key: const Key('investmentEditor.cancel'),
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('investmentEditor.save'),
          onPressed: _busy ? null : () => unawaited(_save()),
          child: Text(_isNew ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}

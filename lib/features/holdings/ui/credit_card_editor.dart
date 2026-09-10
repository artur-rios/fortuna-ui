/// Creating and editing a credit card (UC-15).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../preferences/state/currency_providers.dart';
import '../data/credit_card_repository.dart';
import '../state/credit_card_providers.dart';

Future<void> showCreditCardEditor(
  BuildContext context,
  WidgetRef ref, {
  CreditCard? card,
}) => showDialog<void>(
  context: context,
  builder: (context) => CreditCardEditor(card: card),
);

class CreditCardEditor extends ConsumerStatefulWidget {
  const CreditCardEditor({this.card, super.key});

  final CreditCard? card;

  @override
  ConsumerState<CreditCardEditor> createState() => _CreditCardEditorState();
}

class _CreditCardEditorState extends ConsumerState<CreditCardEditor> {
  late final _name = TextEditingController(text: widget.card?.name ?? '');
  late final _issuer = TextEditingController(text: widget.card?.issuer ?? '');
  late final _digits = TextEditingController(
    text: widget.card?.lastFourDigits ?? '',
  );
  late final _limit = TextEditingController(
    text: widget.card?.creditLimit.asApiString ?? '',
  );
  late final _closingDay = TextEditingController(
    text: widget.card?.closingDay.toString() ?? '',
  );
  late final _dueDay = TextEditingController(
    text: widget.card?.dueDay.toString() ?? '',
  );

  late String? _currency = widget.card?.currencyCode;
  String? _error;
  var _busy = false;

  bool get _isNew => widget.card == null;

  @override
  void dispose() {
    _name.dispose();
    _issuer.dispose();
    _digits.dispose();
    _limit.dispose();
    _closingDay.dispose();
    _dueDay.dispose();
    super.dispose();
  }

  /// Step 3 and `AF-01`. Exactly the rules the specification states, and no
  /// more — whether a closing and due day pair makes sense is `AF-02`, which
  /// is the API's to answer.
  String? _validate() {
    if (_name.text.trim().isEmpty) return 'Give the card a name.';
    if (_isNew && (_currency == null || _currency!.isEmpty)) {
      return 'Choose the currency this card is billed in.';
    }
    if (!CreditCardRules.isPositiveAmount(_limit.text)) {
      return 'The credit limit must be greater than zero.';
    }
    if (!CreditCardRules.isDayInRange(int.tryParse(_closingDay.text.trim()))) {
      return 'The closing day must be ${CreditCardRules.dayRange}.';
    }
    if (!CreditCardRules.isDayInRange(int.tryParse(_dueDay.text.trim()))) {
      return 'The due day must be ${CreditCardRules.dayRange}.';
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

    final actions = ref.read(creditCardActionsProvider);
    final issuer = _issuer.text.trim();
    final digits = _digits.text.trim();

    final result = _isNew
        ? await actions.create(
            name: _name.text.trim(),
            currencyCode: _currency!,
            // The string as typed, unrounded.
            creditLimit: _limit.text.trim(),
            closingDay: int.parse(_closingDay.text.trim()),
            dueDay: int.parse(_dueDay.text.trim()),
            issuer: issuer.isEmpty ? null : issuer,
            lastFourDigits: digits.isEmpty ? null : digits,
          )
        : await actions.update(
            id: widget.card!.id,
            name: _name.text.trim(),
            creditLimit: _limit.text.trim(),
            closingDay: int.parse(_closingDay.text.trim()),
            dueDay: int.parse(_dueDay.text.trim()),
            issuer: issuer.isEmpty ? null : issuer,
          );

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-02 and AF-03, in the API's own words.
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  Future<void> _delete() async {
    final card = widget.card;
    if (card == null) return;

    setState(() => _busy = true);
    final result = await ref.read(creditCardActionsProvider).delete(card.id);

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-05.
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
      title: Text(_isNew ? 'New card' : 'Edit card'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('cardEditor.name'),
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
              key: const Key('cardEditor.issuer'),
              controller: _issuer,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Issuer (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_isNew) ...[
              const SizedBox(height: 12),
              TextField(
                key: const Key('cardEditor.digits'),
                controller: _digits,
                enabled: !_busy,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Last four digits (optional)',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              currencies.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) =>
                    Text('The supported currencies could not be read: $error'),
                data: (list) => DropdownButtonFormField<String>(
                  key: const Key('cardEditor.currency'),
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
            const SizedBox(height: 12),
            TextField(
              key: const Key('cardEditor.limit'),
              controller: _limit,
              enabled: !_busy,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Credit limit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('cardEditor.closingDay'),
                    controller: _closingDay,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Closing day',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const Key('cardEditor.dueDay'),
                    controller: _dueDay,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Due day',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            if (_error case final message?) ...[
              const SizedBox(height: 16),
              Text(
                message,
                key: const Key('cardEditor.error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isNew)
          TextButton(
            key: const Key('cardEditor.delete'),
            onPressed: _busy ? null : () => unawaited(_delete()),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        TextButton(
          key: const Key('cardEditor.cancel'),
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('cardEditor.save'),
          onPressed: _busy ? null : () => unawaited(_save()),
          child: Text(_isNew ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}

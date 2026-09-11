/// Editing and deleting a transaction (UC-20, steps 2 to 5).
///
/// The same rules that guard recording guard correcting — a transaction
/// corrected into an invalid state is no better than an invalid one recorded
/// in the first place, so `TransactionRules` is reused here rather than
/// restated (`AF-01`).
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
import '../../holdings/data/account_repository.dart';
import '../../holdings/data/credit_card_repository.dart';
import '../../holdings/state/account_providers.dart';
import '../../holdings/state/credit_card_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/transaction_repository.dart';
import '../state/transaction_form.dart';
import '../state/transaction_providers.dart';

Future<void> showTransactionEditor(
  BuildContext context,
  WidgetRef ref,
  Transaction transaction,
) => showDialog<void>(
  context: context,
  builder: (context) => TransactionEditor(transaction: transaction),
);

class TransactionEditor extends ConsumerStatefulWidget {
  const TransactionEditor({required this.transaction, super.key});

  final Transaction transaction;

  @override
  ConsumerState<TransactionEditor> createState() => _TransactionEditorState();
}

class _TransactionEditorState extends ConsumerState<TransactionEditor> {
  late final _amount = TextEditingController(
    text: widget.transaction.amount.asApiString,
  );
  late final _description = TextEditingController(
    text: widget.transaction.description ?? '',
  );
  late final _counterparty = TextEditingController(
    text: widget.transaction.counterpartyName ?? '',
  );
  late final _tags = TextEditingController(
    text: widget.transaction.tags.join(', '),
  );

  late DateTime _date = widget.transaction.occurredOn;
  late Direction _direction = widget.transaction.direction;
  late String? _categoryId = widget.transaction.categoryId;
  late String? _holdingId =
      widget.transaction.financialAccountId ?? widget.transaction.creditCardId;
  late HoldingKind _holdingKind = widget.transaction.financialAccountId != null
      ? HoldingKind.account
      : HoldingKind.creditCard;
  late String _currencyCode = widget.transaction.amount.currencyCode;

  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    _counterparty.dispose();
    _tags.dispose();
    super.dispose();
  }

  MoneyParser get _parser =>
      MoneyParser(SupportedLocales.tagOf(ref.read(preferencesProvider).locale));

  Future<void> _save() async {
    // AF-01: the recording rules, reused rather than restated.
    final problem = TransactionRules.validate(
      amountText: _amount.text,
      occurredOn: _date,
      categoryId: _categoryId,
      holdingId: _holdingId,
      parser: _parser,
      now: DateTime.now(),
    );

    if (problem != null) {
      setState(() => _error = problem.message);
      return;
    }

    setState(() {
      _error = null;
      _busy = true;
    });

    final description = _description.text.trim();
    final counterparty = _counterparty.text.trim();
    final tags = _tags.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final result = await ref
        .read(transactionActionsProvider)
        .update(
          id: widget.transaction.id,
          occurredOn: _date,
          amount: _parser.parse(_amount.text)!,
          direction: _direction,
          categoryId: _categoryId!,
          currencyCode: _currencyCode,
          holdingKind: _holdingKind,
          holdingId: _holdingId!,
          description: description.isEmpty ? null : description,
          counterparty: counterparty.isEmpty ? null : counterparty,
          tags: tags,
        );

    if (!mounted) return;

    switch (result) {
      // Step 3: confirmed only once the API has accepted it.
      case Success<Transaction>():
        Navigator.of(context).pop();
      // AF-03: a settled statement, a reconciled record, or another rule —
      // in the API's own words, with the entry kept.
      case Failure<Transaction>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  /// Step 4: deletion, confirmed first.
  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this transaction?'),
        content: const Text(
          'It will disappear from every view except deleted records, where it '
          'can be restored.',
        ),
        actions: [
          TextButton(
            key: const Key('transactionEditor.delete.cancel'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            key: const Key('transactionEditor.delete.confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!(confirmed ?? false) || !mounted) return;

    setState(() => _busy = true);

    final result = await ref
        .read(transactionActionsProvider)
        .delete(widget.transaction.id);

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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: maximumDaysAhead)),
    );

    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    // Whatever has loaded. A picker that is briefly short of one option is
    // better than a dialog that refuses to open until three reads finish.
    final accounts = switch (ref.watch(selectableAccountsProvider)) {
      AsyncData(:final value) => value,
      _ => const <FinancialAccount>[],
    };
    final cards = switch (ref.watch(creditCardsProvider)) {
      AsyncData(:final value) => value,
      _ => const <CreditCard>[],
    };
    final categories = switch (ref.watch(categoryTreeProvider)) {
      AsyncData(:final value) =>
        value.all.where((category) => !category.isDeleted).toList(),
      _ => const <Category>[],
    };

    final holdings = <(HoldingKind, String, String, String)>[
      for (final account in accounts)
        (HoldingKind.account, account.id, account.name, account.currencyCode),
      for (final card in cards)
        (HoldingKind.creditCard, card.id, card.name, card.currencyCode),
    ];

    return AlertDialog(
      title: const Text('Edit transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<Direction>(
              key: const Key('transactionEditor.direction'),
              segments: [
                for (final direction in Direction.values)
                  ButtonSegment(value: direction, label: Text(direction.label)),
              ],
              selected: {_direction},
              onSelectionChanged: (selection) =>
                  setState(() => _direction = selection.first),
            ),
            const SizedBox(height: 12),

            TextField(
              key: const Key('transactionEditor.amount'),
              controller: _amount,
              enabled: !_busy,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Amount',
                suffixText: _currencyCode,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              key: const Key('transactionEditor.date'),
              icon: const Icon(Icons.event_outlined),
              label: Text(DateFormat.yMMMd(locale).format(_date)),
              onPressed: _busy ? null : () => unawaited(_pickDate()),
            ),
            const SizedBox(height: 12),

            if (holdings.isNotEmpty)
              DropdownButtonFormField<String>(
                key: const Key('transactionEditor.holding'),
                initialValue: holdings.any((h) => h.$2 == _holdingId)
                    ? _holdingId
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Account or card',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final (kind, id, name, currency) in holdings)
                    DropdownMenuItem(
                      value: id,
                      child: Text(
                        '$name · $currency'
                        '${kind == HoldingKind.creditCard ? ' (card)' : ''}',
                      ),
                    ),
                ],
                onChanged: _busy
                    ? null
                    : (value) {
                        final chosen = holdings.firstWhere(
                          (h) => h.$2 == value,
                        );
                        setState(() {
                          _holdingId = value;
                          _holdingKind = chosen.$1;
                          _currencyCode = chosen.$4;
                        });
                      },
              ),
            const SizedBox(height: 12),

            if (categories.isNotEmpty)
              DropdownButtonFormField<String>(
                key: const Key('transactionEditor.category'),
                initialValue: categories.any((c) => c.id == _categoryId)
                    ? _categoryId
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final category in categories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                ],
                onChanged: _busy
                    ? null
                    : (value) => setState(() => _categoryId = value),
              ),
            const SizedBox(height: 12),

            TextField(
              key: const Key('transactionEditor.description'),
              controller: _description,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              key: const Key('transactionEditor.counterparty'),
              controller: _counterparty,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Counterparty (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              key: const Key('transactionEditor.tags'),
              controller: _tags,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Tags (optional)',
                helperText: 'Separated by commas',
                border: OutlineInputBorder(),
              ),
            ),

            if (_error case final message?) ...[
              const SizedBox(height: 16),
              Text(
                message,
                key: const Key('transactionEditor.error'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('transactionEditor.delete'),
          onPressed: _busy ? null : () => unawaited(_delete()),
          child: Text(
            'Delete',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
        TextButton(
          key: const Key('transactionEditor.cancel'),
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('transactionEditor.save'),
          onPressed: _busy ? null : () => unawaited(_save()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

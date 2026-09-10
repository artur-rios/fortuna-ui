/// Creating and editing a financial account (UC-14).
///
/// `AF-03` is the reason the currency field behaves differently on the two
/// paths. On creation it is chosen; on edit it is shown, disabled, with the
/// reason — because a balance's currency is what every figure in that account
/// was recorded in, and changing it would not convert anything, it would
/// relabel history. Saying that is more use than a control that refuses.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../preferences/state/currency_providers.dart';
import '../data/account_repository.dart';
import '../state/account_providers.dart';

/// Opens the editor. [account] null creates, non-null edits.
Future<void> showAccountEditor(
  BuildContext context,
  WidgetRef ref, {
  FinancialAccount? account,
}) => showDialog<void>(
  context: context,
  builder: (context) => AccountEditor(account: account),
);

class AccountEditor extends ConsumerStatefulWidget {
  const AccountEditor({this.account, super.key});

  final FinancialAccount? account;

  @override
  ConsumerState<AccountEditor> createState() => _AccountEditorState();
}

class _AccountEditorState extends ConsumerState<AccountEditor> {
  late final _name = TextEditingController(text: widget.account?.name ?? '');
  late final _institution = TextEditingController(
    text: widget.account?.institution ?? '',
  );
  late final _openingBalance = TextEditingController(
    text: widget.account?.openingBalance.asApiString ?? '',
  );

  late var _type = widget.account?.type ?? AccountType.checking;
  late String? _currency = widget.account?.currencyCode;

  String? _error;
  var _busy = false;

  bool get _isNew => widget.account == null;

  @override
  void dispose() {
    _name.dispose();
    _institution.dispose();
    _openingBalance.dispose();
    super.dispose();
  }

  /// Step 3, and `AF-01`. Deliberately only checks presence: what a valid
  /// amount or a valid name is belongs to the API (`FR-DA-15`).
  String? _validate() {
    if (_name.text.trim().isEmpty) return 'Give the account a name.';
    if (_isNew && (_currency == null || _currency!.isEmpty)) {
      return 'Choose the currency this account is held in.';
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

    final actions = ref.read(accountActionsProvider);
    final institution = _institution.text.trim();

    final result = _isNew
        ? await actions.create(
            name: _name.text.trim(),
            type: _type,
            currencyCode: _currency!,
            // The opening balance travels as the string the user typed. It is
            // never parsed to a number here — the API decides what a valid
            // amount is, and rounding one on the way out is how BR-05 breaks.
            openingBalance: _openingBalance.text.trim().isEmpty
                ? '0'
                : _openingBalance.text.trim(),
            institution: institution.isEmpty ? null : institution,
          )
        : await actions.update(
            id: widget.account!.id,
            name: _name.text.trim(),
            type: _type,
            institution: institution.isEmpty ? null : institution,
          );

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-02 and everything else the API refuses, in its own words.
      case Failure<void>(:final message):
        setState(() {
          _error = message;
          _busy = false;
        });
    }
  }

  Future<void> _delete() async {
    final account = widget.account;
    if (account == null) return;

    setState(() => _busy = true);
    final result = await ref.read(accountActionsProvider).delete(account.id);

    if (!mounted) return;

    switch (result) {
      case Success<void>():
        Navigator.of(context).pop();
      // AF-05: live records still reference it, and the API says which rule.
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
      title: Text(_isNew ? 'New account' : 'Edit account'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('accountEditor.name'),
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
              key: const Key('accountEditor.institution'),
              controller: _institution,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Institution (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AccountType>(
              key: const Key('accountEditor.type'),
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final type in AccountType.values)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _type = value ?? _type),
            ),
            const SizedBox(height: 12),

            if (_isNew) ...[
              currencies.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text(
                  'The supported currencies could not be read: $error',
                  key: const Key('accountEditor.currencyUnavailable'),
                ),
                // Step 3: only currencies the API supports, from the API.
                data: (list) => DropdownButtonFormField<String>(
                  key: const Key('accountEditor.currency'),
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
              TextField(
                key: const Key('accountEditor.openingBalance'),
                controller: _openingBalance,
                enabled: !_busy,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Opening balance',
                  border: OutlineInputBorder(),
                ),
              ),
            ] else ...[
              // AF-03. Shown and disabled, with the reason — an unexplained
              // dead control is worse than no control.
              TextField(
                key: const Key('accountEditor.currencyFixed'),
                enabled: false,
                controller: TextEditingController(
                  text: widget.account!.currencyCode,
                ),
                decoration: const InputDecoration(
                  labelText: 'Currency',
                  border: OutlineInputBorder(),
                  helperText:
                      'Fixed once the account exists. Every figure in it was '
                      'recorded in this currency; changing it would relabel '
                      'that history rather than convert it.',
                  helperMaxLines: 4,
                ),
              ),
            ],

            if (_error case final message?) ...[
              const SizedBox(height: 16),
              Text(
                message,
                key: const Key('accountEditor.error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isNew)
          TextButton(
            key: const Key('accountEditor.delete'),
            onPressed: _busy ? null : () => unawaited(_delete()),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        TextButton(
          key: const Key('accountEditor.cancel'),
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('accountEditor.save'),
          onPressed: _busy ? null : () => unawaited(_save()),
          child: Text(_isNew ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}

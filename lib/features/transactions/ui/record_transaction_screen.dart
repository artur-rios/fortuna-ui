/// Recording a transaction (UC-19).
///
/// The most frequent screen in the application, so two things matter more here
/// than anywhere else:
///
/// - **Nothing the user typed is ever lost.** Every refusal — a form rule, a
///   rule only the API knows, a transport failure — leaves the entry exactly
///   as it was and offers another attempt (`AF-05`, `AF-06`). A form that
///   clears itself on failure makes the user pay for the instance's problem.
/// - **Success is claimed only once the API has said so.** The confirmation
///   shows the transaction the API returned, not the form's own copy of it
///   (step 6).
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
import '../../categories/data/category_repository.dart';
import '../../categories/state/category_providers.dart';
import '../../holdings/data/account_repository.dart';
import '../../holdings/data/credit_card_repository.dart';
import '../../holdings/state/account_providers.dart';
import '../../holdings/state/credit_card_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/transaction_repository.dart';
import '../state/transaction_form.dart';

class RecordTransactionScreen extends ConsumerStatefulWidget {
  const RecordTransactionScreen({super.key});

  @override
  ConsumerState<RecordTransactionScreen> createState() =>
      _RecordTransactionScreenState();
}

class _RecordTransactionScreenState
    extends ConsumerState<RecordTransactionScreen> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _counterparty = TextEditingController();
  final _tags = TextEditingController();

  DateTime _date = DateTime.now();
  Direction _direction = Direction.expense;
  String? _categoryId;
  String? _holdingId;
  HoldingKind _holdingKind = HoldingKind.account;
  String _currencyCode = '';

  String? _error;
  var _busy = false;
  Transaction? _recorded;

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

  Future<void> _submit() async {
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

    final tags = _tags.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final description = _description.text.trim();
    final counterparty = _counterparty.text.trim();

    final result = await ref
        .read(transactionFormActionsProvider)
        .submit(
          occurredOn: _date,
          // Already proven readable by the rules above.
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
      // Step 6: what the API stored, not what was submitted.
      case Success<Transaction>(:final value):
        setState(() {
          _recorded = value;
          _busy = false;
        });

      // AF-04, AF-05 and AF-06. The controllers are untouched, so everything
      // the user entered is still there to try again with.
      case Failure<Transaction>(:final message):
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
      // AF-02, prevented here as well as checked in the rule.
      lastDate: DateTime.now().add(const Duration(days: maximumDaysAhead)),
    );

    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(selectableAccountsProvider);
    final cards = ref.watch(creditCardsProvider);
    final categories = ref.watch(categoryTreeProvider);

    final recorded = _recorded;
    if (recorded != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recorded')),
        body: _Confirmation(
          transaction: recorded,
          onAnother: () => setState(() {
            _recorded = null;
            _amount.clear();
            _description.clear();
            _counterparty.clear();
            _tags.clear();
          }),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Record a transaction')),
      body: switch ((accounts, cards, categories)) {
        // AF-07: without somewhere to put it and something to call it, the
        // form cannot be completed. Directing the user to create one is more
        // use than presenting two empty pickers.
        (
          AsyncData(value: final accountList),
          AsyncData(value: final cardList),
          AsyncData(value: final tree),
        )
            when (accountList.isEmpty && cardList.isEmpty) || tree.isEmpty =>
          _NothingToRecordAgainst(
            hasHolding: accountList.isNotEmpty || cardList.isNotEmpty,
            hasCategory: !tree.isEmpty,
          ),

        (
          AsyncData(value: final accountList),
          AsyncData(value: final cardList),
          AsyncData(value: final tree),
        ) =>
          _buildForm(
            accounts: accountList,
            cards: cardList,
            categories: tree.all.where((c) => !c.isDeleted).toList(),
          ),

        (AsyncError(:final error), _, _) ||
        (_, AsyncError(:final error), _) ||
        (_, _, AsyncError(:final error)) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text('$error', textAlign: TextAlign.center),
          ),
        ),

        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  /// The form itself. A method on the state rather than its own widget,
  /// because every control writes back into this state — a separate widget
  /// would have to reach into `setState` from outside, which is exactly the
  /// thing `@protected` is there to stop.
  Widget _buildForm({
    required List<FinancialAccount> accounts,
    required List<CreditCard> cards,
    required List<Category> categories,
  }) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    // Every holding the user has, as one list — the API takes an account id or
    // a card id, so which kind was chosen travels with the id.
    final holdings = <(HoldingKind, String, String, String)>[
      for (final account in accounts)
        (HoldingKind.account, account.id, account.name, account.currencyCode),
      for (final card in cards)
        (HoldingKind.creditCard, card.id, card.name, card.currencyCode),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<Direction>(
          key: const Key('recordTransaction.direction'),
          segments: [
            for (final direction in Direction.values)
              ButtonSegment(value: direction, label: Text(direction.label)),
          ],
          selected: {_direction},
          onSelectionChanged: (selection) =>
              setState(() => _direction = selection.first),
        ),
        const SizedBox(height: 16),

        TextField(
          key: const Key('recordTransaction.amount'),
          controller: _amount,
          autofocus: true,
          enabled: !_busy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount',
            // FR-PS-04: the currency the amount will be recorded in, shown
            // beside it rather than left to be assumed.
            suffixText: _currencyCode,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        OutlinedButton.icon(
          key: const Key('recordTransaction.date'),
          icon: const Icon(Icons.event_outlined),
          label: Text(DateFormat.yMMMd(locale).format(_date)),
          onPressed: _busy ? null : _pickDate,
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          key: const Key('recordTransaction.holding'),
          initialValue: _holdingId,
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
                  final chosen = holdings.firstWhere((h) => h.$2 == value);
                  setState(() {
                    _holdingId = value;
                    _holdingKind = chosen.$1;
                    // The amount is recorded in the holding's currency. Taken
                    // from the holding rather than chosen separately, so an
                    // amount can never be recorded against a currency the
                    // account does not hold.
                    _currencyCode = chosen.$4;
                  });
                },
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          key: const Key('recordTransaction.category'),
          initialValue: _categoryId,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final category in categories)
              DropdownMenuItem(value: category.id, child: Text(category.name)),
          ],
          onChanged: _busy
              ? null
              : (value) => setState(() => _categoryId = value),
        ),
        const SizedBox(height: 12),

        TextField(
          key: const Key('recordTransaction.description'),
          controller: _description,
          enabled: !_busy,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          key: const Key('recordTransaction.counterparty'),
          controller: _counterparty,
          enabled: !_busy,
          decoration: const InputDecoration(
            labelText: 'Counterparty (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          key: const Key('recordTransaction.tags'),
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
            key: const Key('recordTransaction.error'),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],

        const SizedBox(height: 20),
        FilledButton(
          key: const Key('recordTransaction.submit'),
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
    );
  }
}

/// AF-07.
class _NothingToRecordAgainst extends StatelessWidget {
  const _NothingToRecordAgainst({
    required this.hasHolding,
    required this.hasCategory,
  });

  final bool hasHolding;
  final bool hasCategory;

  @override
  Widget build(BuildContext context) {
    final missing = [
      if (!hasHolding) 'an account or a credit card',
      if (!hasCategory) 'a category',
    ].join(' and ');

    return Center(
      key: const Key('recordTransaction.nothingToRecordAgainst'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.playlist_add_outlined, size: 40),
            const SizedBox(height: 16),
            Text(
              'Set up $missing first',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'A transaction needs somewhere to sit and something to be '
              'called. Create $missing, then come back.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!hasHolding)
              FilledButton(
                key: const Key('recordTransaction.createAccount'),
                onPressed: () => context.go(Routes.accounts),
                child: const Text('Go to accounts'),
              ),
            if (!hasCategory) ...[
              const SizedBox(height: 8),
              FilledButton(
                key: const Key('recordTransaction.createCategory'),
                onPressed: () => context.go(Routes.categories),
                child: const Text('Go to categories'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Step 6: the transaction the API stored.
class _Confirmation extends StatelessWidget {
  const _Confirmation({required this.transaction, required this.onAnother});

  final Transaction transaction;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          key: const Key('recordTransaction.confirmation'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Recorded', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            MoneyText(
              transaction.amount,
              key: const Key('recordTransaction.recordedAmount'),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              [
                transaction.direction.label,
                if (transaction.categoryName case final name?
                    when name.isNotEmpty)
                  name,
              ].join(' · '),
            ),
            const SizedBox(height: 32),
            FilledButton(
              key: const Key('recordTransaction.another'),
              onPressed: onAnother,
              child: const Text('Record another'),
            ),
            const SizedBox(height: 8),
            TextButton(
              key: const Key('recordTransaction.done'),
              onPressed: () => context.go(Routes.home),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recording an installment purchase (UC-22).
///
/// Step 5 is the whole point of the screen: the installments are displayed
/// **exactly as the API generated them**, remainder and all. Where they are
/// uneven the screen says so and explains why, rather than smoothing them —
/// a set of even amounts that does not sum to the purchase would leave the
/// user reconciling against a card statement that disagrees with the
/// application for reasons nothing here explains (`AF-04`).
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
import '../../holdings/data/credit_card_repository.dart';
import '../../holdings/state/credit_card_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/installment_repository.dart';
import '../state/installment_form.dart';

class RecordInstallmentScreen extends ConsumerStatefulWidget {
  const RecordInstallmentScreen({super.key});

  @override
  ConsumerState<RecordInstallmentScreen> createState() =>
      _RecordInstallmentScreenState();
}

class _RecordInstallmentScreenState
    extends ConsumerState<RecordInstallmentScreen> {
  final _total = TextEditingController();
  final _count = TextEditingController(text: '$minimumInstallments');
  final _counterparty = TextEditingController();

  DateTime _date = DateTime.now();
  String? _cardId;
  String? _categoryId;
  String _currencyCode = '';

  String? _error;
  var _busy = false;
  InstallmentPlan? _recorded;

  @override
  void dispose() {
    _total.dispose();
    _count.dispose();
    _counterparty.dispose();
    super.dispose();
  }

  MoneyParser get _parser =>
      MoneyParser(SupportedLocales.tagOf(ref.read(preferencesProvider).locale));

  Future<void> _submit() async {
    final count = int.tryParse(_count.text.trim());

    final problem = InstallmentRules.validate(
      totalText: _total.text,
      installmentCount: count,
      creditCardId: _cardId,
      categoryId: _categoryId,
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

    final counterparty = _counterparty.text.trim();

    final result = await ref
        .read(installmentActionsProvider)
        .submit(
          creditCardId: _cardId!,
          categoryId: _categoryId!,
          totalAmount: _parser.parse(_total.text)!,
          installmentCount: count!,
          purchasedOn: _date,
          currencyCode: _currencyCode,
          counterparty: counterparty.isEmpty ? null : counterparty,
        );

    if (!mounted) return;

    switch (result) {
      case Success<InstallmentPlan>(:final value):
        setState(() {
          _recorded = value;
          _busy = false;
        });
      // AF-03 and AF-05, in the API's own words, with the entry kept.
      case Failure<InstallmentPlan>(:final message):
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
    final cards = ref.watch(creditCardsProvider);
    final categories = ref.watch(categoryTreeProvider);

    final recorded = _recorded;
    if (recorded != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Installments')),
        body: _GeneratedPlan(plan: recorded),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Record an installment purchase')),
      body: switch ((cards, categories)) {
        (AsyncData(value: final cardList), AsyncData(value: final tree))
            when cardList.isEmpty || tree.isEmpty =>
          _NothingToRecordAgainst(
            hasCard: cardList.isNotEmpty,
            hasCategory: !tree.isEmpty,
          ),

        (AsyncData(value: final cardList), AsyncData(value: final tree)) =>
          _buildForm(
            cardList,
            tree.all.where((category) => !category.isDeleted).toList(),
          ),

        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text('$error', textAlign: TextAlign.center),
          ),
        ),

        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildForm(List<CreditCard> cards, List<Category> categories) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          key: const Key('recordInstallment.total'),
          controller: _total,
          autofocus: true,
          enabled: !_busy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Total purchase',
            suffixText: _currencyCode,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          key: const Key('recordInstallment.count'),
          controller: _count,
          enabled: !_busy,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of installments',
            helperText: 'At least $minimumInstallments',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          key: const Key('recordInstallment.card'),
          initialValue: _cardId,
          decoration: const InputDecoration(
            labelText: 'Card',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final card in cards)
              DropdownMenuItem(
                value: card.id,
                child: Text('${card.name} · ${card.currencyCode}'),
              ),
          ],
          onChanged: _busy
              ? null
              : (value) {
                  final chosen = cards.firstWhere((card) => card.id == value);
                  setState(() {
                    _cardId = value;
                    _currencyCode = chosen.currencyCode;
                  });
                },
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          key: const Key('recordInstallment.category'),
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

        OutlinedButton.icon(
          key: const Key('recordInstallment.date'),
          icon: const Icon(Icons.event_outlined),
          label: Text(DateFormat.yMMMd(locale).format(_date)),
          onPressed: _busy ? null : _pickDate,
        ),
        const SizedBox(height: 12),

        TextField(
          key: const Key('recordInstallment.counterparty'),
          controller: _counterparty,
          enabled: !_busy,
          decoration: const InputDecoration(
            labelText: 'Counterparty (optional)',
            border: OutlineInputBorder(),
          ),
        ),

        if (_error case final message?) ...[
          const SizedBox(height: 16),
          Text(
            message,
            key: const Key('recordInstallment.error'),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],

        const SizedBox(height: 20),
        FilledButton(
          key: const Key('recordInstallment.submit'),
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

class _NothingToRecordAgainst extends StatelessWidget {
  const _NothingToRecordAgainst({
    required this.hasCard,
    required this.hasCategory,
  });

  final bool hasCard;
  final bool hasCategory;

  @override
  Widget build(BuildContext context) {
    final missing = [
      if (!hasCard) 'a credit card',
      if (!hasCategory) 'a category',
    ].join(' and ');

    return Center(
      key: const Key('recordInstallment.nothingToRecordAgainst'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.credit_card_outlined, size: 40),
            const SizedBox(height: 16),
            Text(
              'Set up $missing first',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'An installment plan is charged to a card and needs a category. '
              'Create $missing, then come back.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!hasCard)
              FilledButton(
                key: const Key('recordInstallment.createCard'),
                onPressed: () => context.go(Routes.creditCards),
                child: const Text('Go to cards'),
              ),
            if (!hasCategory) ...[
              const SizedBox(height: 8),
              FilledButton(
                key: const Key('recordInstallment.createCategory'),
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

/// Step 5 and `AF-04`: the API's installments, exactly as generated.
class _GeneratedPlan extends ConsumerWidget {
  const _GeneratedPlan({required this.plan});

  final InstallmentPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    return ListView(
      key: const Key('recordInstallment.plan'),
      padding: const EdgeInsets.all(16),
      children: [
        Text('Total purchase', style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        MoneyText(
          plan.totalAmount,
          key: const Key('recordInstallment.total.recorded'),
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Split into ${plan.installmentCount} charges on '
          '${dates.format(plan.purchasedOn)}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),

        // AF-04. Explained, never corrected. A user expecting even amounts
        // needs to know where the remainder went; removing the difference
        // would only move the surprise to their card statement.
        if (plan.isUneven)
          Card(
            key: const Key('recordInstallment.uneven'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'These charges are not all equal. The total does not '
                      'divide evenly, so one installment carries the '
                      'remainder. These are the amounts the instance '
                      'generated, shown as it generated them.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (plan.isUneven) const SizedBox(height: 16),

        Text('Installments', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final installment in plan.installments)
          ListTile(
            key: Key('recordInstallment.item.${installment.number}'),
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 16,
              child: Text(
                '${installment.number}',
                style: theme.textTheme.labelMedium,
              ),
            ),
            title: Text(dates.format(installment.occurredOn)),
            trailing: MoneyText(
              installment.amount,
              key: Key('recordInstallment.amount.${installment.number}'),
            ),
          ),

        const SizedBox(height: 24),
        FilledButton(
          key: const Key('recordInstallment.done'),
          onPressed: () => context.go(Routes.creditCards),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

/// Financial accounts (UC-14).
///
/// Every figure on this screen came from the API. `FR-HO-02` forbids computing
/// a balance here, and `AF-07` is what that looks like when it fails: the
/// account is still listed, with the reason where the number would be. A zero
/// in that spot would be a claim nobody made.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/money_text.dart';
import '../data/account_repository.dart';
import '../state/account_providers.dart';
import 'account_editor.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('accounts.add'),
        onPressed: () => unawaited(showAccountEditor(context, ref)),
        icon: const Icon(Icons.add),
        label: const Text('New account'),
      ),
      body: accounts.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => _Failure(
          message: '$error',
          onRetry: () => ref.invalidate(accountsProvider),
        ),

        data: (list) {
          // AF-06: an empty state that offers creation. Distinct from a
          // failure, and deliberately not a spinner that never resolves.
          if (list.isEmpty) {
            return const _Empty(key: Key('accounts.empty'));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => _AccountTile(account: list[index]),
          );
        },
      ),
    );
  }
}

class _AccountTile extends ConsumerWidget {
  const _AccountTile({required this.account});

  final FinancialAccount account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(accountBalanceProvider(account.id));

    return ListTile(
      key: Key('accounts.item.${account.id}'),
      title: Text(account.name),
      subtitle: Text(
        [
          account.type.label,
          if (account.institution case final institution?
              when institution.isNotEmpty)
            institution,
          account.currencyCode,
        ].join(' · '),
      ),
      trailing: balance.when(
        loading: () => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        // AF-07: the reason, where the number would be. Nothing is computed to
        // fill the gap.
        error: (error, _) => Tooltip(
          message: '$error',
          child: Text(
            'No balance',
            key: Key('accounts.noBalance.${account.id}'),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        data: (value) => MoneyText(
          value.balance,
          key: Key('accounts.balance.${account.id}'),
        ),
      ),
      onTap: () => unawaited(showAccountEditor(context, ref, account: account)),
    );
  }
}

class _Empty extends ConsumerWidget {
  const _Empty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_balance_outlined, size: 40),
          const SizedBox(height: 16),
          Text(
            'No accounts yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add the accounts and cash you want to track. Everything else in '
            'Fortuna hangs off them.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('accounts.emptyAdd'),
            onPressed: () => unawaited(showAccountEditor(context, ref)),
            child: const Text('Add an account'),
          ),
        ],
      ),
    ),
  );
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('accounts.retry'),
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ),
    ),
  );
}

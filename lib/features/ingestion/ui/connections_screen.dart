/// Bank connections (UC-31).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../preferences/state/preferences_controller.dart';
import '../../session/ui/sign_out_action.dart';
import '../data/connection_repository.dart';
import '../state/connection_providers.dart';

class ConnectionsScreen extends ConsumerWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connections = ref.watch(connectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(connectionsProvider),
          ),
          const SignOutAction(),
        ],
      ),
      body: connections.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Failed(
          message: error is ConnectionsUnavailable
              ? error.message
              : 'The connections could not be loaded.',
          onRetry: () => ref.invalidate(connectionsProvider),
        ),
        data: (data) => data.isEmpty
            ? const _Empty()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _ConnectionCard(connection: data[index]),
              ),
      ),
    );
  }
}

class _ConnectionCard extends ConsumerWidget {
  const _ConnectionCard({required this.connection});

  final Connection connection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final running = ref.watch(runningSyncProvider(connection.id));
    final needsReauth =
        connection.state == BankConnectionState.requiresReauthentication;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StateChip(state: connection.state),
                const Spacer(),
                Text(
                  'Connected ${DateFormat.yMMMd(locale).format(connection.connectedAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            if (connection.externalReference case final String reference) ...[
              const SizedBox(height: 8),
              Text(reference, style: theme.textTheme.bodySmall),
            ],

            // Step 3: reauthentication is surfaced prominently, because a
            // connection stuck here silently stops bringing data in.
            if (needsReauth) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_reset,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This connection has stopped bringing data in until '
                        'you authenticate with the institution again.',
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (running != null) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Synchronizing now — ${running.processed} rows read so far.',
                style: theme.textTheme.bodySmall,
              ),
            ],

            const SizedBox(height: 12),
            // AF-04: a revoked connection offers nothing, only its history.
            if (connection.isRevoked)
              Text(
                'Revoked. Everything it already imported is still here.',
                style: theme.textTheme.bodySmall,
              )
            else
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                children: [
                  if (needsReauth)
                    FilledButton.tonal(
                      onPressed: () => _reauthenticate(context, ref),
                      child: const Text('Reauthenticate'),
                    )
                  else
                    FilledButton.tonal(
                      onPressed: running != null
                          ? null
                          : () => _synchronize(context, ref),
                      child: Text(
                        running != null ? 'Synchronizing…' : 'Synchronize now',
                      ),
                    ),
                  TextButton(
                    onPressed: () => _revoke(context, ref),
                    child: const Text('Revoke'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _synchronize(BuildContext context, WidgetRef ref) async {
    final outcome = await ref
        .read(connectionActionsProvider)
        .synchronize(connection);
    if (!context.mounted) return;

    final message = switch (outcome) {
      SyncStarted() =>
        'Synchronization started. It runs on the instance — you can follow it '
            'under Imports.',
      SyncNotAttempted(:final reason) => reason,
      SyncFailed(:final reason) => reason,
    };

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _reauthenticate(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reauthenticate this connection?'),
        content: const Text(
          'You will be asked to sign in with the institution again. Fortuna '
          'never sees those credentials — they stay with the provider.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    // AF-02: abandoned, so nothing changes.
    if (confirmed != true || !context.mounted) return;

    final failure = await ref
        .read(connectionActionsProvider)
        .reauthenticate(connection.id);
    if (failure == null || !context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure.message)));
  }

  Future<void> _revoke(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke this connection?'),
        content: const Text(
          'It will stop synchronizing, and Fortuna will no longer reach the '
          'institution.\n\n'
          'Everything it has already imported stays exactly as it is. Cutting '
          'off a bank link is not a decision to erase your history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final failure = await ref
        .read(connectionActionsProvider)
        .revoke(connection.id);
    if (failure == null || !context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure.message)));
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.state});

  final BankConnectionState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (icon, label, colour) = switch (state) {
      BankConnectionState.active => (Icons.link, 'Active', scheme.primary),
      BankConnectionState.requiresReauthentication => (
        Icons.lock_reset,
        'Needs reauthentication',
        scheme.error,
      ),
      BankConnectionState.revoked => (
        Icons.link_off,
        'Revoked',
        scheme.outline,
      ),
      BankConnectionState.unknown => (
        Icons.help_outline,
        'Unknown',
        scheme.outline,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colour),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: colour)),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance_outlined, size: 40),
            const SizedBox(height: 16),
            Text(
              'No connections',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'A connection lets an institution send its transactions to your '
              'instance. Fortuna never holds the credentials.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 40),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}

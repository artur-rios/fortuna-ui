/// The audit trail (UC-41).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../preferences/state/preferences_controller.dart';
import '../../session/ui/sign_out_action.dart';
import '../data/audit_repository.dart';
import '../state/audit_providers.dart';

class AuditTrailScreen extends ConsumerWidget {
  const AuditTrailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(auditEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit trail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(auditEntriesProvider),
          ),
          const SignOutAction(),
        ],
      ),
      body: Column(
        children: [
          const _Filters(),
          const Divider(height: 1),
          Expanded(
            child: entries.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _Failed(
                message: error is AuditUnavailable
                    ? error.message
                    : 'The audit trail could not be read.',
                onRetry: () => ref.invalidate(auditEntriesProvider),
              ),
              data: (data) => data.isEmpty
                  ? const _Empty()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: data.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _EntryTile(entry: data[index]),
                    ),
            ),
          ),
          const _AppendOnlyNotice(),
        ],
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(auditFilterProvider);
    final controller = ref.read(auditFilterProvider.notifier);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.date_range, size: 18),
            label: Text(
              filter.from == null && filter.to == null
                  ? 'Any period'
                  : '${filter.from == null ? '…' : dates.format(filter.from!)}'
                        ' – '
                        '${filter.to == null ? '…' : dates.format(filter.to!)}',
            ),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (range == null) return;
              controller.setPeriod(from: range.start, to: range.end);
            },
          ),
          DropdownMenu<String?>(
            initialSelection: filter.operation,
            label: const Text('Action'),
            dropdownMenuEntries: const [
              DropdownMenuEntry<String?>(value: null, label: 'Any action'),
              DropdownMenuEntry<String?>(value: 'Create', label: 'Created'),
              DropdownMenuEntry<String?>(value: 'Update', label: 'Updated'),
              DropdownMenuEntry<String?>(value: 'Delete', label: 'Deleted'),
              DropdownMenuEntry<String?>(value: 'Import', label: 'Imported'),
              DropdownMenuEntry<String?>(value: 'Export', label: 'Exported'),
            ],
            onSelected: controller.setOperation,
          ),
          if (!filter.isEmpty)
            TextButton(
              onPressed: controller.clear,
              child: const Text('Clear filters'),
            ),
        ],
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final AuditEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final when = DateFormat.yMMMd(locale).add_Hm().format(entry.occurredAt);

    final (icon, colour) = switch (entry.result) {
      AuditResult.succeeded => (
        Icons.check_circle_outline,
        theme.colorScheme.primary,
      ),
      AuditResult.refused => (Icons.block_outlined, theme.colorScheme.error),
      AuditResult.unknown => (Icons.help_outline, theme.colorScheme.outline),
    };

    return ListTile(
      leading: Icon(icon, color: colour, size: 20),
      title: Text('${entry.operation} · ${entry.entityType}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(when),
          if (entry.reason case final String reason)
            Text(reason, style: TextStyle(color: theme.colorScheme.error)),
          // AF-04. The record may be long gone, so the identifier is shown as
          // a reference rather than as a link that would imply it can be
          // opened. The entry still says exactly what it recorded.
          if (entry.entityId case final String id)
            Text(
              'Record $id',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
        ],
      ),
      isThreeLine: entry.reason != null || entry.entityId != null,
    );
  }
}

/// `AF-03`. Nothing here can be edited or deleted, and rather than leaving the
/// absence of those controls to be inferred, the reason is stated.
class _AppendOnlyNotice extends StatelessWidget {
  const _AppendOnlyNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 18, color: theme.colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The audit trail is append-only. Entries cannot be changed or '
              'removed, including by you — a trail that can be pruned is not '
              'one.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends ConsumerWidget {
  const _Empty();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = !ref.watch(auditFilterProvider).isEmpty;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history, size: 40),
              const SizedBox(height: 16),
              Text(
                filtered ? 'Nothing in that period' : 'Nothing recorded yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                filtered
                    ? 'No entries match the filters you have set.'
                    : 'Significant actions on your records appear here as they '
                          'happen.',
                textAlign: TextAlign.center,
              ),
              if (filtered) ...[
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: ref.read(auditFilterProvider.notifier).clear,
                  child: const Text('Clear filters'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
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

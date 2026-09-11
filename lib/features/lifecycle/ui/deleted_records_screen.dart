/// Deleted records (UC-40).
///
/// The two actions are kept visibly apart (`FR-LC-01`). Restoring is ordinary
/// and needs no ceremony. Permanent removal is not: it is confirmed on its
/// own, in a dialog that says in as many words that it cannot be undone
/// (`FR-LC-03`), and it appears **only** here — a record must be deleted
/// before it can be removed for good (`FR-LC-02`, `AF-05`), and this is the
/// only screen deleted records appear in at all.
///
/// Where the instance says something still points at a record, that is shown
/// *before* the confirmation rather than discovered in a refusal after it
/// (`AF-06`). The control is still offered: whether the removal is allowed is
/// the API's to decide, and hiding it on a guess would leave the user unable
/// to find out why (`AF-01`, `FR-LC-05`).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../data/deleted_record_repository.dart';
import '../state/deleted_record_providers.dart';

class DeletedRecordsScreen extends ConsumerWidget {
  const DeletedRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(deletedRecordsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Deleted records')),
      body: records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // AF-03 arrives here too.
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$error',
                  key: const Key('deleted.error'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('deleted.retry'),
                  onPressed: () => ref.invalidate(deletedRecordsProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (list) {
          // AF-04.
          if (list.isEmpty) {
            return const Center(
              key: Key('deleted.empty'),
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline, size: 40),
                    SizedBox(height: 16),
                    Text('Nothing is deleted'),
                    SizedBox(height: 8),
                    Text(
                      'Records you delete appear here, where they can be '
                      'brought back or removed for good.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) => _RecordTile(record: list[index]),
          );
        },
      ),
    );
  }
}

class _RecordTile extends ConsumerStatefulWidget {
  const _RecordTile({required this.record});

  final DeletedRecord record;

  @override
  ConsumerState<_RecordTile> createState() => _RecordTileState();
}

class _RecordTileState extends ConsumerState<_RecordTile> {
  String? _reason;
  var _busy = false;

  Future<void> _restore() async {
    setState(() {
      _reason = null;
      _busy = true;
    });

    final result = await ref
        .read(deletedRecordActionsProvider)
        .restore(widget.record);

    if (!mounted) return;

    // AF-02: the API's reason, shown on the record it concerns.
    setState(() {
      _busy = false;
      _reason = switch (result) {
        Success<void>() => null,
        Failure<void>(:final message) => message,
      };
    });
  }

  /// Step 4: its own confirmation, stating plainly that it cannot be undone.
  Future<void> _purge() async {
    final record = widget.record;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('deleted.purge.confirm'),
        title: const Text('Remove permanently?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${record.kind.label} "${record.label}" will be removed for '
              'good.',
            ),
            const SizedBox(height: 12),
            // FR-LC-03, in as many words.
            const Text(
              'This cannot be undone. Unlike deleting, there is no way to '
              'bring it back afterwards.',
              key: Key('deleted.purge.cannotBeUndone'),
            ),

            // AF-06: what else this would reach, before the decision.
            if (record.isStillReferenced) ...[
              const SizedBox(height: 12),
              Text(
                '${record.stillUsedBy} other '
                '${record.stillUsedBy == 1 ? 'record' : 'records'} still '
                'refer to this one. The instance may refuse to remove it, or '
                'may take them with it.',
                key: const Key('deleted.purge.stillReferenced'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            key: const Key('deleted.purge.cancel'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            key: const Key('deleted.purge.proceed'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove permanently'),
          ),
        ],
      ),
    );

    if (!(confirmed ?? false) || !mounted) return;

    setState(() {
      _reason = null;
      _busy = true;
    });

    final result = await ref
        .read(deletedRecordActionsProvider)
        .purge(widget.record);

    if (!mounted) return;

    // AF-01 and FR-LC-05: the API names what still refers to it, and that is
    // what the user reads.
    setState(() {
      _busy = false;
      _reason = switch (result) {
        Success<void>() => null,
        Failure<void>(:final message) => message,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final record = widget.record;

    return Card(
      key: Key('deleted.item.${record.id}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Step 1: marked as deleted, in words as well as by being
                // here at all.
                Container(
                  key: Key('deleted.badge.${record.id}'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Deleted ${record.kind.label.toLowerCase()}',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(record.label, style: theme.textTheme.titleMedium),
            if (record.detail case final detail? when detail.isNotEmpty)
              Text(detail, style: theme.textTheme.bodySmall),

            if (record.isStillReferenced) ...[
              const SizedBox(height: 8),
              Text(
                '${record.stillUsedBy} other '
                '${record.stillUsedBy == 1 ? 'record' : 'records'} still '
                'refer to this one.',
                key: Key('deleted.referenced.${record.id}'),
                style: theme.textTheme.bodySmall,
              ),
            ],

            if (_reason case final reason?) ...[
              const SizedBox(height: 12),
              Text(
                reason,
                key: Key('deleted.reason.${record.id}'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Step 2. Ordinary, and needing no ceremony: a restore can
                // be undone by deleting again.
                FilledButton.tonal(
                  key: Key('deleted.restore.${record.id}'),
                  onPressed: _busy ? null : () => unawaited(_restore()),
                  child: const Text('Restore'),
                ),
                const SizedBox(width: 8),
                // Step 3. Separate, and destructive.
                TextButton(
                  key: Key('deleted.purge.${record.id}'),
                  onPressed: _busy ? null : () => unawaited(_purge()),
                  child: Text(
                    'Remove permanently',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

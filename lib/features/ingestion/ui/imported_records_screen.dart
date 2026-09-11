/// The records an import took in (UC-34).
///
/// Everything here is read-only, and that is a property of the code rather
/// than a discipline of the screen: the repository behind it offers no write
/// at all. `AF-01` is therefore not a rule this screen remembers to enforce —
/// it is a capability the client does not have, and the screen's job is to
/// say where a correction *does* belong.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/format/supported_locales.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/imported_record_repository.dart';
import '../state/imported_record_providers.dart';

class ImportedRecordsScreen extends ConsumerStatefulWidget {
  const ImportedRecordsScreen({required this.jobId, super.key});

  final String jobId;

  @override
  ConsumerState<ImportedRecordsScreen> createState() =>
      _ImportedRecordsScreenState();
}

class _ImportedRecordsScreenState extends ConsumerState<ImportedRecordsScreen> {
  late var _request = RecordPageRequest(jobId: widget.jobId);

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(importedRecordsProvider(_request));

    return Scaffold(
      appBar: AppBar(title: const Text('Imported records')),
      bottomNavigationBar: switch (records) {
        AsyncData(value: final page) when page.totalPages > 1 => _Pagination(
          page: page,
          onGoTo: (number) =>
              setState(() => _request = _request.atPage(number)),
        ),
        _ => null,
      },
      body: records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // AF-04.
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$error',
                  key: const Key('records.error'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('records.retry'),
                  onPressed: () =>
                      ref.invalidate(importedRecordsProvider(_request)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (page) {
          // AF-03.
          if (page.isEmpty) {
            return const Center(
              key: Key('records.empty'),
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined, size: 40),
                    SizedBox(height: 16),
                    Text('This import took in no records.'),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: page.items.length + 1,
            itemBuilder: (context, index) {
              // Step 4, said once at the top rather than on every row.
              if (index == 0) return const _ReadOnlyNotice();

              return _RecordTile(record: page.items[index - 1], index: index);
            },
          );
        },
      ),
    );
  }
}

/// Step 4 and `AF-01`: read-only, and where to make a correction instead.
class _ReadOnlyNotice extends StatelessWidget {
  const _ReadOnlyNotice();

  @override
  Widget build(BuildContext context) => Card(
    key: const Key('records.readOnlyNotice'),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'These are the records exactly as they arrived, and they cannot '
              'be changed. They are what the import is reconciled against. To '
              'correct something, open the transaction a record produced and '
              'edit that instead.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RecordTile extends ConsumerWidget {
  const _RecordTile({required this.record, required this.index});

  final ImportedRecord record;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );

    return Card(
      key: Key('records.item.$index'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _OutcomeChip(outcome: record.outcome, index: index),
                const Spacer(),
                if (record.occurredOn case final date?)
                  Text(
                    DateFormat.yMMMd(locale).format(date),
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // The row's own figures, shown as the text they arrived as. Not
            // formatted as money: a raw record carries no currency, and
            // presenting one would be inventing a denomination.
            if (record.amount case final amount?)
              Text(
                amount,
                key: Key('records.amount.$index'),
                style: theme.textTheme.titleMedium,
              ),
            if (record.externalId case final id? when id.isNotEmpty)
              Text('Reference $id', style: theme.textTheme.bodySmall),

            // AF-02: why nothing was derived, in the API's own words.
            if (record.producedNothing) ...[
              const SizedBox(height: 8),
              Row(
                key: Key('records.noTransaction.$index'),
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      record.rejectionReason ??
                          (record.outcome == RecordOutcome.duplicate
                              ? 'This row was already present, so no '
                                    'transaction was created from it.'
                              : 'No transaction was created from this row.'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],

            // Step 3: the transaction derived from it, where one still is.
            if (record.canOpenTransaction) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: Key('records.openTransaction.$index'),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('Open the transaction'),
                  onPressed: () =>
                      context.go(Routes.transactionOf(record.transactionId!)),
                ),
              ),
            ] else if (record.outcome.producedTransaction) ...[
              const SizedBox(height: 8),
              Text(
                // Imported, but the transaction is gone. Saying so beats
                // offering a link to something that is no longer there.
                'The transaction this produced has since been deleted.',
                key: Key('records.transactionGone.$index'),
                style: theme.textTheme.bodySmall,
              ),
            ],

            if (record.rawPayload case final payload? when payload.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ExpansionTile(
                  key: Key('records.payload.$index'),
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'The row as it arrived',
                    style: theme.textTheme.labelLarge,
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Selectable so it can be copied into a support message,
                      // and never editable.
                      child: SelectableText(
                        payload,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OutcomeChip extends StatelessWidget {
  const _OutcomeChip({required this.outcome, required this.index});

  final RecordOutcome outcome;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Not colour alone (NFR-17): each outcome is named as well as tinted.
    final (background, foreground) = switch (outcome) {
      RecordOutcome.imported => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      RecordOutcome.duplicate => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      RecordOutcome.rejected => (
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      RecordOutcome.unknown => (
        scheme.surfaceContainerHighest,
        scheme.onSurface,
      ),
    };

    return Container(
      key: Key('records.outcome.$index'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        outcome.label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: foreground),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({required this.page, required this.onGoTo});

  final ImportedRecordPage page;
  final void Function(int) onGoTo;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 3,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              key: const Key('records.previous'),
              icon: const Icon(Icons.chevron_left),
              onPressed: page.hasPrevious
                  ? () => onGoTo(page.pageNumber - 1)
                  : null,
            ),
            Text(
              'Page ${page.pageNumber} of ${page.totalPages}',
              key: const Key('records.pageNumber'),
            ),
            IconButton(
              key: const Key('records.next'),
              icon: const Icon(Icons.chevron_right),
              onPressed: page.hasNext
                  ? () => onGoTo(page.pageNumber + 1)
                  : null,
            ),
          ],
        ),
      ),
    ),
  );
}

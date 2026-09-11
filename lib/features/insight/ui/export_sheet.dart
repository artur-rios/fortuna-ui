/// Exporting the current view (UC-39).
///
/// Step 2 is the part that is easy to skip and worth not skipping: **the
/// export states what it will cover before it is produced**, with the current
/// view's filters named in words (`FR-EX-03`). A file whose scope the user
/// never saw is one they cannot check — and a spreadsheet that quietly
/// carried only last month's rows is a mistake they may not notice for
/// months.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/export_repository.dart';
import '../state/export_controller.dart';

Future<void> showExportSheet(
  BuildContext context,
  WidgetRef ref, {
  required String recordSet,
  required List<ExportFilter> filters,
  required bool hasData,
  String? displayCurrencyCode,
  String? locale,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (context) => ExportSheet(
    recordSet: recordSet,
    filters: filters,
    hasData: hasData,
    displayCurrencyCode: displayCurrencyCode,
    locale: locale,
  ),
);

class ExportSheet extends ConsumerStatefulWidget {
  const ExportSheet({
    required this.recordSet,
    required this.filters,
    required this.hasData,
    this.displayCurrencyCode,
    this.locale,
    super.key,
  });

  /// What is being exported, as the API names it.
  final String recordSet;

  /// The current view's filters (`FR-EX-03`).
  final List<ExportFilter> filters;

  /// Whether the view has anything in it (`AF-01`).
  final bool hasData;

  final String? displayCurrencyCode;
  final String? locale;

  @override
  ConsumerState<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends ConsumerState<ExportSheet> {
  ExportFormat _format = ExportFormat.csv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = ref.watch(exportControllerProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Export', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            // AF-01: not offered, and the reason said rather than left to be
            // inferred from a disabled button.
            if (!widget.hasData)
              const _NothingToExport()
            else
              switch (progress) {
                ExportIdle() => _Chooser(
                  format: _format,
                  filters: widget.filters,
                  onFormat: (value) => setState(() => _format = value),
                  onProduce: _produce,
                ),
                ExportRunning(:final export) => _Running(export: export),
                ExportReady(:final saveRefusal) => _Ready(
                  saveRefusal: saveRefusal,
                ),
                ExportSaved(:final path) => _Saved(path: path),
                ExportFailed(:final reason) => _Failed(
                  reason: reason,
                  onRetry: _produce,
                ),
                ExportExpired() => _Expired(onProduceAnother: _produce),
              },
          ],
        ),
      ),
    );
  }

  Future<void> _produce() => ref
      .read(exportControllerProvider.notifier)
      .produce(
        recordSet: widget.recordSet,
        format: _format,
        filters: widget.filters,
        displayCurrencyCode: widget.displayCurrencyCode,
        locale: widget.locale,
      );
}

/// AF-01.
class _NothingToExport extends StatelessWidget {
  const _NothingToExport();

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('export.nothingToExport'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'There is nothing in this view to export. Widen the filters, '
              'or record something first.',
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      FilledButton(
        key: const Key('export.close'),
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
    ],
  );
}

/// Steps 1 and 2.
class _Chooser extends StatelessWidget {
  const _Chooser({
    required this.format,
    required this.filters,
    required this.onFormat,
    required this.onProduce,
  });

  final ExportFormat format;
  final List<ExportFilter> filters;
  final void Function(ExportFormat) onFormat;
  final Future<void> Function() onProduce;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step 2, and FR-EX-03. Named in words, before anything is produced.
        Card(
          key: const Key('export.scope'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What this will cover', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                if (filters.isEmpty)
                  const Text(
                    'Everything in this view. No filters are applied.',
                    key: Key('export.scope.unfiltered'),
                  )
                else
                  for (final filter in filters)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '• ${filter.description}',
                        key: Key('export.scope.${filter.field}'),
                      ),
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text('Format', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<ExportFormat>(
          key: const Key('export.format'),
          segments: [
            // AF-06: the formats this instance produces. An instance that
            // refuses one for this data set says so in its own words, which
            // is the only authority on it there is.
            for (final value in ExportFormat.values)
              ButtonSegment(value: value, label: Text(value.label)),
          ],
          selected: {format},
          onSelectionChanged: (selection) => onFormat(selection.first),
        ),
        const SizedBox(height: 12),

        Text(
          'The instance produces the file. Nothing is rendered here, so what '
          'you save is what it holds.',
          style: theme.textTheme.bodySmall,
        ),

        const SizedBox(height: 20),
        FilledButton(
          key: const Key('export.produce'),
          onPressed: () => unawaited(onProduce()),
          child: const Text('Export'),
        ),
      ],
    );
  }
}

/// Step 4 and `AF-05`.
class _Running extends StatelessWidget {
  const _Running({this.export});

  final DataExport? export;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      key: const Key('export.running'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LinearProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          export == null
              ? 'Asking the instance to produce it…'
              : 'The instance is producing it.',
        ),
        const SizedBox(height: 8),
        Text(
          // AF-05, said rather than implied: closing this does not cancel it.
          'You can close this and carry on — the export keeps going, and you '
          'will find it with your other jobs.',
          key: const Key('export.running.keepsGoing'),
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 20),
        TextButton(
          key: const Key('export.running.close'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Step 5.
class _Ready extends ConsumerWidget {
  const _Ready({this.saveRefusal});

  final String? saveRefusal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      key: const Key('export.ready'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('The export is ready.'),

        // AF-03: the refusal is reported and the save offered again. The file
        // has not gone anywhere.
        if (saveRefusal case final refusal?) ...[
          const SizedBox(height: 12),
          Text(
            refusal,
            key: const Key('export.saveRefused'),
            style: TextStyle(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 4),
          Text(
            'The file is still here. Choose another place for it.',
            style: theme.textTheme.bodySmall,
          ),
        ],

        const SizedBox(height: 20),
        FilledButton(
          key: const Key('export.save'),
          onPressed: () =>
              unawaited(ref.read(exportControllerProvider.notifier).save()),
          child: Text(saveRefusal == null ? 'Save it' : 'Choose another place'),
        ),
      ],
    );
  }
}

class _Saved extends StatelessWidget {
  const _Saved({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('export.saved'),
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          const Expanded(child: Text('Saved.')),
        ],
      ),
      const SizedBox(height: 8),
      Text(path, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 20),
      FilledButton(
        key: const Key('export.done'),
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Done'),
      ),
    ],
  );
}

/// AF-02.
class _Failed extends StatelessWidget {
  const _Failed({required this.reason, required this.onRetry});

  final String reason;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('export.failed'),
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        reason,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      const SizedBox(height: 20),
      FilledButton(
        key: const Key('export.retry'),
        onPressed: () => unawaited(onRetry()),
        child: const Text('Try again'),
      ),
    ],
  );
}

/// AF-04.
class _Expired extends StatelessWidget {
  const _Expired({required this.onProduceAnother});

  final Future<void> Function() onProduceAnother;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('export.expired'),
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'That export is no longer available — the instance keeps one only '
        'for a while. Producing another takes a moment.',
      ),
      const SizedBox(height: 20),
      FilledButton(
        key: const Key('export.produceAnother'),
        onPressed: () => unawaited(onProduceAnother()),
        child: const Text('Produce another'),
      ),
    ],
  );
}

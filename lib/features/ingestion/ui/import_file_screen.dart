/// Importing a file (UC-32).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../session/ui/sign_out_action.dart';
import '../data/import_upload_repository.dart';
import '../state/import_upload_controller.dart';

class ImportFileScreen extends ConsumerWidget {
  const ImportFileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importUploadProvider);
    final controller = ref.read(importUploadProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import a file'),
        actions: const [SignOutAction()],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Text(
                'The file is uploaded exactly as it is. Fortuna reads it; '
                'nothing here changes it.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              for (final source in ImportSource.values) ...[
                _SourceCard(
                  source: source,
                  enabled: state is! ImportUploading,
                  onChoose: () => unawaited(controller.choose(source)),
                ),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 12),
              _StateView(state: state),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.source,
    required this.enabled,
    required this.onChoose,
  });

  final ImportSource source;
  final bool enabled;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(
        source == ImportSource.excel
            ? Icons.table_chart_outlined
            : Icons.picture_as_pdf_outlined,
      ),
      title: Text(source.label),
      subtitle: Text(
        '${source.description}\nAccepts ${source.acceptedTypesLabel}.',
      ),
      isThreeLine: true,
      trailing: FilledButton.tonal(
        onPressed: enabled ? onChoose : null,
        child: const Text('Choose file'),
      ),
    ),
  );
}

class _StateView extends ConsumerWidget {
  const _StateView({required this.state});

  final ImportState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(importUploadProvider.notifier);
    final theme = Theme.of(context);

    return switch (state) {
      ImportIdle() => const SizedBox.shrink(),

      // AF-01, AF-02: refused before anything was sent, naming why.
      ImportRejected(:final reason) => _Notice(
        icon: Icons.block_outlined,
        colour: theme.colorScheme.error,
        title: 'That file was not sent',
        body: reason,
      ),

      ImportReady(:final upload) => _Notice(
        icon: Icons.description_outlined,
        colour: theme.colorScheme.primary,
        title: upload.fileName,
        body: '${(upload.sizeBytes / 1024).round()} KB, ready to send.',
        action: FilledButton(
          onPressed: () => unawaited(controller.upload()),
          child: const Text('Import this file'),
        ),
      ),

      ImportUploading(:final upload) => _Notice(
        icon: Icons.upload_outlined,
        colour: theme.colorScheme.primary,
        title: 'Sending ${upload.fileName}…',
        body: 'The file is being uploaded exactly as it is.',
        progress: true,
      ),

      // AF-04, AF-05: the reason, and the same file offered again.
      ImportFailed(:final upload, :final reason) => _Notice(
        icon: Icons.error_outline,
        colour: theme.colorScheme.error,
        title: 'The import did not start',
        body: reason,
        action: FilledButton(
          onPressed: () => unawaited(controller.upload()),
          child: Text('Try ${upload.fileName} again'),
        ),
      ),

      ImportStarted() => _Notice(
        icon: Icons.check_circle_outline,
        colour: theme.colorScheme.primary,
        title: 'The import has started',
        body:
            'It runs on the instance. You can follow it under Imports, and '
            'it keeps going if you leave this screen.',
        action: TextButton(
          onPressed: controller.reset,
          child: const Text('Import another file'),
        ),
      ),
    };
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.colour,
    required this.title,
    required this.body,
    this.action,
    this.progress = false,
  });

  final IconData icon;
  final Color colour;
  final String title;
  final String body;
  final Widget? action;
  final bool progress;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colour),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(body),
          if (progress) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],
          if (action case final Widget action) ...[
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerRight, child: action),
          ],
        ],
      ),
    ),
  );
}

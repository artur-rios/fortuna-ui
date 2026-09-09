/// Import and synchronization jobs (UC-33).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/supported_locales.dart';
import '../../preferences/state/preferences_controller.dart';
import '../../session/ui/sign_out_action.dart';
import '../data/import_job_repository.dart';
import '../state/import_job_providers.dart';

class ImportJobsScreen extends ConsumerWidget {
  const ImportJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(importJobsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Imports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(importJobsProvider),
          ),
          const SignOutAction(),
        ],
      ),
      body: jobs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Failed(
          message: error is JobsUnavailable
              ? error.message
              : 'The imports could not be loaded.',
          onRetry: () => ref.invalidate(importJobsProvider),
        ),
        data: (data) => data.isEmpty
            ? const _Empty()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) => _JobCard(job: data[index]),
              ),
      ),
    );
  }
}

class _JobCard extends ConsumerWidget {
  const _JobCard({required this.job});

  final ImportJob job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final started = DateFormat.yMMMd(locale).add_Hm().format(job.startedAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StateChip(state: job.state),
                const Spacer(),
                Text(started, style: theme.textTheme.bodySmall),
              ],
            ),

            // AF-05. The API supplies no progress figure and no row total, so
            // there is nothing to compute a percentage from — an indeterminate
            // bar and the count of rows read so far, never a fabricated one.
            if (!job.isFinished) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                job.processed == 0
                    ? 'Starting…'
                    : '${job.processed} rows read so far',
                style: theme.textTheme.bodySmall,
              ),
            ],

            if (job.isFinished) ...[
              const SizedBox(height: 12),
              _Outcomes(job: job),
            ],

            // AF-01. The failure and its reason, then a retry.
            if (job.state == JobState.failed) ...[
              const SizedBox(height: 12),
              Text(
                job.failureReason ?? 'The import failed.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: () => _retry(context, ref),
                  child: const Text('Retry this import'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _retry(BuildContext context, WidgetRef ref) async {
    final failure = await ref.read(importJobActionsProvider).retry(job.id);
    if (failure == null || !context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure.message)));
  }
}

/// `AF-02`. The three outcomes are shown separately and always — a partial
/// import is never collapsed into a plain success or a plain failure, because
/// one malformed line in a 400-row statement must not read as either.
class _Outcomes extends StatelessWidget {
  const _Outcomes({required this.job});

  final ImportJob job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _Count(
              label: 'imported',
              value: job.imported,
              colour: theme.colorScheme.primary,
            ),
            _Count(
              label: 'skipped as duplicates',
              value: job.duplicates,
              colour: theme.colorScheme.outline,
            ),
            _Count(
              label: 'rejected',
              value: job.rejected,
              colour: job.rejected > 0
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline,
            ),
          ],
        ),
        if (job.isPartial) ...[
          const SizedBox(height: 8),
          Text(
            'Some rows landed and some did not. The rows that failed did not '
            'stop the others.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({
    required this.label,
    required this.value,
    required this.colour,
  });

  final String label;
  final int value;
  final Color colour;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        '$value',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colour),
      ),
      const SizedBox(width: 4),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

/// A state by shape and word, not colour alone (`NFR-17`).
class _StateChip extends StatelessWidget {
  const _StateChip({required this.state});

  final JobState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (icon, label, colour) = switch (state) {
      JobState.pending => (Icons.schedule, 'Queued', scheme.outline),
      JobState.running => (Icons.sync, 'Running', scheme.primary),
      JobState.completed => (
        Icons.check_circle_outline,
        'Finished',
        scheme.primary,
      ),
      JobState.failed => (Icons.error_outline, 'Failed', scheme.error),
      JobState.unknown => (Icons.help_outline, 'Unknown', scheme.outline),
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
      constraints: const BoxConstraints(maxWidth: 380),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 40),
            const SizedBox(height: 16),
            Text(
              'No imports yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Imports and bank synchronizations appear here while they run, '
              'and stay afterwards so you can see what they did.',
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

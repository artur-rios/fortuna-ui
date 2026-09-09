/// The administrative area (UC-45).
///
/// Everything on this screen is operational. There is no financial figure,
/// record or aggregate anywhere in it, and there is no route from it to one —
/// running the instance is not a reason to read its contents (`FR-AD-03`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../session/ui/sign_out_action.dart';
import '../data/health_repository.dart';

class InstanceHealthScreen extends ConsumerWidget {
  const InstanceHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(instanceHealthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instance health'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(instanceHealthProvider),
          ),
          const SignOutAction(),
        ],
      ),
      body: health.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Failed(
          message: error is HealthUnavailable
              ? error.message
              : 'The instance health could not be read.',
          onRetry: () => ref.invalidate(instanceHealthProvider),
        ),
        data: (data) => _Report(health: data),
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.health});

  final InstanceHealth health;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _AggregateCard(health: health),
      const SizedBox(height: 16),
      if (health.services.isEmpty)
        const ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('The instance reported no dependencies.'),
        )
      else
        for (final service in health.services) _ServiceTile(service: service),
    ],
  );
}

class _AggregateCard extends StatelessWidget {
  const _AggregateCard({required this.health});

  final InstanceHealth health;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final troubled = health.troubled;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusChip(status: health.status, raw: health.rawStatus),
                const SizedBox(width: 12),
                Text('Instance', style: theme.textTheme.titleMedium),
              ],
            ),
            // AF-05: a degraded instance says which dependency caused it.
            if (troubled.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                troubled.length == 1
                    ? 'Caused by ${troubled.single.name}.'
                    : 'Caused by ${troubled.map((s) => s.name).join(', ')}.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});

  final ServiceHealth service;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (service.queueDepth case final int depth) 'queue depth $depth',
      if (service.oldestPendingSeconds case final int seconds)
        'oldest pending ${seconds}s',
    ];

    return ListTile(
      leading: _StatusChip(status: service.status, raw: service.rawStatus),
      title: Text(service.name),
      subtitle: details.isEmpty ? null : Text(details.join(' · ')),
    );
  }
}

/// A status, by shape and label rather than by colour alone (`NFR-17`).
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.raw});

  final HealthStatus status;
  final String raw;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (icon, label, colour) = switch (status) {
      HealthStatus.healthy => (
        Icons.check_circle_outline,
        'Healthy',
        scheme.primary,
      ),
      HealthStatus.degraded => (
        Icons.warning_amber_outlined,
        'Degraded',
        scheme.tertiary,
      ),
      HealthStatus.unhealthy => (
        Icons.error_outline,
        'Unhealthy',
        scheme.error,
      ),
      // AF-02: not configured is its own thing, not a failure.
      HealthStatus.notConfigured => (
        Icons.remove_circle_outline,
        'Not configured',
        scheme.outline,
      ),
      // Shown as the API named it, rather than mapped onto something
      // reassuring that it might not be.
      HealthStatus.unknown => (Icons.help_outline, raw, scheme.outline),
    };

    return Tooltip(
      message: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colour),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: colour)),
        ],
      ),
    );
  }
}

/// `AF-01` and `AF-03`. No data at all rather than a partial view: half a
/// health report is worse than none, because it reads as reassurance.
class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 16),
            Text(
              'The instance health could not be read',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    ),
  );
}

/// Consents, and who controls the data (UC-42).
///
/// The controller line at the top is not decoration. On a shared instance
/// somebody else is responsible for this data and there is a notice and a
/// rights route to point at; self-hosted or offline, the user is responsible
/// and inventing an operator would be a lie (`FR-PR-09`, `FR-PR-10`, `AF-05`).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/instance_config.dart';
import '../data/consent_repository.dart';
import '../state/consent_controller.dart';
import '../state/personal_export_controller.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(consentControllerProvider.notifier).load());
    });
  }

  /// Step 4: the disclosure, before anything is recorded.
  Future<void> _askFor(Consent consent) async {
    final controller = ref.read(consentControllerProvider.notifier);

    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(consent.label),
        content: Text(
          'Giving this consent lets Fortuna send the data this feature needs '
          'to an external service on your behalf. Nothing is sent until you '
          'agree, and you can withdraw it at any time.\n\n'
          'Version ${consent.currentVersion ?? 'unknown'}.',
        ),
        actions: [
          TextButton(
            key: const Key('privacy.decline'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            key: const Key('privacy.agree'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('I agree'),
          ),
        ],
      ),
    );

    if (agreed ?? false) {
      await controller.grant(
        purpose: consent.purpose,
        version: consent.currentVersion ?? '',
      );
    } else {
      // AF-04. Nothing recorded, and the feature stays unavailable with the
      // reason said out loud.
      controller.decline(consent.purpose);
    }
  }

  /// Step 5: name what withdrawing revokes, before confirming it.
  Future<void> _withdraw(Consent consent) async {
    final controller = ref.read(consentControllerProvider.notifier);
    final consequences = await controller.consequencesOfWithdrawing(
      consent.purpose,
    );

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw this consent?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AF-02: named, not counted. "2 connections" tells the user
            // nothing about which two.
            if (consequences.revokesConnections) ...[
              const Text('These connections will be revoked:'),
              const SizedBox(height: 8),
              for (final connection in consequences.connections)
                Text(
                  '• ${connection.externalReference ?? connection.id}',
                  key: Key('privacy.revoked.${connection.id}'),
                ),
              const SizedBox(height: 12),
            ] else
              const Text(
                'Any connections that depend on this consent will be revoked.',
              ),
            const Text(
              'Data already imported stays where it is. Withdrawing stops '
              'anything further being sent; it does not delete what you '
              'already have.',
            ),
          ],
        ),
        actions: [
          TextButton(
            key: const Key('privacy.cancelWithdraw'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            key: const Key('privacy.confirmWithdraw'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) await controller.withdraw(consent.purpose);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(consentControllerProvider);
    final controller = DataController.forMode(
      ref.watch(instanceConfigProvider).mode,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Controller(controller: controller),
          const SizedBox(height: 24),

          Text('Consents', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          switch (state) {
            ConsentsLoading() => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),

            // AF-06: reported, and nothing proceeds on an assumption.
            ConsentsUnavailable(:final reason) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Notice(
                  key: const Key('privacy.unavailable'),
                  message: reason,
                  isError: true,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nothing that needs a consent will run until this can be '
                  'read.',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('privacy.retry'),
                  onPressed: () => unawaited(
                    ref.read(consentControllerProvider.notifier).load(),
                  ),
                  child: const Text('Try again'),
                ),
              ],
            ),

            ConsentsReady(:final consents, :final notice) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (notice != null) ...[
                  _Notice(
                    key: const Key('privacy.notice'),
                    message: notice,
                    isError: false,
                  ),
                  const SizedBox(height: 12),
                ],
                if (consents.isEmpty)
                  const Text('This instance asks for no consents.')
                else
                  for (final consent in consents)
                    _ConsentTile(
                      consent: consent,
                      onGive: () => unawaited(_askFor(consent)),
                      onWithdraw: () => unawaited(_withdraw(consent)),
                    ),
              ],
            ),
          },

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          const _PersonalExport(),
        ],
      ),
    );
  }
}

/// UC-43, on the same screen the right is exercised from.
class _PersonalExport extends ConsumerWidget {
  const _PersonalExport();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalExportControllerProvider);
    final controller = ref.read(personalExportControllerProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Take everything', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          // Step 2. Said before anything is requested, because "export" already
          // means something else in this application and the two are not
          // interchangeable.
          'This is everything the instance holds about you, in a '
          'machine-readable archive — the portability right. It is not the '
          'same as '
          'exporting a data set from the spreadsheet or chart screens, which '
          'gives you only what you asked for.',
          key: const Key('export.explanation'),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        switch (state) {
          PersonalExportIdle() => FilledButton(
            key: const Key('export.request'),
            onPressed: () => unawaited(controller.request()),
            child: const Text('Produce my archive'),
          ),

          // AF-04: the job runs on the instance. Leaving does not cancel it.
          PersonalExportRunning(:final export) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                key: const Key('export.progress'),
                value: export.progress > 0 ? export.progress / 100 : null,
              ),
              const SizedBox(height: 8),
              const Text(
                'This runs on the instance. You can leave this screen and '
                'come back to it.',
                key: Key('export.keepsRunning'),
              ),
            ],
          ),

          PersonalExportReady() => FilledButton(
            key: const Key('export.save'),
            onPressed: () => unawaited(controller.save()),
            child: const Text('Save the archive'),
          ),

          // AF-02: gone before it was fetched, and a new one can be made.
          PersonalExportExpired() => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Notice(
                key: Key('export.expired'),
                message:
                    'That archive expired before it was downloaded. Nothing '
                    'is wrong with your data — the copy was just cleaned up.',
                isError: false,
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('export.requestAgain'),
                onPressed: () => unawaited(controller.request()),
                child: const Text('Produce a new one'),
              ),
            ],
          ),

          // AF-01: the reason, and a retry.
          PersonalExportFailed(:final reason) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Notice(
                key: const Key('export.failed'),
                message: reason,
                isError: true,
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('export.retry'),
                onPressed: () => unawaited(controller.request()),
                child: const Text('Try again'),
              ),
            ],
          ),

          // AF-03: the archive is still there; only the location was refused.
          PersonalExportSaveRefused(:final reason) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Notice(
                key: const Key('export.saveRefused'),
                message: reason,
                isError: true,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your archive is still ready. Choose somewhere else.',
                key: Key('export.stillReady'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('export.saveAgain'),
                onPressed: () => unawaited(controller.save()),
                child: const Text('Choose a location'),
              ),
            ],
          ),

          PersonalExportSaved(:final where, :final sizeBytes) => _Notice(
            key: const Key('export.saved'),
            // AF-05: a near-empty archive is a valid one, and the size says so
            // without dressing it up as a problem.
            message: 'Saved to $where ($sizeBytes bytes).',
            isError: false,
          ),
        },
      ],
    );
  }
}

class _Controller extends StatelessWidget {
  const _Controller({required this.controller});

  final DataController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: const Key('privacy.controller'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Who controls this data', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              controller.hasOperatorNotice
                  ? 'This is a shared instance. Whoever operates it is the '
                        'data controller, and their privacy notice and rights '
                        'process apply.'
                  // AF-05. No operator, so none is implied.
                  : 'You run this instance yourself, so you are the data '
                        'controller. There is no operator involved and no '
                        'third-party privacy notice that applies.',
              style: theme.textTheme.bodyMedium,
            ),
            if (controller.hasOperatorNotice) ...[
              const SizedBox(height: 12),
              Text(
                "Ask the instance's operator for their privacy notice and for "
                'how to make a rights request. Fortuna does not publish one '
                'on their behalf.',
                key: const Key('privacy.operatorNotice'),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    required this.consent,
    required this.onGive,
    required this.onWithdraw,
  });

  final Consent consent;
  final VoidCallback onGive;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: Key('privacy.consent.${consent.purpose}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(consent.label, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              // Step 1: the version agreed to, and when.
              switch (consent) {
                final c when c.isOutdated =>
                  'You agreed to version ${c.grantedVersion}, but version '
                      '${c.currentVersion} is now in force.',
                final c when c.isGranted =>
                  'Given on ${_date(c.grantedAt!)}, version '
                      '${c.grantedVersion}.',
                _ => 'Not given.',
              },
              style: theme.textTheme.bodySmall,
            ),

            // AF-01: an outdated consent does not carry over, and the screen
            // asks again rather than treating it as good enough.
            if (consent.isOutdated) ...[
              const SizedBox(height: 8),
              _Notice(
                key: Key('privacy.outdated.${consent.purpose}'),
                message:
                    'This needs a fresh decision. The old one no longer '
                    'applies.',
                isError: false,
              ),
            ],

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (consent.isGranted)
                  TextButton(
                    key: Key('privacy.withdraw.${consent.purpose}'),
                    onPressed: onWithdraw,
                    child: const Text('Withdraw'),
                  ),
                if (!consent.permits)
                  FilledButton(
                    key: Key('privacy.give.${consent.purpose}'),
                    onPressed: onGive,
                    child: Text(consent.isOutdated ? 'Review again' : 'Give'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _date(DateTime when) =>
      '${when.year}-${when.month.toString().padLeft(2, '0')}-'
      '${when.day.toString().padLeft(2, '0')}';
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message, required this.isError, super.key});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? scheme.errorContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError ? scheme.onErrorContainer : scheme.onSurface,
        ),
      ),
    );
  }
}

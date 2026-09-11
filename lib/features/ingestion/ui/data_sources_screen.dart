/// Data sources and connecting an institution (UC-30).
///
/// The order of steps 3 to 5 is the requirement, not a preference: consent is
/// obtained **before** a connection is initiated (`FR-IN-02`, `BR-40`).
/// Asking afterwards would be asking permission for a disclosure that had
/// already happened, which is not consent at all.
///
/// Unavailable sources are listed rather than hidden (`FR-IN-01`, `AF-06`).
/// A source silently missing leaves the user wondering whether their bank is
/// unsupported; a source shown with the instance's own reason tells them what
/// is actually true.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../privacy/data/consent_repository.dart';
import '../../privacy/state/consent_controller.dart';
import '../data/data_source_repository.dart';
import '../state/data_source_providers.dart';

class DataSourcesScreen extends ConsumerStatefulWidget {
  const DataSourcesScreen({super.key});

  @override
  ConsumerState<DataSourcesScreen> createState() => _DataSourcesScreenState();
}

class _DataSourcesScreenState extends ConsumerState<DataSourcesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(consentControllerProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final sources = ref.watch(dataSourcesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Data sources')),
      body: sources.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('sources.retry'),
                  onPressed: () => ref.invalidate(dataSourcesProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              key: Key('sources.empty'),
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'This instance supports no data sources.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) => _SourceTile(source: list[index]),
          );
        },
      ),
    );
  }
}

class _SourceTile extends ConsumerWidget {
  const _SourceTile({required this.source});

  final DataSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      key: Key('sources.item.${source.name}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  source.kind == SourceKind.file
                      ? Icons.description_outlined
                      : Icons.account_balance_outlined,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    source.displayName,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),

            // AF-06: listed, marked unavailable, and explained in the
            // instance's own words rather than this client's guess.
            if (!source.isAvailable) ...[
              const SizedBox(height: 8),
              Row(
                key: Key('sources.unavailable.${source.name}'),
                children: [
                  Icon(
                    Icons.block_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      source.unavailableReason ?? 'Not available in this mode.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ] else if (source.kind == SourceKind.network) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                key: Key('sources.connect.${source.name}'),
                icon: const Icon(Icons.link),
                label: const Text('Connect'),
                onPressed: () =>
                    unawaited(_startConnection(context, ref, source)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Steps 3 to 5, in that order.
  Future<void> _startConnection(
    BuildContext context,
    WidgetRef ref,
    DataSource source,
  ) async {
    // Step 3: is there a current consent for external processing?
    if (source.needsExternalConsent) {
      final controller = ref.read(consentControllerProvider.notifier);

      if (!controller.permits(externalProcessingPurpose)) {
        // Step 4, and AF-02: an outdated consent is presented as the new text
        // and asked again, because a decision about an older disclosure is
        // not a decision about this one.
        final agreed = await showDisclosure(
          context,
          ref,
          consent: _consentFor(ref),
        );

        if (!(agreed ?? false)) return; // AF-01: nothing is initiated.
      }
    }

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => _ConnectDialog(source: source),
    );
  }

  Consent? _consentFor(WidgetRef ref) =>
      switch (ref.read(consentControllerProvider)) {
        ConsentsReady(:final consents) => () {
          for (final consent in consents) {
            if (consent.purpose == externalProcessingPurpose) return consent;
          }
          return null;
        }(),
        _ => null,
      };
}

/// Step 4: the disclosure — what is shared, with whom, and why — and the
/// user's decision recorded against the version they were shown.
Future<bool?> showDisclosure(
  BuildContext context,
  WidgetRef ref, {
  required Consent? consent,
}) => showDialog<bool>(
  context: context,
  builder: (context) => _DisclosureDialog(consent: consent),
);

class _DisclosureDialog extends ConsumerStatefulWidget {
  const _DisclosureDialog({required this.consent});

  final Consent? consent;

  @override
  ConsumerState<_DisclosureDialog> createState() => _DisclosureDialogState();
}

class _DisclosureDialogState extends ConsumerState<_DisclosureDialog> {
  String? _error;
  var _busy = false;

  Future<void> _agree() async {
    final version = widget.consent?.currentVersion ?? '';

    if (version.isEmpty) {
      // A consent with no version is not consent to anything in particular.
      setState(() {
        _error =
            'This instance did not say which version of the disclosure it is '
            'asking about, so nothing was recorded.';
      });
      return;
    }

    setState(() {
      _error = null;
      _busy = true;
    });

    await ref
        .read(consentControllerProvider.notifier)
        .grant(purpose: externalProcessingPurpose, version: version);

    if (!mounted) return;

    // The controller is the authority on whether it took.
    final granted = ref
        .read(consentControllerProvider.notifier)
        .permits(externalProcessingPurpose);

    if (granted) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _busy = false;
        _error = 'The decision could not be recorded, so nothing was started.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final consent = widget.consent;
    final isOutdated = consent?.isOutdated ?? false;

    return AlertDialog(
      key: const Key('sources.disclosure'),
      title: Text(
        isOutdated ? 'The disclosure has changed' : 'Before connecting',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AF-02: said plainly, because agreeing again is otherwise
            // indistinguishable from being asked twice by mistake.
            if (isOutdated)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'You agreed to an earlier version of this. It has changed, '
                  'so the decision is being asked again.',
                  key: const Key('sources.disclosure.outdated'),
                  style: theme.textTheme.bodySmall,
                ),
              ),

            const Text(
              'Connecting an institution shares your financial data with an '
              'external service so it can be read on your behalf.',
            ),
            const SizedBox(height: 12),
            const Text('• What is shared: your account and transaction data.'),
            const Text(
              '• Who with: the aggregation service this instance is '
              'configured to use, reached by the instance and never by this '
              'application.',
            ),
            const Text(
              '• Why: so movements can be imported without being entered by '
              'hand.',
            ),
            const SizedBox(height: 12),
            const Text('You can withdraw this at any time from Privacy.'),

            if (consent?.currentVersion case final version?
                when version.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Version $version',
                key: const Key('sources.disclosure.version'),
                style: theme.textTheme.bodySmall,
              ),
            ],

            if (_error case final message?) ...[
              const SizedBox(height: 16),
              Text(
                message,
                key: const Key('sources.disclosure.error'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('sources.disclosure.decline'),
          // AF-01: declining initiates nothing and discloses nothing.
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Not now'),
        ),
        FilledButton(
          key: const Key('sources.disclosure.agree'),
          onPressed: _busy ? null : () => unawaited(_agree()),
          child: const Text('I agree'),
        ),
      ],
    );
  }
}

/// Step 5 and step 6.
class _ConnectDialog extends ConsumerStatefulWidget {
  const _ConnectDialog({required this.source});

  final DataSource source;

  @override
  ConsumerState<_ConnectDialog> createState() => _ConnectDialogState();
}

class _ConnectDialogState extends ConsumerState<_ConnectDialog> {
  final _reference = TextEditingController();

  ConnectOutcome? _outcome;
  var _busy = false;

  @override
  void dispose() {
    _reference.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final reference = _reference.text.trim();

    if (reference.isEmpty) {
      setState(
        () =>
            _outcome = const ConnectFailed('Name the institution to connect.'),
      );
      return;
    }

    setState(() {
      _outcome = null;
      _busy = true;
    });

    final outcome = await ref
        .read(connectActionsProvider)
        .connect(dataSource: widget.source.name, externalReference: reference);

    if (!mounted) return;

    setState(() {
      _outcome = outcome;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outcome = _outcome;

    // Step 6, and AF-07: both end the dialog with a connection to look at.
    if (outcome is Connected || outcome is AlreadyConnected) {
      final connection = outcome is Connected
          ? outcome.connection
          : (outcome! as AlreadyConnected).existing;

      return AlertDialog(
        key: const Key('sources.connected'),
        title: Text(
          outcome is AlreadyConnected ? 'Already connected' : 'Connected',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (outcome is AlreadyConnected)
              const Text(
                'This institution is already connected. Nothing new was '
                'created — here is the existing one.',
                key: Key('sources.alreadyConnected'),
              ),
            const SizedBox(height: 8),
            Text(
              connection.externalReference ?? 'Connected',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'State: ${connection.state.name}',
              key: const Key('sources.connected.state'),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          FilledButton(
            key: const Key('sources.connected.done'),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text('Connect ${widget.source.displayName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('sources.connect.reference'),
              controller: _reference,
              autofocus: true,
              enabled: !_busy,
              decoration: InputDecoration(
                labelText: 'Institution',
                helperText: widget.source.requiredInputs.isEmpty
                    ? 'As the instance identifies it.'
                    : 'Required: ${widget.source.requiredInputs.join(', ')}',
                border: const OutlineInputBorder(),
              ),
            ),

            if (outcome case final ConsentMissing missing) ...[
              const SizedBox(height: 16),
              // AF-03: the API named a consent, so the disclosure is offered
              // rather than a bare error the user cannot act on.
              Text(
                missing.reason,
                key: const Key('sources.consentMissing'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                key: const Key('sources.consentMissing.review'),
                onPressed: () async {
                  final agreed = await showDisclosure(
                    context,
                    ref,
                    consent: null,
                  );
                  if ((agreed ?? false) && mounted) await _connect();
                },
                child: const Text('Review the disclosure'),
              ),
            ],

            if (outcome case final ConnectFailed failed) ...[
              const SizedBox(height: 16),
              Text(
                failed.reason,
                key: const Key('sources.connectFailed'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
              // AF-05: retry where retrying could plausibly help.
              if (failed.isRetryable) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  key: const Key('sources.connectFailed.retry'),
                  onPressed: _busy ? null : () => unawaited(_connect()),
                  child: const Text('Try again'),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('sources.connect.cancel'),
          // AF-04: abandoning creates nothing, and says so by simply
          // returning the user to where they were.
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('sources.connect.submit'),
          onPressed: _busy ? null : () => unawaited(_connect()),
          child: _busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Connect'),
        ),
      ],
    );
  }
}

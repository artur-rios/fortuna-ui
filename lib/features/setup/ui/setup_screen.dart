/// The setup screen (UC-01, steps 4-7).
///
/// The first screen a user without a configured instance sees, and the only one
/// reachable before there is somewhere to send requests. It offers exactly the
/// paths this installation can actually take: an instance address always, and
/// desktop offline mode only where the core is present and loads (`AF-03`).
///
/// Nothing here navigates on success. Resolving the instance changes
/// `instanceConfigProvider`, the router listens to it, and the guard moves the
/// user on — one redirect, as `router.dart` requires.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/instance_config.dart';
import '../state/setup_controller.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _address = TextEditingController();

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref.read(setupControllerProvider.notifier).useAddress(_address.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(setupControllerProvider);
    final instance = ref.watch(instanceConfigProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set up your instance',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Fortuna keeps your data on the instance you name. '
                  'Enter its address to continue.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                TextField(
                  key: const Key('setup.address'),
                  controller: _address,
                  autofocus: true,
                  enabled: !state.isBusy,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Instance address',
                    hintText: 'https://fortuna.example',
                    border: const OutlineInputBorder(),
                    // AF-01 shows here rather than in a banner: the address is
                    // what is wrong, so the message belongs against the field.
                    errorText: state is SetupRejected ? state.reason : null,
                  ),
                  onChanged: (_) =>
                      ref.read(setupControllerProvider.notifier).reset(),
                  onSubmitted: (_) => state.isBusy ? null : _submit(),
                ),
                const SizedBox(height: 16),

                FilledButton(
                  key: const Key('setup.connect'),
                  onPressed: state.isBusy ? null : _submit,
                  child: state.isBusy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Connect'),
                ),

                if (state is SetupIncompatible) ...[
                  const SizedBox(height: 16),
                  _IncompatibleNotice(state: state),
                ],

                if (state is SetupUnreachable ||
                    state is SetupOfflineUnavailable) ...[
                  const SizedBox(height: 16),
                  _ProblemNotice(message: state.message ?? ''),
                ],

                // AF-03: offered only where it can work. On the web and on
                // Android there is nothing here at all, and on a desktop
                // installation without the core there is nothing either.
                if (instance.offlineAvailable) ...[
                  const SizedBox(height: 24),
                  const _OrDivider(),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    key: const Key('setup.offline'),
                    onPressed: state.isBusy
                        ? null
                        : ref
                              .read(setupControllerProvider.notifier)
                              .useOfflineMode,
                    icon: const Icon(Icons.cloud_off_outlined),
                    label: const Text('Use this device only'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your data stays on this computer. No instance, no network.',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],

                // AF-04: the installation meant to work offline and cannot, so
                // it says so — and the connected paths above remain on offer.
                if (instance.offlineFailed) ...[
                  const SizedBox(height: 24),
                  const _ProblemNotice(
                    message:
                        'This installation carries the Fortuna core but it '
                        'could not be loaded, so offline mode is unavailable. '
                        'Connect to an instance instead.',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `AF-05`. Names both contracts, because "incompatible" without the two
/// versions gives the user nothing to act on.
class _IncompatibleNotice extends StatelessWidget {
  const _IncompatibleNotice({required this.state});

  final SetupIncompatible state;

  @override
  Widget build(BuildContext context) {
    final service = state.service;
    final named = service != null && service.trim().isNotEmpty
        ? ' It calls itself "${service.trim()}".'
        : '';

    return _Notice(
      icon: Icons.error_outline,
      message:
          'That instance speaks contract ${state.compatibility.reportedOrUnknown}, '
          'and this application was built for ${state.compatibility.expected}. '
          'Update whichever is older before continuing.$named',
    );
  }
}

class _ProblemNotice extends StatelessWidget {
  const _ProblemNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) =>
      _Notice(icon: Icons.cloud_off_outlined, message: message);
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('or', style: Theme.of(context).textTheme.bodySmall),
      ),
      const Expanded(child: Divider()),
    ],
  );
}

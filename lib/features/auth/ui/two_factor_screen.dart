/// Managing two-factor authentication (UC-10).
///
/// `FR-SE-13` is the detail worth naming: the authenticator setup shows a
/// scannable code **and** the same secret as text. A user reading this on the
/// device their authenticator runs on cannot scan their own screen, and a user
/// with no camera cannot scan at all. The text is not a fallback for a broken
/// image — it is the path for everyone the image does not serve.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../data/two_factor_repository.dart';
import '../state/two_factor_controller.dart';

class TwoFactorScreen extends ConsumerStatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  ConsumerState<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends ConsumerState<TwoFactorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(twoFactorControllerProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(twoFactorControllerProvider);
    final controller = ref.read(twoFactorControllerProvider.notifier);

    return PopScope(
      // AF-06: the codes screen guards its exit, exactly as UC-06's does.
      canPop: state is! TwoFactorCodesIssued,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !mounted) return;

        final navigator = Navigator.of(context);
        final leave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave without keeping your codes?'),
            content: const Text(
              'These recovery codes will not be shown again. Without them, '
              'losing your second factor means losing access to the account.',
            ),
            actions: [
              TextButton(
                key: const Key('twoFactor.stay'),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Go back'),
              ),
              TextButton(
                key: const Key('twoFactor.leaveAnyway'),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave anyway'),
              ),
            ],
          ),
        );

        if (leave ?? false) navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Two-factor authentication')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: switch (state) {
                TwoFactorLoading() || TwoFactorWorking() => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                TwoFactorUnavailable(:final reason) => _Notice(
                  key: const Key('twoFactor.unavailable'),
                  message: reason,
                ),
                TwoFactorPending(:final setup, :final reason) => _PendingSetup(
                  setup: setup,
                  reason: reason,
                  onConfirm: (app, email) => unawaited(
                    controller.confirm(appCode: app, emailCode: email),
                  ),
                  onAbandon: () => unawaited(controller.abandonSetup()),
                ),
                TwoFactorCodesIssued(:final codes) => _RecoveryCodes(
                  codes: codes,
                  onConfirmed: () => unawaited(controller.confirmCodesKept()),
                ),
                TwoFactorIdle(:final status) => _Configuration(
                  status: status,
                  onEnable: (methods) => unawaited(controller.enable(methods)),
                  onDisable: (password, code) => unawaited(
                    controller.disable(password: password, code: code),
                  ),
                  onRegenerate: (code) =>
                      unawaited(controller.regenerateCodes(code: code)),
                ),
                TwoFactorFailed(:final reason, :final status) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Notice(message: reason),
                    const SizedBox(height: 16),
                    if (status != null)
                      _Configuration(
                        status: status,
                        onEnable: (methods) =>
                            unawaited(controller.enable(methods)),
                        onDisable: (password, code) => unawaited(
                          controller.disable(password: password, code: code),
                        ),
                        onRegenerate: (code) =>
                            unawaited(controller.regenerateCodes(code: code)),
                      )
                    else
                      FilledButton(
                        key: const Key('twoFactor.retry'),
                        onPressed: () => unawaited(controller.load()),
                        child: const Text('Try again'),
                      ),
                  ],
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Step 1, and the entry points for steps 2 and 6.
class _Configuration extends StatefulWidget {
  const _Configuration({
    required this.status,
    required this.onEnable,
    required this.onDisable,
    required this.onRegenerate,
  });

  final TwoFactorStatus status;
  final void Function(List<TwoFactorMethod>) onEnable;
  final void Function(String password, String code) onDisable;
  final void Function(String code) onRegenerate;

  @override
  State<_Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<_Configuration> {
  final _chosen = <TwoFactorMethod>{TwoFactorMethod.app};
  final _password = TextEditingController();
  final _code = TextEditingController();

  @override
  void dispose() {
    _password.clear();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step 1: what is on, and by which method.
        Text(
          key: const Key('twoFactor.status'),
          status.isActive
              ? 'Two-factor authentication is on, using '
                    '${status.methods.map((m) => m.label.toLowerCase()).join(' and ')}.'
              : 'Two-factor authentication is off.',
          style: theme.textTheme.bodyLarge,
        ),
        if (status.isActive) ...[
          const SizedBox(height: 4),
          Text(
            '${status.remainingRecoveryCodes} recovery '
            '${status.remainingRecoveryCodes == 1 ? 'code' : 'codes'} left.',
            style: theme.textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 24),

        if (!status.isActive) ...[
          Text('Turn it on with', style: theme.textTheme.titleSmall),
          for (final method in TwoFactorMethod.values)
            CheckboxListTile(
              key: Key('twoFactor.method.${method.wireName}'),
              value: _chosen.contains(method),
              onChanged: (on) => setState(() {
                (on ?? false) ? _chosen.add(method) : _chosen.remove(method);
              }),
              title: Text(method.label),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          const SizedBox(height: 8),
          FilledButton(
            key: const Key('twoFactor.enable'),
            onPressed: () => widget.onEnable(_chosen.toList()),
            child: const Text('Set up two-factor authentication'),
          ),
        ] else ...[
          // Step 6. Both operations need proof, which is the point of them.
          TextField(
            key: const Key('twoFactor.password'),
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Your password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('twoFactor.code'),
            controller: _code,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'A current second-factor code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            key: const Key('twoFactor.regenerate'),
            onPressed: () => widget.onRegenerate(_code.text),
            child: const Text('Replace my recovery codes'),
          ),
          const SizedBox(height: 8),
          TextButton(
            key: const Key('twoFactor.disable'),
            onPressed: () => widget.onDisable(_password.text, _code.text),
            child: const Text('Turn two-factor authentication off'),
          ),
        ],
      ],
    );
  }
}

/// Steps 3-4.
class _PendingSetup extends StatefulWidget {
  const _PendingSetup({
    required this.setup,
    required this.reason,
    required this.onConfirm,
    required this.onAbandon,
  });

  final TwoFactorSetup setup;
  final String? reason;
  final void Function(String appCode, String emailCode) onConfirm;
  final VoidCallback onAbandon;

  @override
  State<_PendingSetup> createState() => _PendingSetupState();
}

class _PendingSetupState extends State<_PendingSetup> {
  final _appCode = TextEditingController();
  final _emailCode = TextEditingController();

  @override
  void dispose() {
    _appCode.dispose();
    _emailCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setup = widget.setup;
    final theme = Theme.of(context);
    final secret = setup.sharedSecret;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (setup.otpAuthUri case final uri?) ...[
          Text('Scan this', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Center(
            child: QrImageView(
              key: const Key('twoFactor.qr'),
              data: uri,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // FR-SE-13. Not a fallback — the path for everyone the image does
          // not serve, which includes anyone reading this on the same device
          // their authenticator runs on.
          if (secret != null) ...[
            Text(
              'Or enter this secret by hand',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    key: const Key('twoFactor.secret'),
                    secret,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('twoFactor.copySecret'),
                  tooltip: 'Copy the secret',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: secret));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to the clipboard.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_outlined),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            key: const Key('twoFactor.appCode'),
            controller: _appCode,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Code from your authenticator',
              border: OutlineInputBorder(),
            ),
          ),
        ],

        if (setup.emailCodeSent) ...[
          const SizedBox(height: 12),
          TextField(
            key: const Key('twoFactor.emailCode'),
            controller: _emailCode,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Code from your email',
              border: OutlineInputBorder(),
            ),
          ),
        ],

        if (widget.reason case final reason?) ...[
          const SizedBox(height: 16),
          // AF-01: still pending, and the user may try again.
          _Notice(key: const Key('twoFactor.pendingReason'), message: reason),
        ],

        const SizedBox(height: 16),
        FilledButton(
          key: const Key('twoFactor.confirm'),
          onPressed: () => widget.onConfirm(_appCode.text, _emailCode.text),
          child: const Text('Confirm'),
        ),
        const SizedBox(height: 8),
        TextButton(
          key: const Key('twoFactor.abandon'),
          // AF-02: nothing to undo. Two-factor was never recorded as on.
          onPressed: widget.onAbandon,
          child: const Text('Cancel this setup'),
        ),
      ],
    );
  }
}

class _RecoveryCodes extends StatefulWidget {
  const _RecoveryCodes({required this.codes, required this.onConfirmed});

  final List<String> codes;
  final VoidCallback onConfirmed;

  @override
  State<_RecoveryCodes> createState() => _RecoveryCodesState();
}

class _RecoveryCodesState extends State<_RecoveryCodes> {
  var _kept = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Keep these recovery codes', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'They are shown once and cannot be retrieved again. They are how '
          'you get in if you lose your second factor.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Container(
          key: const Key('twoFactor.codes'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            widget.codes.join('\n'),
            style: const TextStyle(fontFamily: 'monospace', height: 1.6),
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          key: const Key('twoFactor.kept'),
          value: _kept,
          onChanged: (value) => setState(() => _kept = value ?? false),
          title: const Text('I have saved these codes somewhere safe'),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const Key('twoFactor.done'),
          onPressed: _kept ? widget.onConfirmed : null,
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message, super.key});

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
          Icon(Icons.error_outline, size: 20, color: scheme.onErrorContainer),
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

/// Recovering a desktop local account (UC-08).
///
/// The screen follows the state machine: the form, then what recovery cost,
/// then the offer to re-key, then the new codes if the user took it.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/local_recovery_controller.dart';

class LocalRecoveryScreen extends ConsumerStatefulWidget {
  const LocalRecoveryScreen({this.onFinished, super.key});

  final VoidCallback? onFinished;

  @override
  ConsumerState<LocalRecoveryScreen> createState() =>
      _LocalRecoveryScreenState();
}

class _LocalRecoveryScreenState extends ConsumerState<LocalRecoveryScreen> {
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _secret = TextEditingController();

  @override
  void dispose() {
    _code.clear();
    _secret.clear();
    _name.dispose();
    _code.dispose();
    _secret.dispose();
    super.dispose();
  }

  void _recover() {
    unawaited(
      ref
          .read(localRecoveryControllerProvider.notifier)
          .recover(
            name: _name.text,
            recoveryCode: _code.text,
            newSecret: _secret.text,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localRecoveryControllerProvider);
    final controller = ref.read(localRecoveryControllerProvider.notifier);

    ref.listen(localRecoveryControllerProvider, (_, next) {
      if (next is LocalRecoveryFinished) widget.onFinished?.call();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Recover your account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: switch (state) {
              LocalRecoveryRecovered(:final remaining) => _SpentAndOffer(
                remaining: remaining,
                onRegenerate: () => unawaited(controller.regenerateCodes()),
                onDecline: controller.declineRegeneration,
              ),
              LocalRecoveryRegenerationFailed(
                :final reason,
                :final remaining,
              ) =>
                _RegenerationFailed(
                  reason: reason,
                  remaining: remaining,
                  onRetry: () => unawaited(controller.regenerateCodes()),
                  onDone: controller.declineRegeneration,
                ),
              LocalRecoveryCodesIssued(:final account) => _NewCodes(
                codes: account.recoveryCodes,
                warning: account.warning,
                onConfirmed: controller.confirmCodesKept,
              ),
              _ => _Form(
                name: _name,
                code: _code,
                secret: _secret,
                state: state,
                onSubmit: _recover,
                onChanged: controller.reset,
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    required this.name,
    required this.code,
    required this.secret,
    required this.state,
    required this.onSubmit,
    required this.onChanged,
  });

  final TextEditingController name;
  final TextEditingController code;
  final TextEditingController secret;
  final LocalRecoveryState state;
  final VoidCallback onSubmit;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Use one of the recovery codes you saved when this account was '
        'created. It will be used up.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 24),
      TextField(
        key: const Key('recovery.name'),
        controller: name,
        autofocus: true,
        enabled: !state.isBusy,
        decoration: const InputDecoration(
          labelText: 'Account name',
          border: OutlineInputBorder(),
        ),
        onChanged: (_) => onChanged(),
      ),
      const SizedBox(height: 12),
      TextField(
        key: const Key('recovery.code'),
        controller: code,
        enabled: !state.isBusy,
        autocorrect: false,
        decoration: const InputDecoration(
          labelText: 'Recovery code',
          border: OutlineInputBorder(),
        ),
        onChanged: (_) => onChanged(),
      ),
      const SizedBox(height: 12),
      TextField(
        key: const Key('recovery.secret'),
        controller: secret,
        enabled: !state.isBusy,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'New secret',
          border: OutlineInputBorder(),
        ),
        onChanged: (_) => onChanged(),
        onSubmitted: (_) => state.isBusy ? null : onSubmit(),
      ),
      const SizedBox(height: 16),
      FilledButton(
        key: const Key('recovery.submit'),
        onPressed: state.isBusy ? null : onSubmit,
        child: state.isBusy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Recover account'),
      ),
      if (state.message case final message?) ...[
        const SizedBox(height: 16),
        _Notice(message: message),
      ],
    ],
  );
}

/// Step 4 and step 6 together: what the recovery cost, and the offer to re-key.
class _SpentAndOffer extends StatelessWidget {
  const _SpentAndOffer({
    required this.remaining,
    required this.onRegenerate,
    required this.onDecline,
  });

  final int remaining;
  final VoidCallback onRegenerate;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('You are back in', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          key: const Key('recovery.spent'),
          // Step 4, said plainly. The count is the part that matters: it is
          // how a user knows whether they are one bad day from being locked
          // out for good.
          remaining == 0
              ? 'That code is now used up, and it was your last one. If you '
                    'forget this secret there is no way back into this '
                    'account.'
              : 'That code is now used up. You have $remaining '
                    '${remaining == 1 ? 'code' : 'codes'} left.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('recovery.regenerate'),
          onPressed: onRegenerate,
          child: const Text('Issue a new set of codes'),
        ),
        const SizedBox(height: 8),
        TextButton(
          key: const Key('recovery.decline'),
          onPressed: onDecline,
          child: const Text('Keep the codes I have'),
        ),
      ],
    );
  }
}

/// `AF-05`. The point of this screen is the second sentence.
class _RegenerationFailed extends StatelessWidget {
  const _RegenerationFailed({
    required this.reason,
    required this.remaining,
    required this.onRetry,
    required this.onDone,
  });

  final String reason;
  final int remaining;
  final VoidCallback onRetry;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      _Notice(message: reason),
      const SizedBox(height: 16),
      Text(
        key: const Key('recovery.oldCodesStand'),
        remaining == 0
            ? 'Nothing changed. You still have no unused codes.'
            : 'Nothing changed — your existing $remaining '
                  '${remaining == 1 ? 'code is' : 'codes are'} still valid.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 24),
      FilledButton(
        key: const Key('recovery.retryRegenerate'),
        onPressed: onRetry,
        child: const Text('Try again'),
      ),
      const SizedBox(height: 8),
      TextButton(
        key: const Key('recovery.finish'),
        onPressed: onDone,
        child: const Text('Continue without new codes'),
      ),
    ],
  );
}

class _NewCodes extends StatefulWidget {
  const _NewCodes({
    required this.codes,
    required this.warning,
    required this.onConfirmed,
  });

  final List<String> codes;
  final String? warning;
  final VoidCallback onConfirmed;

  @override
  State<_NewCodes> createState() => _NewCodesState();
}

class _NewCodesState extends State<_NewCodes> {
  var _kept = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Your new recovery codes', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          widget.warning ??
              'These replace every code you had before. They are shown once '
                  'and cannot be retrieved again.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Container(
          key: const Key('recovery.newCodes'),
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
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const Key('recovery.copy'),
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: widget.codes.join('\n')),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to the clipboard.')),
              );
            }
          },
          icon: const Icon(Icons.copy_outlined),
          label: const Text('Copy'),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          key: const Key('recovery.kept'),
          value: _kept,
          onChanged: (value) => setState(() => _kept = value ?? false),
          title: const Text('I have saved these codes somewhere safe'),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const Key('recovery.done'),
          onPressed: _kept ? widget.onConfirmed : null,
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message});

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

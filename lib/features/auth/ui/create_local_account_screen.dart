/// Creating the desktop local account (UC-06).
///
/// Two halves: a form, and then the recovery codes. The second half is the
/// point of the screen — the codes are shown once, and once the user leaves
/// them there is no way to see them again.
///
/// `AF-04` is why leaving is intercepted rather than merely discouraged. A user
/// who closes this screen without keeping the codes has locked themselves out
/// of an account they created ten seconds ago, and the only honest place to say
/// so is on the way out.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_account_repository.dart';
import '../state/local_account_controller.dart';

class CreateLocalAccountScreen extends ConsumerStatefulWidget {
  const CreateLocalAccountScreen({this.onFinished, super.key});

  /// Called once the codes have been confirmed. Sign-in follows (`UC-07`).
  final VoidCallback? onFinished;

  @override
  ConsumerState<CreateLocalAccountScreen> createState() =>
      _CreateLocalAccountScreenState();
}

class _CreateLocalAccountScreenState
    extends ConsumerState<CreateLocalAccountScreen> {
  final _name = TextEditingController();
  final _secret = TextEditingController();

  @override
  void dispose() {
    _secret.clear();
    _name.dispose();
    _secret.dispose();
    super.dispose();
  }

  void _create() {
    unawaited(
      ref
          .read(localAccountControllerProvider.notifier)
          .create(displayName: _name.text, secret: _secret.text),
    );
  }

  /// `AF-04`. Returns whether leaving is allowed.
  Future<bool> _confirmLeaving() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave without keeping your codes?'),
        content: const Text(
          'Your recovery codes will not be shown again. Without them, a '
          'forgotten secret means losing this account and everything in it.',
        ),
        actions: [
          TextButton(
            key: const Key('localAccount.stay'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Go back'),
          ),
          TextButton(
            key: const Key('localAccount.leaveAnyway'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave anyway'),
          ),
        ],
      ),
    );

    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localAccountControllerProvider);

    ref.listen(localAccountControllerProvider, (_, next) {
      if (next is LocalAccountConfirmed) widget.onFinished?.call();
    });

    return PopScope(
      // Only the codes screen guards the exit; the form has nothing to lose.
      canPop: state is! LocalAccountCodesShown,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !mounted) return;

        // The navigator is captured before the await: after it, `context` is
        // an async gap the analyzer rightly refuses to let us reach through.
        final navigator = Navigator.of(context);
        if (await _confirmLeaving()) navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Create a local account')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: switch (state) {
                LocalAccountCodesShown(:final account) => _RecoveryCodes(
                  account: account,
                  onConfirmed: ref
                      .read(localAccountControllerProvider.notifier)
                      .confirmCodesKept,
                ),
                _ => _Form(
                  name: _name,
                  secret: _secret,
                  state: state,
                  onSubmit: _create,
                  onChanged: ref
                      .read(localAccountControllerProvider.notifier)
                      .reset,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    required this.name,
    required this.secret,
    required this.state,
    required this.onSubmit,
    required this.onChanged,
  });

  final TextEditingController name;
  final TextEditingController secret;
  final LocalAccountState state;
  final VoidCallback onSubmit;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    // AF-05 and the wrong-mode case: creation is not offered, and the reason
    // is stated rather than left as a disabled button.
    if (state is LocalAccountUnavailable) {
      return _Notice(message: state.message!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'This account exists only on this computer. Nothing is sent '
          'anywhere.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          key: const Key('localAccount.name'),
          controller: name,
          autofocus: true,
          enabled: !state.isBusy,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('localAccount.secret'),
          controller: secret,
          enabled: !state.isBusy,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Secret',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => onChanged(),
          onSubmitted: (_) => state.isBusy ? null : onSubmit(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('localAccount.create'),
          onPressed: state.isBusy ? null : onSubmit,
          child: state.isBusy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create account'),
        ),
        if (state.message case final message?) ...[
          const SizedBox(height: 16),
          _Notice(message: message),
        ],
      ],
    );
  }
}

/// Main-flow step 5. Says plainly what these are and what losing them costs.
class _RecoveryCodes extends StatefulWidget {
  const _RecoveryCodes({required this.account, required this.onConfirmed});

  final CreatedLocalAccount account;
  final VoidCallback onConfirmed;

  @override
  State<_RecoveryCodes> createState() => _RecoveryCodesState();
}

class _RecoveryCodesState extends State<_RecoveryCodes> {
  var _kept = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final codes = widget.account.recoveryCodes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Keep these recovery codes', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          // The core's own warning where it sent one; otherwise this client's,
          // which says the same thing in the same plain terms.
          widget.account.warning ??
              'These are shown once and cannot be retrieved again. If you '
                  'forget your secret and have lost every one of these codes, '
                  'this account and everything in it is gone.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Container(
          key: const Key('localAccount.codes'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            codes.join('\n'),
            style: const TextStyle(fontFamily: 'monospace', height: 1.6),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const Key('localAccount.copy'),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: codes.join('\n')));
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
          key: const Key('localAccount.kept'),
          value: _kept,
          onChanged: (value) => setState(() => _kept = value ?? false),
          title: const Text('I have saved these codes somewhere safe'),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const Key('localAccount.continue'),
          // Deliberately gated on the checkbox: the confirmation is the whole
          // of step 6, and a button that proceeds regardless would make it
          // decoration.
          onPressed: _kept ? widget.onConfirmed : null,
          child: const Text('Continue to sign in'),
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

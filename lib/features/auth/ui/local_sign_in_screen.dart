/// Signing in to the desktop local account (UC-07).
///
/// Offers exactly one path, because offline there is exactly one: no Heimdall,
/// no Google, and no password reset. What it does offer in place of a reset is
/// the truth about why there isn't one.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/local_sign_in_controller.dart';

class LocalSignInScreen extends ConsumerStatefulWidget {
  const LocalSignInScreen({
    this.onRecover,
    this.onCreateAccount,
    this.accountExists = true,
    super.key,
  });

  /// Recovery by code (`UC-08`), offered in place of a password reset.
  final VoidCallback? onRecover;

  /// `AF-04`: creation (`UC-06`), offered where no local account exists.
  final VoidCallback? onCreateAccount;

  /// Whether this installation has a local account to sign in to.
  final bool accountExists;

  @override
  ConsumerState<LocalSignInScreen> createState() => _LocalSignInScreenState();
}

class _LocalSignInScreenState extends ConsumerState<LocalSignInScreen> {
  final _name = TextEditingController();
  final _secret = TextEditingController();

  @override
  void dispose() {
    _secret.clear();
    _name.dispose();
    _secret.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref
          .read(localSignInControllerProvider.notifier)
          .submit(name: _name.text, secret: _secret.text),
    );
  }

  /// `AF-03`, `FR-SE-09`. Explains rather than fails.
  Future<void> _explainNoReset() async {
    final recover = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('There is no password reset here'),
        content: const Text(
          'Resetting a password means proving who you are through some other '
          'channel — an email, usually. This account exists only on this '
          'computer and there is no such channel, so there is nothing to '
          'reset through.\n\n'
          'Your recovery codes are that proof instead.',
        ),
        actions: [
          TextButton(
            key: const Key('localSignIn.resetClose'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Close'),
          ),
          FilledButton(
            key: const Key('localSignIn.resetRecover'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Use a recovery code'),
          ),
        ],
      ),
    );

    if (recover ?? false) widget.onRecover?.call();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localSignInControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sign in',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'This installation works offline. Your data never leaves '
                  'this computer.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // AF-04: nothing to sign in to, so creation is what is offered.
                if (!widget.accountExists) ...[
                  const _Notice(
                    message:
                        'This installation has no local account yet. Create '
                        'one to begin.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('localSignIn.create'),
                    onPressed: widget.onCreateAccount,
                    child: const Text('Create a local account'),
                  ),
                ] else ...[
                  TextField(
                    key: const Key('localSignIn.name'),
                    controller: _name,
                    autofocus: true,
                    enabled: !state.isBusy,
                    decoration: const InputDecoration(
                      labelText: 'Account name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => ref
                        .read(localSignInControllerProvider.notifier)
                        .reset(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('localSignIn.secret'),
                    controller: _secret,
                    enabled: !state.isBusy,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Secret',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => ref
                        .read(localSignInControllerProvider.notifier)
                        .reset(),
                    onSubmitted: (_) => state.isBusy ? null : _submit(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('localSignIn.submit'),
                    onPressed: state.isBusy ? null : _submit,
                    child: state.isBusy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign in'),
                  ),

                  if (state.message case final message?) ...[
                    const SizedBox(height: 16),
                    _Notice(message: message),
                  ],

                  const SizedBox(height: 8),
                  TextButton(
                    key: const Key('localSignIn.forgot'),
                    onPressed: () => unawaited(_explainNoReset()),
                    child: const Text('Forgotten your secret?'),
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
          Icon(Icons.info_outline, size: 20, color: scheme.onErrorContainer),
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

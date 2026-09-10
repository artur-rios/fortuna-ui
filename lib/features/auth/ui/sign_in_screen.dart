/// The sign-in screen (UC-03).
///
/// Nothing here navigates on success. Granting a session changes
/// `sessionProvider`, the router listens to it, and the guard routes the user to
/// the screen their role admits — which is main-flow step 6, done in the one
/// place that decides such things.
///
/// The credential fields are cleared when the screen goes away (`AF-05`), and
/// the password is never kept anywhere else: a failed attempt is retyped rather
/// than replayed.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../data/google_identity.dart';
import '../state/sign_in_controller.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _obscured = true;

  @override
  void dispose() {
    // AF-05. `clear()` before `dispose()` so the text is not left in the
    // controller's buffer for as long as it takes to be collected.
    _email.clear();
    _password.clear();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref
          .read(signInControllerProvider.notifier)
          .submit(email: _email.text, password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    // AF-04: null where this instance has no Google client configured, and the
    // option is then not offered at all rather than offered and broken.
    final googleAvailable = ref.watch(googleIdentityServiceProvider) != null;
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
                const SizedBox(height: 24),

                TextField(
                  key: const Key('signIn.email'),
                  controller: _email,
                  autofocus: true,
                  enabled: !state.isBusy,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) =>
                      ref.read(signInControllerProvider.notifier).reset(),
                ),
                const SizedBox(height: 12),

                TextField(
                  key: const Key('signIn.password'),
                  controller: _password,
                  enabled: !state.isBusy,
                  obscureText: _obscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      key: const Key('signIn.reveal'),
                      onPressed: () => setState(() => _obscured = !_obscured),
                      icon: Icon(
                        _obscured
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      tooltip: _obscured ? 'Show password' : 'Hide password',
                    ),
                  ),
                  onChanged: (_) =>
                      ref.read(signInControllerProvider.notifier).reset(),
                  onSubmitted: (_) => state.isBusy ? null : _submit(),
                ),
                const SizedBox(height: 16),

                FilledButton(
                  key: const Key('signIn.submit'),
                  onPressed: state.isBusy ? null : _submit,
                  child: state.isBusy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign in'),
                ),

                if (googleAvailable) ...[
                  const SizedBox(height: 16),
                  const _OrDivider(),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    key: const Key('signIn.google'),
                    onPressed: state.isBusy
                        ? null
                        : ref
                              .read(signInControllerProvider.notifier)
                              .signInWithGoogle,
                    icon: const Icon(Icons.account_circle_outlined),
                    label: const Text('Continue with Google'),
                  ),
                ],

                if (state.message case final message?) ...[
                  const SizedBox(height: 16),
                  _Notice(
                    message: message,
                    // AF-04 is the only one a retry can help; offering one for a
                    // refused password would just invite the same refusal.
                    onRetry: state is SignInUnreachable ? _submit : null,
                  ),
                ],

                // AF-06. Offered alongside the API's reason, not instead of it.
                if (state is SignInNeedsVerification) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    key: const Key('signIn.verify'),
                    onPressed: () => context.push(Routes.verifyEmail),
                    child: const Text('Resend the verification email'),
                  ),
                ],

                const SizedBox(height: 8),
                TextButton(
                  key: const Key('signIn.recover'),
                  onPressed: () => context.push(Routes.passwordRecovery),
                  child: const Text('Forgotten your password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                size: 20,
                color: scheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ),
            ],
          ),
          if (onRetry != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('signIn.retry'),
                onPressed: onRetry,
                child: const Text('Try again'),
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

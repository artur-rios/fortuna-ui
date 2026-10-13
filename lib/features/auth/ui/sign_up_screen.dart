/// The sign-up screen (UC-47).
///
/// Two ways in. Google is the existing UC-05 exchange, untouched: a first
/// Google sign-in creates the account, grants a session, and the guard routes
/// onward as it does from sign-in. The credential form asks the instance to
/// create an account and then says what the instance said — which is the same
/// whether the address was free or already taken, so the next step is always
/// the same too: check the inbox, then sign in.
///
/// The fields are cleared when the screen goes away, and the password is never
/// kept anywhere else.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/google_identity.dart';
import '../state/sign_in_controller.dart';
import '../state/sign_up_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({this.onSignIn, super.key});

  /// Back to sign-in, once the account is requested or if the user has one.
  final VoidCallback? onSignIn;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _obscured = true;

  @override
  void dispose() {
    _name.clear();
    _email.clear();
    _password.clear();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref
          .read(signUpControllerProvider.notifier)
          .submit(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          ),
    );
  }

  void _reset(String _) => ref.read(signUpControllerProvider.notifier).reset();

  String? _errorFor(SignUpState state, SignUpField field) =>
      state is SignUpInvalid && state.field == field ? state.reason : null;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    final google = ref.watch(signInControllerProvider);
    final googleAvailable = ref.watch(googleIdentityServiceProvider) != null;
    final busy = state.isBusy || google.isBusy;
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
                  'Create an account',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                if (state case SignUpAccepted(:final message)) ...[
                  _Panel(message: message, isError: false),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('signUp.done'),
                    onPressed: widget.onSignIn,
                    child: const Text('Back to sign in'),
                  ),
                ] else ...[
                  TextField(
                    key: const Key('signUp.name'),
                    controller: _name,
                    autofocus: true,
                    enabled: !busy,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: const OutlineInputBorder(),
                      errorText: _errorFor(state, SignUpField.name),
                    ),
                    onChanged: _reset,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('signUp.email'),
                    controller: _email,
                    enabled: !busy,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      border: const OutlineInputBorder(),
                      errorText: _errorFor(state, SignUpField.email),
                    ),
                    onChanged: _reset,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('signUp.password'),
                    controller: _password,
                    enabled: !busy,
                    obscureText: _obscured,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'At least 8 characters.',
                      border: const OutlineInputBorder(),
                      errorText: _errorFor(state, SignUpField.password),
                      suffixIcon: IconButton(
                        key: const Key('signUp.reveal'),
                        onPressed: () => setState(() => _obscured = !_obscured),
                        icon: Icon(
                          _obscured
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        tooltip: _obscured ? 'Show password' : 'Hide password',
                      ),
                    ),
                    onChanged: _reset,
                    onSubmitted: (_) => busy ? null : _submit(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('signUp.submit'),
                    onPressed: busy ? null : _submit,
                    child: state.isBusy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create account'),
                  ),

                  if (googleAvailable) ...[
                    const SizedBox(height: 16),
                    const _OrDivider(),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      key: const Key('signUp.google'),
                      onPressed: busy
                          ? null
                          : ref
                                .read(signInControllerProvider.notifier)
                                .signInWithGoogle,
                      icon: const Icon(Icons.account_circle_outlined),
                      label: const Text('Continue with Google'),
                    ),
                  ],

                  if (state case SignUpRefused(:final reason)) ...[
                    const SizedBox(height: 16),
                    _Panel(message: reason, isError: true),
                  ],
                  if (state case SignUpUnreachable(:final reason)) ...[
                    const SizedBox(height: 16),
                    _Panel(message: reason, isError: true, onRetry: _submit),
                  ],
                  if (google.message case final message?) ...[
                    const SizedBox(height: 16),
                    _Panel(message: message, isError: true),
                  ],

                  const SizedBox(height: 8),
                  TextButton(
                    key: const Key('signUp.signIn'),
                    onPressed: widget.onSignIn,
                    child: const Text('Already have an account? Sign in'),
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

class _Panel extends StatelessWidget {
  const _Panel({required this.message, required this.isError, this.onRetry});

  final String message;
  final bool isError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = isError
        ? scheme.errorContainer
        : scheme.secondaryContainer;
    final foreground = isError
        ? scheme.onErrorContainer
        : scheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.mark_email_read_outlined,
                size: 20,
                color: foreground,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message, style: TextStyle(color: foreground)),
              ),
            ],
          ),
          if (onRetry != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('signUp.retry'),
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

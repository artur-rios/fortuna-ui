/// Password recovery and address verification (UC-09).
///
/// Three screens sharing one controller, because they are three shapes of the
/// same conversation: ask for a message, act on the token it carried, report
/// what the API said.
///
/// The reset and verification screens take their token from the link that
/// opened them, which is why they accept it as a parameter rather than asking
/// the user to type something they did not choose.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/account_recovery_controller.dart';

/// Steps 1-3: ask for a reset message.
class PasswordRecoveryScreen extends ConsumerStatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  ConsumerState<PasswordRecoveryScreen> createState() =>
      _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState
    extends ConsumerState<PasswordRecoveryScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref
          .read(accountRecoveryControllerProvider.notifier)
          .requestPasswordRecovery(_email.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountRecoveryControllerProvider);

    return _Frame(
      title: 'Recover your password',
      children: [
        Text(
          'Enter the address for your account and we will send a reset link.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          key: const Key('recovery.email'),
          controller: _email,
          autofocus: true,
          enabled: !state.isBusy,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Email address',
            border: const OutlineInputBorder(),
            errorText: state is RecoveryInvalid ? state.reason : null,
          ),
          onChanged: (_) =>
              ref.read(accountRecoveryControllerProvider.notifier).reset(),
          onSubmitted: (_) => state.isBusy ? null : _submit(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('recovery.request'),
          onPressed: state.isBusy ? null : _submit,
          child: state.isBusy
              ? const _Spinner()
              : const Text('Send a reset link'),
        ),
        // AF-02: whatever the API said, unread and unmodified. It says the same
        // thing whether or not the address belongs to anybody.
        if (state is RecoveryDone) ...[
          const SizedBox(height: 16),
          _Notice(
            key: const Key('recovery.sent'),
            message: state.confirmation,
            tone: _Tone.neutral,
          ),
        ],
        if (state is RecoveryRateLimited) ...[
          const SizedBox(height: 16),
          _Notice(message: state.reason, tone: _Tone.neutral),
        ],
        if (state is RecoveryRefused) ...[
          const SizedBox(height: 16),
          _Notice(message: state.reason, tone: _Tone.error),
        ],
      ],
    );
  }
}

/// Steps 4-6: set a new password with the token the link carried.
class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({required this.token, this.onDone, super.key});

  /// From the reset link. Empty means the link was incomplete.
  final String token;

  /// Called once the reset succeeded; sign-in follows.
  final VoidCallback? onDone;

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _password.clear();
    _confirmation.clear();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref
          .read(accountRecoveryControllerProvider.notifier)
          .resetPassword(
            token: widget.token,
            newPassword: _password.text,
            confirmation: _confirmation.text,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountRecoveryControllerProvider);

    ref.listen(accountRecoveryControllerProvider, (_, next) {
      if (next is RecoveryDone) widget.onDone?.call();
    });

    return _Frame(
      title: 'Choose a new password',
      children: [
        TextField(
          key: const Key('reset.password'),
          controller: _password,
          autofocus: true,
          enabled: !state.isBusy,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New password',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) =>
              ref.read(accountRecoveryControllerProvider.notifier).reset(),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('reset.confirmation'),
          controller: _confirmation,
          enabled: !state.isBusy,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm it',
            border: const OutlineInputBorder(),
            errorText: state is RecoveryInvalid ? state.reason : null,
          ),
          onChanged: (_) =>
              ref.read(accountRecoveryControllerProvider.notifier).reset(),
          onSubmitted: (_) => state.isBusy ? null : _submit(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('reset.submit'),
          onPressed: state.isBusy ? null : _submit,
          child: state.isBusy ? const _Spinner() : const Text('Reset password'),
        ),
        if (state is RecoveryRefused) ...[
          const SizedBox(height: 16),
          // AF-05: whatever rule the client did not enforce, in the API's
          // words.
          _Notice(message: state.reason, tone: _Tone.error),
          // AF-03: a dead token can be replaced. A refused password cannot be
          // fixed by another link, so nothing is offered for that.
          if (state.canRequestAnother) ...[
            const SizedBox(height: 8),
            TextButton(
              key: const Key('reset.requestAnother'),
              onPressed: () =>
                  ref.read(accountRecoveryControllerProvider.notifier).reset(),
              child: const Text('Request a new link'),
            ),
          ],
        ],
        if (state is RecoveryDone) ...[
          const SizedBox(height: 16),
          _Notice(message: state.confirmation, tone: _Tone.neutral),
        ],
      ],
    );
  }
}

/// Step 7: verify an address, and ask for the message again.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({this.token = '', super.key});

  /// From the verification link. Empty means the screen was reached directly,
  /// in which case the only thing on offer is asking for a new message.
  final String token;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.token.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          ref
              .read(accountRecoveryControllerProvider.notifier)
              .verifyEmail(widget.token),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountRecoveryControllerProvider);

    return _Frame(
      title: 'Verify your email address',
      children: [
        if (state.isBusy) const Center(child: _Spinner()),

        if (state is RecoveryDone)
          _Notice(
            key: const Key('verify.done'),
            message: state.confirmation,
            tone: _Tone.neutral,
          ),

        // AF-06. A rate limit is an answer, not a failure, and it reads as one.
        if (state is RecoveryRateLimited)
          _Notice(
            key: const Key('verify.rateLimited'),
            message: state.reason,
            tone: _Tone.neutral,
          ),

        if (state is RecoveryRefused)
          _Notice(message: state.reason, tone: _Tone.error),

        const SizedBox(height: 16),
        OutlinedButton(
          key: const Key('verify.resend'),
          onPressed: state.isBusy
              ? null
              : () => unawaited(
                  ref
                      .read(accountRecoveryControllerProvider.notifier)
                      .resendVerification(),
                ),
          child: const Text('Send the verification email again'),
        ),
      ],
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    ),
  );
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 18,
    height: 18,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}

enum _Tone { neutral, error }

class _Notice extends StatelessWidget {
  const _Notice({required this.message, required this.tone, super.key});

  final String message;
  final _Tone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isError = tone == _Tone.error;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? scheme.errorContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.info_outline,
            size: 20,
            color: isError ? scheme.onErrorContainer : scheme.onSurface,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isError ? scheme.onErrorContainer : scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

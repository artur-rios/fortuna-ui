/// Holds the application back until restoration has finished (UC-11).
///
/// This is what makes step 3 of the main flow true — "verifies the token
/// **before** presenting any screen that depends on it". Without it the router
/// would build a screen against a session that is still being checked, and the
/// user would see their overview flicker into a sign-in page.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/session_restore_controller.dart';

class StartupGate extends ConsumerStatefulWidget {
  const StartupGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends ConsumerState<StartupGate> {
  @override
  void initState() {
    super.initState();
    // Deferred to after the first frame: restore() writes provider state, and
    // doing that during a build is what produces the "modified a provider while
    // widgets were building" error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(sessionRestoreProvider.notifier).restore());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionRestoreProvider);

    return switch (state) {
      SessionRestoreInProgress() => const _RestoringScreen(),
      SessionRestoreFailed(:final message, :final canRetry) => _FailedScreen(
        message: message,
        canRetry: canRetry,
        onRetry: () =>
            unawaited(ref.read(sessionRestoreProvider.notifier).restore()),
      ),
      SessionRestoreComplete() => widget.child,
    };
  }
}

/// Deliberately plain, and deliberately not a spinner over an empty overview:
/// nothing that depends on a session is built while one is being checked.
class _RestoringScreen extends StatelessWidget {
  const _RestoringScreen();

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    ),
  );
}

/// `AF-03` and `AF-04`. Says which happened, and offers a retry only where one
/// could help — an offer to retry something that will fail identically is worse
/// than no offer.
class _FailedScreen extends StatelessWidget {
  const _FailedScreen({
    required this.message,
    required this.canRetry,
    required this.onRetry,
  });

  final String message;
  final bool canRetry;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 40),
                const SizedBox(height: 16),
                Text(
                  'Could not restore your session',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                if (canRetry) ...[
                  const SizedBox(height: 24),
                  FilledButton(onPressed: onRetry, child: const Text('Retry')),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

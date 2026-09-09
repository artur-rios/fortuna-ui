/// The sign-out control (UC-12 main flow, AF-04).
///
/// Lives in the app bar of every signed-in screen, so ending a session is never
/// more than one action away — on a shared desktop that matters more than it
/// looks.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_controller.dart';

class SignOutAction extends ConsumerWidget {
  const SignOutAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    icon: const Icon(Icons.logout),
    tooltip: 'Sign out',
    onPressed: () async {
      final messenger = ScaffoldMessenger.of(context);
      final outcome = await ref.read(sessionProvider.notifier).signOut();

      // AF-04. On failure the session is still held, and the user is told —
      // rather than being shown a sign-in screen while their token sits on the
      // device.
      if (outcome case SignOutFailed(:final message)) {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }

      // On success nothing is announced and nothing is navigated here: the
      // guard sees the session end and redirects. One place decides where a
      // user may be, and this is not it (IR-03).
    },
  );
}

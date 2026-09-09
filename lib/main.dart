/// Application entry point.
///
/// Start-up order matters and is deliberate: the platform stores are opened
/// first, then the instance configuration is restored, and only then is the
/// application shown. Session restoration itself is `UC-11` and runs behind the
/// router's guard, which sends an unauthenticated user to sign-in before any
/// screen holding financial data is built.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/config/instance_config.dart';
import 'core/session/session_controller.dart';
import 'core/storage/preferences_store.dart';
import 'core/storage/token_store.dart';
import 'features/session/ui/startup_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferencesStore.open();

  final container = ProviderContainer(
    overrides: [
      preferencesStoreProvider.overrideWithValue(preferences),
      tokenStoreProvider.overrideWithValue(SecureTokenStore()),
    ],
  );

  // The instance has to be resolved before a client can be built against it,
  // which is why UC-01 precedes UC-11 in the start-up order.
  await container.read(instanceConfigProvider.notifier).restore();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StartupGate(child: FortunaApp()),
    ),
  );
}

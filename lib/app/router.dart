/// Routing, and the wiring of **the** route guard (IR-03, FR-AD-06).
///
/// The guard's decision itself lives in `route_guard.dart` as a pure function,
/// so it is tested on its inputs rather than through a pumped router.
///
/// There is exactly one redirect in this application, and every route passes
/// through it — a typed web URL, a deep link, a restored session, an ordinary
/// tap. A guard applied per screen is a guard somebody forgets on the screen
/// that mattered.
///
/// Hiding a control is never the protection (`FR-AD-07`). This redirect and the
/// API both refuse; concealment is a courtesy to the user.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config/instance_config.dart';
import '../core/session/session_controller.dart';
import 'route_guard.dart';
import 'routes.dart';
import 'shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // go_router refreshes on a Listenable; this bridges Riverpod's session state
  // to one without rebuilding the router and losing the navigation stack.
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(sessionProvider, (_, _) => refresh.value++)
    ..listen(instanceConfigProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: refresh,
    redirect: (context, state) => resolveRedirect(
      instance: ref.read(instanceConfigProvider),
      session: ref.read(sessionProvider),
      location: state.matchedLocation,
    ),
    errorBuilder: (context, state) => NotFoundScreen(location: state.uri.path),
    routes: [
      GoRoute(
        path: Routes.setup,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Set up your instance',
          route: Routes.setup,
          implementedBy: 'UC-01',
          signedIn: false,
        ),
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Sign in',
          route: Routes.signIn,
          implementedBy: 'UC-03',
          signedIn: false,
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Overview',
          route: Routes.home,
          implementedBy: 'UC-38',
        ),
      ),
      GoRoute(
        path: Routes.admin,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Instance health',
          route: Routes.admin,
          implementedBy: 'UC-45',
        ),
      ),
    ],
  );
});

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
import '../features/administration/ui/instance_health_screen.dart';
import '../features/audit/ui/audit_trail_screen.dart';
import '../features/auth/ui/password_recovery_screen.dart';
import '../features/auth/ui/sign_in_screen.dart';
import '../features/categories/ui/categories_screen.dart';
import '../features/holdings/ui/accounts_screen.dart';
import '../features/holdings/ui/credit_cards_screen.dart';
import '../features/ingestion/ui/connections_screen.dart';
import '../features/ingestion/ui/import_file_screen.dart';
import '../features/ingestion/ui/import_jobs_screen.dart';
import '../features/labels/ui/labels_screen.dart';
import '../features/preferences/ui/settings_screen.dart';
import '../features/privacy/ui/privacy_screen.dart';
import '../features/setup/ui/setup_screen.dart';
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
    // AF-06: evaluated on every navigation, not once at sign-in. go_router
    // calls this for each redirect, and the refresh listenable above re-runs it
    // whenever the session or the instance changes.
    redirect: (context, state) => resolveRedirect(
      instance: ref.read(instanceConfigProvider),
      session: ref.read(sessionProvider),
      location: state.matchedLocation,
      destination: state.uri.queryParameters[Routes.destinationParameter],
    ),
    errorBuilder: (context, state) => NotFoundScreen(location: state.uri.path),
    routes: [
      GoRoute(
        path: Routes.setup,
        builder: (context, state) => const SetupScreen(),
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.twoFactor,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Two-factor challenge',
          route: Routes.twoFactor,
          implementedBy: 'UC-04',
          signedIn: false,
        ),
      ),
      GoRoute(
        path: Routes.passwordRecovery,
        builder: (context, state) => const PasswordRecoveryScreen(),
      ),
      GoRoute(
        // The reset link carries its token in the query string, which is where
        // an emailed link can put one. It is read here and handed to the
        // screen rather than typed by a user who never chose it.
        path: Routes.passwordReset,
        builder: (context, state) => PasswordResetScreen(
          token: state.uri.queryParameters[Routes.tokenParameter] ?? '',
          onDone: () => context.go(Routes.signIn),
        ),
      ),
      GoRoute(
        path: Routes.verifyEmail,
        builder: (context, state) => VerifyEmailScreen(
          token: state.uri.queryParameters[Routes.tokenParameter] ?? '',
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
        path: Routes.accounts,
        builder: (context, state) => const AccountsScreen(),
      ),
      GoRoute(
        path: Routes.creditCards,
        builder: (context, state) => const CreditCardsScreen(),
      ),
      GoRoute(
        path: Routes.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: Routes.audit,
        builder: (context, state) => const AuditTrailScreen(),
      ),
      GoRoute(
        path: Routes.connections,
        builder: (context, state) => const ConnectionsScreen(),
      ),
      GoRoute(
        path: Routes.imports,
        builder: (context, state) => const ImportJobsScreen(),
      ),
      GoRoute(
        path: Routes.importFile,
        builder: (context, state) => const ImportFileScreen(),
      ),
      GoRoute(
        path: Routes.labels,
        builder: (context, state) => const LabelsScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.privacy,
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: Routes.admin,
        builder: (context, state) => const InstanceHealthScreen(),
      ),
    ],
  );
});

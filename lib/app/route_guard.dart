/// The route guard's decision, as a pure function (IR-03, FR-AD-06).
///
/// Separated from `router.dart` so it can be tested directly on its inputs
/// rather than only by pumping a router: this is the rule that decides who
/// reaches what, and it deserves tests that state each case plainly.
library;

import '../core/config/instance_config.dart';
import '../core/session/session.dart';
import 'routes.dart';

/// Decides where a request for [location] should go.
///
/// Returns `null` to admit it, or the location to redirect to. Applied to
/// **every** route however it was reached — a typed URL, a deep link, a
/// restored session (`FR-AD-06`).
String? resolveRedirect({
  required InstanceConfig instance,
  required SessionState session,
  required String location,
}) {
  // Nothing works without somewhere to send requests, so setup precedes even
  // sign-in (UC-01).
  if (!instance.isResolved) {
    return location == Routes.setup ? null : Routes.setup;
  }

  if (!session.isAuthenticated) {
    // ChallengePending lands here too, deliberately: until the second factor is
    // accepted, the application is in the same state as signed out (BR-19).
    return Routes.anonymous.contains(location) ? null : Routes.signIn;
  }

  final signedIn = session as SignedIn;

  // An authenticated user has no business on the anonymous routes.
  if (Routes.anonymous.contains(location)) {
    return homeFor(signedIn.role);
  }

  final isAdminRoute =
      location == Routes.admin || location.startsWith('${Routes.admin}/');
  final isAdmin = signedIn.role == Role.instanceAdministrator;

  // Two refusals in one comparison. An account owner is redirected away from
  // the administrative area without being told it exists (FR-AD-05); an
  // administrator is kept out of the financial application entirely, because
  // running the instance is not a reason to read its contents (FR-AD-03).
  if (isAdminRoute != isAdmin) {
    return homeFor(signedIn.role);
  }

  return null;
}

/// Where a role belongs when it is redirected.
String homeFor(Role role) =>
    role == Role.instanceAdministrator ? Routes.admin : Routes.home;

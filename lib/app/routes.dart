/// The route table, as constants rather than string literals scattered through
/// the application.
///
/// The full surface is specified in System Requirements §5. Routes are added
/// here by the use case that implements the screen behind them; the guard in
/// `router.dart` needs no change when one is, because it classifies by prefix
/// and by [anonymous] membership rather than by enumerating every route.
library;

abstract final class Routes {
  // Anonymous.
  static const setup = '/setup';
  static const signIn = '/sign-in';

  // Account owner.
  static const home = '/';

  /// Reachable by both roles: presentation choices are not financial data.
  static const settings = '/settings';

  static const categories = '/categories';
  static const labels = '/labels';
  static const imports = '/imports';
  static const importFile = '/imports/new';

  // Instance administrator.
  static const admin = '/admin';

  /// The query parameter carrying where the user was going before sign-in
  /// (`UC-46 AF-02`).
  static const destinationParameter = 'from';

  /// Routes an authenticated user of **either** role may reach.
  static const Set<String> sharedByBothRoles = {settings};

  /// Routes reachable without a session.
  ///
  /// Membership of this set is the *only* thing that makes a route anonymous —
  /// which is what stops a new screen being reachable by having forgotten to
  /// guard it.
  static const Set<String> anonymous = {setup, signIn};
}

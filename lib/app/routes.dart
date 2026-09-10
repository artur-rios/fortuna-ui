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

  /// The second-factor challenge (`UC-04`). Anonymous because a challenge
  /// grants nothing — until it is satisfied the application is signed out
  /// (`BR-19`).
  static const twoFactor = '/sign-in/two-factor';

  /// Recovering a password and verifying an address (`UC-09`).
  static const passwordRecovery = '/password-recovery';

  /// Where a reset link lands, carrying its token in the query string.
  static const passwordReset = '/password-reset';
  static const verifyEmail = '/verify-email';

  /// The query parameter a reset or verification link carries its token in.
  static const tokenParameter = 'token';

  // Account owner.
  static const home = '/';

  /// Reachable by both roles: presentation choices are not financial data.
  static const settings = '/settings';

  /// Data rights: consents, complete export and erasure (`UC-42` … `UC-44`).
  static const privacy = '/privacy';

  /// Holdings (`UC-14` … `UC-18`).
  static const accounts = '/accounts';
  static const creditCards = '/credit-cards';

  /// A card's billing cycles, and one statement within them (`UC-16`).
  ///
  /// Nested under the card because a statement has no meaning apart from it,
  /// and because the guard classifies by prefix — a route under an owner route
  /// needs no separate entry to be protected.
  static const cardStatements = '$creditCards/:id/statements';
  static const cardStatement = '$creditCards/:id/statements/:statementId';

  /// The concrete path for one card's cycles.
  static String statementsOf(String creditCardId) =>
      '$creditCards/$creditCardId/statements';

  /// The concrete path for one statement.
  static String statementOf({
    required String creditCardId,
    required String statementId,
  }) => '$creditCards/$creditCardId/statements/$statementId';

  static const categories = '/categories';
  static const labels = '/labels';
  static const imports = '/imports';
  static const importFile = '/imports/new';
  static const connections = '/connections';
  static const audit = '/audit';

  // Instance administrator.
  static const admin = '/admin';

  /// The query parameter carrying where the user was going before sign-in
  /// (`UC-46 AF-02`).
  static const destinationParameter = 'from';

  /// Routes an authenticated user of **either** role may reach.
  static const Set<String> sharedByBothRoles = {settings, privacy};

  /// Routes reachable without a session.
  ///
  /// Membership of this set is the *only* thing that makes a route anonymous —
  /// which is what stops a new screen being reachable by having forgotten to
  /// guard it.
  static const Set<String> anonymous = {
    setup,
    signIn,
    twoFactor,
    passwordRecovery,
    passwordReset,
    verifyEmail,
  };
}

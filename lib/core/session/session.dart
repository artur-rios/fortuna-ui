/// Session state (FR-SE-04, FR-SE-18, FR-SE-19, BR-19).
///
/// The states are a sealed hierarchy so the router's guard must handle every
/// one of them exhaustively — a new state cannot be added without the compiler
/// pointing at the guard.
///
/// [ChallengePending] deliberately holds nothing a session holds. Until a
/// second factor is accepted the application is in the same state as signed
/// out: a half-authenticated session is an authenticated session with extra
/// steps.
library;

import 'package:meta/meta.dart';

/// What the signed-in identity may do (`FR-AD-01`, `FR-AD-05`).
enum Role {
  accountOwner,
  instanceAdministrator;

  /// Parses the role named by the API's token claim. An unrecognized role is
  /// `null` rather than a guess — a stored token naming a role this instance
  /// does not know is discarded and the user signs in again (`UC-11 AF-05`).
  static Role? tryParse(String? value) => switch (value?.toLowerCase()) {
    'accountowner' || 'account_owner' || 'owner' => Role.accountOwner,
    'instanceadministrator' ||
    'instance_administrator' ||
    'administrator' ||
    'admin' => Role.instanceAdministrator,
    _ => null,
  };
}

/// Which shape this installation runs in (`FR-CF-03`).
enum AppMode { connected, selfHosted, desktopOffline }

/// The application's session, in exactly one state at a time.
@immutable
sealed class SessionState {
  const SessionState();

  /// Whether a screen holding financial data may be shown. True for
  /// [SignedIn] and nothing else.
  bool get isAuthenticated => this is SignedIn;
}

/// Nobody is signed in. The starting state, and the one every failure and
/// sign-out returns to.
@immutable
final class SignedOut extends SessionState {
  const SignedOut({this.reason});

  /// Why the session ended, where there is something worth telling the user —
  /// an expired token, for instance. `null` on a deliberate sign-out.
  final String? reason;
}

/// Credentials have been submitted and the API has not yet answered.
@immutable
final class Authenticating extends SessionState {
  const Authenticating();
}

/// The first factor was accepted and a second is required.
///
/// Grants nothing: [SessionState.isAuthenticated] is false here, so the guard
/// treats it exactly as [SignedOut] (`BR-19`).
@immutable
final class ChallengePending extends SessionState {
  const ChallengePending({
    required this.challengeToken,
    required this.methods,
    required this.expiresAt,
  });

  /// Held in memory only, never written to storage — it is a credential.
  final String challengeToken;

  /// Which second factors this account accepts.
  final List<String> methods;

  final DateTime expiresAt;

  bool get hasExpired => DateTime.now().isAfter(expiresAt);
}

/// A verified session.
@immutable
final class SignedIn extends SessionState {
  const SignedIn({
    required this.role,
    required this.mode,
    required this.subjectReference,
  });

  final Role role;
  final AppMode mode;

  /// The opaque subject the token names. Never displayed as an identity.
  final String subjectReference;
}

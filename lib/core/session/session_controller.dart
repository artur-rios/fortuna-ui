/// The session provider (FR-SE-18, FR-SE-21, IR-03).
///
/// Owns the transitions of [SessionState] and nothing else: how a credential
/// becomes a session is each sign-in use case's business, and it calls
/// [SessionController.grant] with the outcome.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../storage/token_store.dart';
import 'session.dart';
import 'session_teardown.dart';

/// Supplies the token store. Overridden in tests with an in-memory fake.
final tokenStoreProvider = Provider<TokenStore>(
  (ref) => throw UnimplementedError(
    'tokenStoreProvider must be overridden at start-up with the platform store',
  ),
);

/// The outcome of a deliberate sign-out (`UC-12`).
@immutable
sealed class SignOutOutcome {
  const SignOutOutcome();
}

/// The session ended and nothing of it remains.
@immutable
final class SignedOutCleanly extends SignOutOutcome {
  const SignedOutCleanly();
}

/// The token could not be removed, so the session did **not** end.
///
/// `AF-04`: the user is not presented as signed out while their token is still
/// on the device. Telling someone they have signed out when they have not is
/// the one outcome worse than refusing to sign them out.
@immutable
final class SignOutFailed extends SignOutOutcome {
  const SignOutFailed(this.message);

  final String message;
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);

class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() => const SignedOut();

  /// Restores a session at start-up (`UC-11`).
  ///
  /// [verify] asks the API whether the stored token is still good. The session
  /// is **never** granted on the presence of a token alone — an unverified
  /// token is exactly the case `AF-03` refuses to admit.
  Future<void> restore({
    required Future<SignedIn?> Function(String token) verify,
  }) async {
    final store = ref.read(tokenStoreProvider);
    final token = await store.read();

    if (token == null || token.isEmpty) {
      state = const SignedOut();
      return;
    }

    final verified = await verify(token);
    if (verified == null) {
      await store.clear();
      state = const SignedOut();
      return;
    }

    state = verified;
  }

  /// Records that credentials have been submitted.
  void beginAuthentication() => state = const Authenticating();

  /// Records that the API answered with a two-factor challenge (`UC-04`).
  void challenge(ChallengePending pending) => state = pending;

  /// Returns to signed out from an authentication that did not complete.
  ///
  /// Every sign-in failure ends here, and so does an abandoned or expired
  /// challenge (`UC-04 AF-03`). Named for what it means rather than reusing
  /// [signOut], which tears down caches and view state that a failed sign-in
  /// never built.
  void challengeAbandoned({String? reason}) =>
      state = SignedOut(reason: reason);

  /// Grants a session and persists its token.
  Future<void> grant({required String token, required SignedIn session}) async {
    await ref.read(tokenStoreProvider).write(token);
    state = session;
  }

  /// Signs out deliberately (`UC-12` main flow).
  ///
  /// Clears the token first and only then the caches and view state, so that a
  /// failure to remove the token leaves everything intact rather than
  /// half-cleared — see `AF-04`.
  Future<SignOutOutcome> signOut() async {
    try {
      await ref.read(tokenStoreProvider).clear();
    } on Object {
      return const SignOutFailed(
        'Your session could not be ended on this device. '
        'Please try again.',
      );
    }

    await ref.read(sessionTeardownProvider).runAll();
    state = const SignedOut();
    return const SignedOutCleanly();
  }

  /// Ends the session because the API rejected the token mid-flight
  /// (`FR-SE-19`, `UC-12 AF-01`).
  ///
  /// Unlike [signOut] this always ends the session, even if the token cannot be
  /// removed: a token the API has rejected is worthless, and staying signed in
  /// on it would offer a session that cannot do anything. Any token left behind
  /// is discarded at the next start-up, where `UC-11 AF-02` refuses it.
  ///
  /// Deliberately does not retry, refresh, or replay the interrupted action:
  /// silently replaying a financial write the user cannot see is how an action
  /// happens twice (`FR-SE-20`, `AF-02`).
  Future<void> rejectedByApi({
    String reason = 'Your session expired. Please sign in again.',
  }) async {
    try {
      await ref.read(tokenStoreProvider).clear();
    } on Object {
      // Deliberately swallowed: see above. The session ends regardless.
    }

    await ref.read(sessionTeardownProvider).runAll();
    state = SignedOut(reason: reason);
  }
}

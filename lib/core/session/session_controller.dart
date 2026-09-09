/// The session provider (FR-SE-18, FR-SE-21, IR-03).
///
/// Owns the transitions of [SessionState] and nothing else: how a credential
/// becomes a session is each sign-in use case's business, and it calls
/// [SessionController.grant] with the outcome.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/token_store.dart';
import 'session.dart';

/// Supplies the token store. Overridden in tests with an in-memory fake.
final tokenStoreProvider = Provider<TokenStore>(
  (ref) => throw UnimplementedError(
    'tokenStoreProvider must be overridden at start-up with the platform store',
  ),
);

/// Invoked when caches must be dropped because the session ended.
///
/// Registered by each feature that caches reference data, so that `FR-SE-21`
/// holds without this file having to know what those features are.
final sessionTeardownProvider = Provider<List<void Function()>>((ref) => []);

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

  /// Grants a session and persists its token.
  Future<void> grant({required String token, required SignedIn session}) async {
    await ref.read(tokenStoreProvider).write(token);
    state = session;
  }

  /// Ends the session, clearing the token and every registered cache
  /// (`FR-SE-21`).
  ///
  /// [reason] is shown to the user where the session ended on its own — an
  /// expired token — and is `null` for a deliberate sign-out.
  Future<void> end({String? reason}) async {
    await ref.read(tokenStoreProvider).clear();
    for (final teardown in ref.read(sessionTeardownProvider)) {
      teardown();
    }
    state = SignedOut(reason: reason);
  }

  /// Ends the session because the API rejected the token mid-flight
  /// (`FR-SE-19`).
  ///
  /// Deliberately does not retry, refresh, or replay the interrupted action:
  /// silently replaying a financial write the user cannot see is how an action
  /// happens twice (`FR-SE-20`).
  Future<void> rejectedByApi() =>
      end(reason: 'Your session expired. Please sign in again.');
}

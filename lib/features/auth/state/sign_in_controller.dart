/// The sign-in screen's decision-making (UC-03).
///
/// Two rules shape this file, and both are about what is *not* here.
///
/// The credential is never held. It arrives as an argument, goes to the
/// repository, and is gone — nothing stores it, and nothing retains it for a
/// retry after a lost connection (`AF-04`, `AF-05`).
///
/// The rejection is never interpreted. `FR-SE-23` asks that an unknown account
/// and a wrong password stay indistinguishable, and the only way to guarantee
/// that is to show whatever the API said and never branch on it.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/config/instance_config.dart';
import '../../../core/result/result.dart';
import '../../../core/session/session.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/token_claims.dart';
import '../data/credentials_repository.dart';
import '../data/google_identity.dart';

/// Where the sign-in form is in its work.
@immutable
sealed class SignInFormState {
  const SignInFormState();

  bool get isBusy => this is SignInSubmitting;

  /// The reason to show, or `null` when there is nothing to say.
  String? get message => switch (this) {
    SignInInvalid(:final reason) => reason,
    SignInRefused(:final reason) => reason,
    SignInUnreachable(:final reason) => reason,
    SignInNeedsVerification(:final reason) => reason,
    SignInReady() || SignInSubmitting() || SignInDone() => null,
  };
}

/// Nothing has been submitted.
@immutable
final class SignInReady extends SignInFormState {
  const SignInReady();
}

/// The API has not yet answered.
@immutable
final class SignInSubmitting extends SignInFormState {
  const SignInSubmitting();
}

/// `AF-01`: rejected in the form, nothing submitted.
@immutable
final class SignInInvalid extends SignInFormState {
  const SignInInvalid(this.reason);

  final String reason;
}

/// `AF-02`: the API refused, and its single message is what is shown.
@immutable
final class SignInRefused extends SignInFormState {
  const SignInRefused(this.reason);

  final String reason;
}

/// `AF-04`: the instance could not be reached, and a retry is offered.
@immutable
final class SignInUnreachable extends SignInFormState {
  const SignInUnreachable(this.reason);

  final String reason;
}

/// `AF-06`: the API refused because the address is unverified.
@immutable
final class SignInNeedsVerification extends SignInFormState {
  const SignInNeedsVerification(this.reason);

  final String reason;
}

/// The API answered; the session or the challenge is now held.
@immutable
final class SignInDone extends SignInFormState {
  const SignInDone();
}

final signInControllerProvider =
    NotifierProvider<SignInController, SignInFormState>(SignInController.new);

class SignInController extends Notifier<SignInFormState> {
  @override
  SignInFormState build() => const SignInReady();

  /// Clears any message, so a correction is not masked by the complaint about
  /// what it corrected.
  void reset() {
    if (state is! SignInReady && state is! SignInSubmitting) {
      state = const SignInReady();
    }
  }

  /// Whether [email] looks like an address worth submitting.
  ///
  /// Deliberately permissive: this is feedback, not authority. The API decides
  /// what an acceptable address is (`FR-DA-15`), and a client that refuses one
  /// the API would have accepted is a client that locks a user out of their own
  /// account.
  static bool isPlausibleEmail(String email) {
    final trimmed = email.trim();
    final at = trimmed.indexOf('@');

    return at > 0 &&
        at == trimmed.lastIndexOf('@') &&
        at < trimmed.length - 1 &&
        !trimmed.contains(' ');
  }

  Future<void> submit({required String email, required String password}) async {
    // AF-01 — before anything is submitted.
    if (!isPlausibleEmail(email)) {
      state = const SignInInvalid('Enter the email address for your account.');
      return;
    }
    if (password.isEmpty) {
      state = const SignInInvalid('Enter your password.');
      return;
    }

    state = const SignInSubmitting();
    ref.read(sessionProvider.notifier).beginAuthentication();

    final result = await ref
        .read(credentialsRepositoryProvider)
        .signIn(email: email.trim(), password: password);

    switch (result) {
      case Failure<SignInOutcome>(:final message, :final kind):
        // The session returns to signed out on every failure: an Authenticating
        // state left behind would be a spinner nobody clears.
        ref.read(sessionProvider.notifier).challengeAbandoned();

        state = switch (kind) {
          // AF-04. The credential is not kept for the retry — the user types it
          // again, which is the price of not holding a password in memory.
          FailureKind.unreachable => SignInUnreachable(message),
          // AF-06. Presented as the API worded it, with the verification path
          // offered alongside rather than instead.
          FailureKind.forbidden => SignInNeedsVerification(message),
          // AF-02, and everything else. One message, no classification.
          _ => SignInRefused(message),
        };

      case Success<SignInOutcome>(:final value):
        switch (value) {
          // AF-03: a challenge grants nothing; UC-04 takes it from here.
          case SignInChallenged(
            :final challengeToken,
            :final methods,
            :final expiresAt,
          ):
            ref
                .read(sessionProvider.notifier)
                .challenge(
                  ChallengePending(
                    challengeToken: challengeToken,
                    methods: methods,
                    expiresAt: expiresAt,
                  ),
                );
            state = const SignInDone();

          case SignInGranted(:final token):
            // Only a session that was actually granted ends the form. A token
            // this client cannot read leaves the refusal _grant set standing.
            if (await _grant(token)) state = const SignInDone();
        }
    }
  }

  /// Signs in with Google (`UC-05`).
  ///
  /// Only ever called where the option was offered, which is only where this
  /// build carries a client id (`AF-04`).
  Future<void> signInWithGoogle() async {
    final google = ref.read(googleIdentityServiceProvider);
    if (google == null) return;

    state = const SignInSubmitting();

    final outcome = await google.obtainIdToken();

    switch (outcome) {
      // AF-01. Nothing changed, and nothing is presented as a failure: closing
      // the sheet is a decision, not an error.
      case GoogleIdentityCancelled():
        state = const SignInReady();
        return;

      // AF-02. Reported, with the credential path still on the screen beneath.
      case GoogleIdentityUnavailable(:final reason):
        state = SignInRefused(reason);
        return;

      case GoogleIdentityObtained(:final idToken):
        ref.read(sessionProvider.notifier).beginAuthentication();

        final result = await ref
            .read(credentialsRepositoryProvider)
            .exchangeGoogleIdToken(idToken);

        switch (result) {
          // AF-03 and AF-05: the API's own reason, unaltered.
          case Failure<SignInGranted>(:final message, :final kind):
            ref.read(sessionProvider.notifier).challengeAbandoned();
            state = kind == FailureKind.unreachable
                ? SignInUnreachable(message)
                : SignInRefused(message);

          case Success<SignInGranted>(:final value):
            if (await _grant(value.token)) state = const SignInDone();
        }
    }
  }

  /// Turns a token into the session the guard reads.
  ///
  /// Returns whether a session was granted.
  Future<bool> _grant(String token) async {
    final claims = TokenClaims.tryParse(token);

    if (claims == null) {
      // A token this client cannot read is one it could not act on even if the
      // API meant well by it.
      ref.read(sessionProvider.notifier).challengeAbandoned();
      state = const SignInRefused(
        'The instance issued a session this application could not read.',
      );
      return false;
    }

    await ref
        .read(sessionProvider.notifier)
        .grant(
          token: token,
          session: SignedIn(
            role: claims.role,
            // The mode is the installation's, as UC-01 resolved it.
            mode: ref.read(instanceConfigProvider).mode,
            subjectReference: claims.subject,
          ),
        );

    return true;
  }
}

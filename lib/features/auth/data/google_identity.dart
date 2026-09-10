/// Obtaining a Google ID token, locally (UC-05, FR-SE-22).
///
/// This is the one external service the application talks to directly, and it
/// is talked to for exactly one thing: an ID token, which the API then
/// exchanges. No profile is read from Google, nothing is sent to Google beyond
/// the sign-in itself, and no other identity service is reached (`FR-PR-11`).
///
/// Wrapped behind an interface because `GoogleSignIn` is a platform singleton:
/// a test that wanted to drive the real one would need a platform channel, and
/// a sign-in screen should be testable without one.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../../core/config/instance_config.dart';

/// What Google did when asked for an identity.
@immutable
sealed class GoogleIdentityOutcome {
  const GoogleIdentityOutcome();
}

/// An ID token the API can exchange.
@immutable
final class GoogleIdentityObtained extends GoogleIdentityOutcome {
  const GoogleIdentityObtained(this.idToken);

  final String idToken;
}

/// `AF-01`: the user closed the sheet. Not a failure, and never shown as one.
@immutable
final class GoogleIdentityCancelled extends GoogleIdentityOutcome {
  const GoogleIdentityCancelled();
}

/// `AF-02`: Google answered, with nothing this application can use.
@immutable
final class GoogleIdentityUnavailable extends GoogleIdentityOutcome {
  const GoogleIdentityUnavailable(this.reason);

  final String reason;
}

abstract interface class GoogleIdentityService {
  /// Runs the platform's Google sign-in and returns what came of it.
  Future<GoogleIdentityOutcome> obtainIdToken();
}

class PlatformGoogleIdentityService implements GoogleIdentityService {
  PlatformGoogleIdentityService({required this.clientId, GoogleSignIn? signIn})
    : _signIn = signIn ?? GoogleSignIn.instance;

  /// The public client identifier this build was configured with. Not a secret
  /// — see `AppConfig`.
  final String clientId;

  final GoogleSignIn _signIn;
  Future<void>? _initialized;

  @override
  Future<GoogleIdentityOutcome> obtainIdToken() async {
    try {
      _initialized ??= _signIn.initialize(clientId: clientId);
      await _initialized;

      final account = await _signIn.authenticate();
      final idToken = account.authentication.idToken;

      // AF-02. Google can complete a sign-in and still hand back no ID token —
      // a misconfigured client id is the usual cause — and an empty token
      // submitted to the API would come back as an opaque rejection.
      if (idToken == null || idToken.isEmpty) {
        return const GoogleIdentityUnavailable(
          'Google did not return a usable sign-in token.',
        );
      }

      return GoogleIdentityObtained(idToken);
    } on GoogleSignInException catch (exception) {
      // AF-01. Cancelling is a decision, not an error, and it is the one
      // outcome here that must never reach the user as a failure.
      if (exception.code == GoogleSignInExceptionCode.canceled) {
        return const GoogleIdentityCancelled();
      }

      // The initializer is cleared so a later attempt can re-initialize rather
      // than being stuck behind one bad start.
      _initialized = null;
      return GoogleIdentityUnavailable(
        exception.description ?? 'Google sign-in could not be completed.',
      );
    } on Object catch (error) {
      _initialized = null;
      return GoogleIdentityUnavailable(
        'Google sign-in could not be completed ($error).',
      );
    }
  }
}

/// The Google service, or `null` where this build cannot offer Google sign-in.
///
/// `null` is `AF-04`: an instance with no client id configured does not show
/// the option at all, rather than showing one that fails when pressed.
final googleIdentityServiceProvider = Provider<GoogleIdentityService?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (!config.supportsGoogleSignIn) return null;

  return PlatformGoogleIdentityService(clientId: config.googleClientId);
});

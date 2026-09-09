/// Restoring a session at start-up (UC-11).
///
/// The order is the whole point: read, parse, **verify**, then admit. A token
/// is never trusted for being present — `AF-03` is explicit that an unreachable
/// API means the user is not admitted, rather than admitted optimistically and
/// corrected later on a screen showing their money.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/config/instance_config.dart';
import '../../../core/result/result.dart';
import '../../../core/session/session.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/token_claims.dart';
import '../data/session_repository.dart';

/// Where start-up has got to.
@immutable
sealed class SessionRestoreState {
  const SessionRestoreState();
}

/// Reading and verifying. Nothing that depends on a session is shown yet.
@immutable
final class SessionRestoreInProgress extends SessionRestoreState {
  const SessionRestoreInProgress();
}

/// Finished — with a session or without one. Either way the application may
/// proceed, and the router decides where to.
@immutable
final class SessionRestoreComplete extends SessionRestoreState {
  const SessionRestoreComplete();
}

/// Restoration could not be completed, and the user is **not** admitted.
///
/// Distinct from "no session": the difference between "you are signed out" and
/// "we could not tell" matters to the person looking at the screen, and only
/// one of them is worth offering a retry for.
@immutable
final class SessionRestoreFailed extends SessionRestoreState {
  const SessionRestoreFailed({required this.message, required this.canRetry});

  final String message;

  /// Whether retrying could plausibly help. True for an unreachable instance
  /// (`AF-03`), false for storage this platform cannot provide (`AF-04`).
  final bool canRetry;
}

final sessionRestoreProvider =
    NotifierProvider<SessionRestoreController, SessionRestoreState>(
      SessionRestoreController.new,
    );

class SessionRestoreController extends Notifier<SessionRestoreState> {
  @override
  SessionRestoreState build() => const SessionRestoreInProgress();

  /// Runs the restore. Safe to call again — that is what `AF-03`'s retry does.
  Future<void> restore() async {
    state = const SessionRestoreInProgress();

    final String? token;
    try {
      token = await ref.read(tokenStoreProvider).read();
    } on Object {
      // AF-04. The platform cannot give us secure storage — on the web with
      // site data blocked, for instance. Reported honestly, and not retried:
      // it will fail identically next time.
      state = const SessionRestoreFailed(
        message:
            'This device cannot store a session securely, so a previous one '
            'could not be restored. Please sign in.',
        canRetry: false,
      );
      return;
    }

    // AF-01. No token is the ordinary case on a first run, and is not a
    // failure — the router sends them to sign in.
    if (token == null || token.isEmpty) {
      state = const SessionRestoreComplete();
      return;
    }

    // AF-05, and a malformed token besides. Discarded rather than sent to the
    // API, since a token this client cannot read is one it could not act on
    // even if the API accepted it.
    final claims = TokenClaims.tryParse(token);
    if (claims == null) {
      await _discard();
      return;
    }

    final result = await ref
        .read(sessionRepositoryProvider)
        .verifyCurrentToken();

    switch (result) {
      case Success<VerifiedProfile>():
        // Only here — after the API confirmed it — does a session exist.
        await ref
            .read(sessionProvider.notifier)
            .grant(
              token: token,
              session: SignedIn(
                // The mode is the installation's, not the token's: it is what
                // UC-01 resolved. The token's `fortuna_local` claim only says
                // the identity is a local one, which is a consequence of the
                // mode rather than a second opinion about it.
                role: claims.role,
                mode: ref.read(instanceConfigProvider).mode,
                subjectReference: claims.subject,
              ),
            );
        state = const SessionRestoreComplete();

      case Failure<VerifiedProfile>(:final kind, :final message):
        switch (kind) {
          // AF-02. The API rejected it: discard and sign in again.
          case FailureKind.unauthenticated:
          case FailureKind.forbidden:
            await _discard();

          // AF-03. We could not reach the instance, so we do not know whether
          // the token is good — and an unknown token admits nobody. The token
          // is kept, because it may well still be valid.
          case FailureKind.unreachable:
          case FailureKind.serverError:
            state = SessionRestoreFailed(message: message, canRetry: true);

          case FailureKind.invalidInput:
          case FailureKind.notFound:
          case FailureKind.conflict:
            await _discard();
        }
    }
  }

  /// Drops the stored token and finishes without a session.
  Future<void> _discard() async {
    await ref.read(sessionProvider.notifier).end();
    state = const SessionRestoreComplete();
  }
}

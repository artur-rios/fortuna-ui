/// Signing in to the desktop local account (UC-07).
///
/// The identity-provider paths are not merely hidden here — they are absent.
/// A desktop offline installation has no network to reach Heimdall or Google
/// through, so offering either would be offering something that cannot work.
///
/// `AF-03` is the one that needed thought. A local account genuinely has no
/// password reset, because a reset needs a channel to prove identity through
/// and offline there is none. Saying "we could not send the email" would be a
/// lie about a mechanism that does not exist; `FR-SE-09` asks that the reason
/// be explained instead, and recovery by code offered in its place.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/token_claims.dart';
import '../data/local_account_repository.dart';

@immutable
sealed class LocalSignInState {
  const LocalSignInState();

  bool get isBusy => this is LocalSignInSubmitting;

  String? get message => switch (this) {
    LocalSignInInvalid(:final reason) => reason,
    LocalSignInRefused(:final reason) => reason,
    LocalSignInUnusable(:final reason) => reason,
    LocalSignInReady() || LocalSignInSubmitting() || LocalSignInDone() => null,
  };
}

@immutable
final class LocalSignInReady extends LocalSignInState {
  const LocalSignInReady();
}

@immutable
final class LocalSignInSubmitting extends LocalSignInState {
  const LocalSignInSubmitting();
}

/// `AF-01`: an empty field, rejected in the form.
@immutable
final class LocalSignInInvalid extends LocalSignInState {
  const LocalSignInInvalid(this.reason);

  final String reason;
}

/// `AF-02`: the core's single message, for an unknown name and a wrong secret
/// alike.
@immutable
final class LocalSignInRefused extends LocalSignInState {
  const LocalSignInRefused(this.reason);

  final String reason;
}

/// `AF-05`: the core cannot be reached or initialized.
///
/// Distinct from a refusal because it means something entirely different: not
/// "those credentials are wrong" but "this installation does not work". The
/// screen says so rather than presenting an empty application.
@immutable
final class LocalSignInUnusable extends LocalSignInState {
  const LocalSignInUnusable(this.reason);

  final String reason;
}

@immutable
final class LocalSignInDone extends LocalSignInState {
  const LocalSignInDone();
}

final localSignInControllerProvider =
    NotifierProvider<LocalSignInController, LocalSignInState>(
      LocalSignInController.new,
    );

class LocalSignInController extends Notifier<LocalSignInState> {
  @override
  LocalSignInState build() => const LocalSignInReady();

  void reset() {
    if (state is LocalSignInInvalid || state is LocalSignInRefused) {
      state = const LocalSignInReady();
    }
  }

  Future<void> submit({required String name, required String secret}) async {
    // AF-01 — before anything reaches the core.
    if (name.trim().isEmpty) {
      state = const LocalSignInInvalid('Enter the account name.');
      return;
    }
    if (secret.isEmpty) {
      state = const LocalSignInInvalid('Enter the secret.');
      return;
    }

    state = const LocalSignInSubmitting();
    ref.read(sessionProvider.notifier).beginAuthentication();

    final result = await ref
        .read(localAccountRepositoryProvider)
        .authenticate(name: name.trim(), secret: secret);

    switch (result) {
      case Failure<String>(:final message, :final kind):
        ref.read(sessionProvider.notifier).challengeAbandoned();

        // AF-05 against AF-02. A core that will not answer is not a wrong
        // password, and telling the user to check their secret when the
        // installation itself is broken sends them looking in the wrong place.
        state =
            kind == FailureKind.unreachable || kind == FailureKind.serverError
            ? LocalSignInUnusable(message)
            : LocalSignInRefused(message);

      case Success<String>(:final value):
        final claims = TokenClaims.tryParse(value);

        if (claims == null) {
          ref.read(sessionProvider.notifier).challengeAbandoned();
          state = const LocalSignInUnusable(
            'The core issued a session this application could not read.',
          );
          return;
        }

        await ref
            .read(sessionProvider.notifier)
            .grant(
              token: value,
              session: SignedIn(
                // Main-flow step 4: a local session always carries the account
                // owner role. There is no administrator offline — there is no
                // instance to administer.
                role: Role.accountOwner,
                mode: AppMode.desktopOffline,
                subjectReference: claims.subject,
              ),
            );
        state = const LocalSignInDone();
    }
  }
}

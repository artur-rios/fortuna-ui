/// Recovering a desktop local account (UC-08).
///
/// Three stages, in one state machine: the code and a new secret, then the
/// offer to re-key, then the new codes if the user accepted.
///
/// Two things are said plainly throughout, because both are easy to get wrong
/// in a way the user only discovers when it is too late:
///
///  - **The code is spent**, whether or not the rest of the flow finishes, and
///    the count of what is left is shown (`FR-SE-07`).
///  - **Regeneration that fails costs nothing.** The old codes stay valid, and
///    the screen says so rather than leaving the user believing they are gone
///    (`AF-05`).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/token_claims.dart';
import '../data/local_account_repository.dart';

@immutable
sealed class LocalRecoveryState {
  const LocalRecoveryState();

  bool get isBusy => this is LocalRecoverySubmitting;

  String? get message => switch (this) {
    LocalRecoveryInvalid(:final reason) => reason,
    LocalRecoveryRefused(:final reason) => reason,
    LocalRecoveryRegenerationFailed(:final reason) => reason,
    _ => null,
  };
}

@immutable
final class LocalRecoveryReady extends LocalRecoveryState {
  const LocalRecoveryReady();
}

@immutable
final class LocalRecoverySubmitting extends LocalRecoveryState {
  const LocalRecoverySubmitting();
}

/// `AF-01` of the form's own making: an empty field.
@immutable
final class LocalRecoveryInvalid extends LocalRecoveryState {
  const LocalRecoveryInvalid(this.reason);

  final String reason;
}

/// `AF-01`, `AF-02` and `AF-03`: one message for a wrong code, a spent code and
/// an account that does not exist.
@immutable
final class LocalRecoveryRefused extends LocalRecoveryState {
  const LocalRecoveryRefused(this.reason);

  final String reason;
}

/// Recovered. Step 4: the code is spent, and this says how many are left.
@immutable
final class LocalRecoveryRecovered extends LocalRecoveryState {
  const LocalRecoveryRecovered({required this.remaining});

  final int remaining;

  /// Whether the user has nothing left to recover with next time.
  ///
  /// `AF-02` asks that this be stated without implying a path that does not
  /// exist — so it is said, and nothing is offered alongside it.
  bool get isLastCode => remaining == 0;
}

/// `AF-05`: the old codes stand, and the screen says so explicitly.
@immutable
final class LocalRecoveryRegenerationFailed extends LocalRecoveryState {
  const LocalRecoveryRegenerationFailed({
    required this.reason,
    required this.remaining,
  });

  final String reason;

  /// What is still valid, because it still is.
  final int remaining;
}

/// New codes, shown once, exactly as `UC-06` shows them.
@immutable
final class LocalRecoveryCodesIssued extends LocalRecoveryState {
  const LocalRecoveryCodesIssued(this.account);

  final CreatedLocalAccount account;
}

/// `AF-04`: the user declined to re-key, and the remaining codes stand.
@immutable
final class LocalRecoveryFinished extends LocalRecoveryState {
  const LocalRecoveryFinished({required this.remaining});

  final int remaining;
}

final localRecoveryControllerProvider =
    NotifierProvider<LocalRecoveryController, LocalRecoveryState>(
      LocalRecoveryController.new,
    );

class LocalRecoveryController extends Notifier<LocalRecoveryState> {
  @override
  LocalRecoveryState build() => const LocalRecoveryReady();

  /// The secret the user just set, held only long enough to re-key with it.
  ///
  /// Regeneration needs the secret, and asking for it again one screen after
  /// they set it would be asking them to prove something they just proved.
  String? _secret;

  int _remaining = 0;

  void reset() {
    if (state is LocalRecoveryInvalid || state is LocalRecoveryRefused) {
      state = const LocalRecoveryReady();
    }
  }

  Future<void> recover({
    required String name,
    required String recoveryCode,
    required String newSecret,
  }) async {
    if (name.trim().isEmpty) {
      state = const LocalRecoveryInvalid('Enter the account name.');
      return;
    }
    if (recoveryCode.trim().isEmpty) {
      state = const LocalRecoveryInvalid('Enter one of your recovery codes.');
      return;
    }
    if (newSecret.isEmpty) {
      state = const LocalRecoveryInvalid('Choose a new secret.');
      return;
    }

    state = const LocalRecoverySubmitting();

    final result = await ref
        .read(localAccountRepositoryProvider)
        .recover(
          name: name.trim(),
          recoveryCode: recoveryCode.trim(),
          newSecret: newSecret,
        );

    switch (result) {
      // AF-01, AF-02, AF-03: one message, and no way to tell which happened.
      case Failure<RecoveredLocalAccount>(:final message):
        state = LocalRecoveryRefused(message);

      case Success<RecoveredLocalAccount>(:final value):
        final claims = TokenClaims.tryParse(value.token);

        if (claims == null) {
          state = const LocalRecoveryRefused(
            'The core issued a session this application could not read.',
          );
          return;
        }

        await ref
            .read(sessionProvider.notifier)
            .grant(
              token: value.token,
              session: SignedIn(
                role: Role.accountOwner,
                mode: AppMode.desktopOffline,
                subjectReference: claims.subject,
              ),
            );

        _secret = newSecret;
        _remaining = value.remainingRecoveryCodes;
        state = LocalRecoveryRecovered(remaining: _remaining);
    }
  }

  /// Step 6: re-key the recovery codes.
  Future<void> regenerateCodes() async {
    final secret = _secret;
    if (secret == null) return;

    state = const LocalRecoverySubmitting();

    final result = await ref
        .read(localAccountRepositoryProvider)
        .regenerateRecoveryCodes(secret: secret);

    state = switch (result) {
      // AF-05. Nothing was replaced, so nothing was lost — and saying only
      // "regeneration failed" would leave the user believing otherwise.
      Failure<CreatedLocalAccount>(:final message) =>
        LocalRecoveryRegenerationFailed(reason: message, remaining: _remaining),
      Success<CreatedLocalAccount>(:final value) => LocalRecoveryCodesIssued(
        value,
      ),
    };
  }

  /// `AF-04`: the user declines to re-key, and what remains stands.
  void declineRegeneration() {
    _secret = null;
    state = LocalRecoveryFinished(remaining: _remaining);
  }

  /// The new codes have been kept; the flow is over.
  void confirmCodesKept() {
    if (state is! LocalRecoveryCodesIssued) return;
    _secret = null;
    state = LocalRecoveryFinished(
      remaining:
          (state as LocalRecoveryCodesIssued).account.recoveryCodes.length,
    );
  }
}

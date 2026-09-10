/// Password recovery and address verification (UC-09).
///
/// One controller for four operations, because they share the same shape and
/// the same discipline: submit, then show what the API said.
///
/// `AF-02` is the reason this file branches on almost nothing. A request for an
/// address that belongs to nobody must be indistinguishable from one that
/// worked, and the way to guarantee that is to have no code that could tell
/// them apart — the success path reports the API's confirmation and never
/// inspects it.
///
/// `AF-06` is the other case where wording is the behavior: a rate limit is the
/// API saying "not yet", which is information, not failure. It is presented as
/// what it is rather than dressed up as an error.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/account_recovery_repository.dart';
import 'sign_in_controller.dart' show SignInController;

@immutable
sealed class RecoveryState {
  const RecoveryState();

  bool get isBusy => this is RecoveryWorking;

  String? get message => switch (this) {
    RecoveryInvalid(:final reason) => reason,
    RecoveryRefused(:final reason) => reason,
    RecoveryRateLimited(:final reason) => reason,
    RecoveryDone(:final confirmation) => confirmation,
    RecoveryIdle() || RecoveryWorking() => null,
  };
}

@immutable
final class RecoveryIdle extends RecoveryState {
  const RecoveryIdle();
}

@immutable
final class RecoveryWorking extends RecoveryState {
  const RecoveryWorking();
}

/// `AF-01`, `AF-04`: rejected in the form, nothing submitted.
@immutable
final class RecoveryInvalid extends RecoveryState {
  const RecoveryInvalid(this.reason);

  final String reason;
}

/// `AF-03`, `AF-05`: the API refused, in its own words.
@immutable
final class RecoveryRefused extends RecoveryState {
  const RecoveryRefused(this.reason, {this.canRequestAnother = false});

  final String reason;

  /// `AF-03` offers a fresh token; a refused password does not.
  final bool canRequestAnother;
}

/// `AF-06`: the API said "not yet". Information, not failure.
@immutable
final class RecoveryRateLimited extends RecoveryState {
  const RecoveryRateLimited(this.reason);

  final String reason;
}

/// The API's confirmation, whatever it was. Never inspected (`AF-02`).
@immutable
final class RecoveryDone extends RecoveryState {
  const RecoveryDone(this.confirmation);

  final String confirmation;
}

final accountRecoveryControllerProvider =
    NotifierProvider<AccountRecoveryController, RecoveryState>(
      AccountRecoveryController.new,
    );

class AccountRecoveryController extends Notifier<RecoveryState> {
  @override
  RecoveryState build() => const RecoveryIdle();

  void reset() {
    if (state is! RecoveryIdle && state is! RecoveryWorking) {
      state = const RecoveryIdle();
    }
  }

  /// Steps 1-3. The confirmation is the API's, and it says the same thing
  /// whether or not the address exists.
  Future<void> requestPasswordRecovery(String email) async {
    if (!SignInController.isPlausibleEmail(email)) {
      state = const RecoveryInvalid(
        'Enter the email address for your account.',
      );
      return;
    }

    state = const RecoveryWorking();

    final result = await ref
        .read(accountRecoveryRepositoryProvider)
        .requestPasswordRecovery(email.trim());

    state = switch (result) {
      // AF-02 lives here, in what is *not* written: nothing looks at whether
      // the address was known, because nothing may.
      Success<String>(:final value) => RecoveryDone(value),
      Failure<String>(:final message, :final kind) =>
        kind == FailureKind.conflict
            ? RecoveryRateLimited(message)
            : RecoveryRefused(message),
    };
  }

  /// Steps 4-6.
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmation,
  }) async {
    if (token.trim().isEmpty) {
      state = const RecoveryRefused(
        'This reset link is incomplete. Request a new one.',
        canRequestAnother: true,
      );
      return;
    }
    if (newPassword.isEmpty) {
      state = const RecoveryInvalid('Choose a new password.');
      return;
    }
    // AF-04 — before anything is submitted.
    if (newPassword != confirmation) {
      state = const RecoveryInvalid('The two passwords do not match.');
      return;
    }

    state = const RecoveryWorking();

    final result = await ref
        .read(accountRecoveryRepositoryProvider)
        .resetPassword(token: token.trim(), newPassword: newPassword);

    state = switch (result) {
      Success<String>(:final value) => RecoveryDone(value),
      // AF-03 against AF-05. A dead token can be replaced; a password the API
      // refused cannot be fixed by asking for another link, and offering one
      // would send the user round a loop that changes nothing.
      Failure<String>(:final message, :final kind) => RecoveryRefused(
        message,
        canRequestAnother:
            kind == FailureKind.notFound || kind == FailureKind.unauthenticated,
      ),
    };
  }

  /// Step 7.
  Future<void> verifyEmail(String token) async {
    if (token.trim().isEmpty) {
      state = const RecoveryRefused(
        'This verification link is incomplete. Request a new one.',
        canRequestAnother: true,
      );
      return;
    }

    state = const RecoveryWorking();

    final result = await ref
        .read(accountRecoveryRepositoryProvider)
        .verifyEmail(token.trim());

    state = switch (result) {
      Success<String>(:final value) => RecoveryDone(value),
      Failure<String>(:final message) => RecoveryRefused(
        message,
        // AF-03: a verification token that is dead can always be replaced.
        canRequestAnother: true,
      ),
    };
  }

  /// Asks for the verification message again.
  Future<void> resendVerification() async {
    state = const RecoveryWorking();

    final result = await ref
        .read(accountRecoveryRepositoryProvider)
        .resendVerification();

    state = switch (result) {
      Success<String>(:final value) => RecoveryDone(value),
      // AF-06. A rate limit is the API saying "not yet" — that is an answer,
      // and presenting it as a failure would tell the user something went
      // wrong when nothing did.
      Failure<String>(:final message, :final kind) =>
        kind == FailureKind.conflict || kind == FailureKind.forbidden
            ? RecoveryRateLimited(message)
            : RecoveryRefused(message),
    };
  }
}

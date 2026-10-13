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
    RecoveryNeedsPassword(:final message) => message,
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

/// A sign-up link is good, and the password chosen at sign-up is wanted before
/// the account is created. [message] is the question; [error] is the API's
/// verdict on the last password tried, if any.
@immutable
final class RecoveryNeedsPassword extends RecoveryState {
  const RecoveryNeedsPassword(this.message, {this.error});

  @override
  final String message;
  final String? error;
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

    state = _afterVerification(result, prompt: null);
  }

  /// Finishes a sign-up: the link is good, and the password chosen when
  /// signing up is the last thing standing between it and an account.
  ///
  /// The password is passed through and never stored; only the prompt and the
  /// API's verdict on the last attempt are kept in state.
  Future<void> confirmRegistration({
    required String token,
    required String password,
  }) async {
    final current = state;
    final prompt = current is RecoveryNeedsPassword
        ? current.message
        : _defaultPasswordPrompt;

    if (password.isEmpty) {
      state = RecoveryNeedsPassword(prompt, error: 'Enter your password.');
      return;
    }

    state = const RecoveryWorking();

    final result = await ref
        .read(accountRecoveryRepositoryProvider)
        .verifyEmail(token.trim(), password: password);

    state = _afterVerification(result, prompt: prompt);
  }

  static const _defaultPasswordPrompt =
      'Enter the password you chose when you signed up to finish creating '
      'your account.';

  /// Appended to a refused link, because the same endpoint serves both an
  /// address change and a sign-up and the API's wording cannot say which.
  static const _signUpHint =
      'If this link came from signing up, sign up again — or sign in if you '
      'already finished.';

  /// [prompt] is the question already on screen, kept when the answer is a
  /// wrong password so that a retry does not replace it.
  RecoveryState _afterVerification(
    Result<VerifyEmailAnswer> result, {
    required String? prompt,
  }) => switch (result) {
    Success<VerifyEmailAnswer>(:final value) => switch (value) {
      VerifyEmailConfirmed(:final message) => RecoveryDone(message),
      VerifyEmailPasswordNeeded(:final message) => RecoveryNeedsPassword(
        message,
      ),
      // Without a password in the request the API cannot say "wrong"; if it
      // does anyway, asking again is still the right response.
      VerifyEmailPasswordWrong(:final message) =>
        prompt == null
            ? RecoveryNeedsPassword(message)
            : RecoveryNeedsPassword(prompt, error: message),
    },
    Failure<VerifyEmailAnswer>(:final message) => RecoveryRefused(
      '$message $_signUpHint',
      // AF-03: a verification token that is dead can always be replaced.
      canRequestAnother: true,
    ),
  };

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

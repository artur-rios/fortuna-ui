/// The sign-up form's decision-making (UC-47).
///
/// The same two rules as sign-in: the password is never held — it arrives as
/// an argument, goes to the repository and is gone — and the API's answer is
/// never interpreted. A free and a taken address get the same reply from the
/// API, and this controller shows that reply as it came.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/registration_repository.dart';
import 'sign_in_controller.dart';

/// Which field a client-side refusal is about, so it can be shown under it.
enum SignUpField { name, email, password }

/// Where the sign-up form is in its work.
@immutable
sealed class SignUpState {
  const SignUpState();

  bool get isBusy => this is SignUpSubmitting;

  /// The text to show, or `null` when there is nothing to say.
  String? get message => switch (this) {
    SignUpInvalid(:final reason) => reason,
    SignUpRefused(:final reason) => reason,
    SignUpUnreachable(:final reason) => reason,
    SignUpAccepted(:final message) => message,
    SignUpReady() || SignUpSubmitting() => null,
  };
}

/// Nothing has been submitted.
@immutable
final class SignUpReady extends SignUpState {
  const SignUpReady();
}

/// The API has not yet answered.
@immutable
final class SignUpSubmitting extends SignUpState {
  const SignUpSubmitting();
}

/// `AF-01`: rejected in the form, nothing submitted.
@immutable
final class SignUpInvalid extends SignUpState {
  const SignUpInvalid(this.field, this.reason);

  final SignUpField field;
  final String reason;
}

/// `AF-02`, `AF-03`: the API refused, and its message is what is shown.
@immutable
final class SignUpRefused extends SignUpState {
  const SignUpRefused(this.reason);

  final String reason;
}

/// `AF-04`: the instance, or the identity service behind it, could not be
/// reached. A retry is offered.
@immutable
final class SignUpUnreachable extends SignUpState {
  const SignUpUnreachable(this.reason);

  final String reason;
}

/// The API accepted the request. Whether an account was created is not
/// something this client is told (`AF-02`).
@immutable
final class SignUpAccepted extends SignUpState {
  const SignUpAccepted(this.message);

  @override
  final String message;
}

final signUpControllerProvider =
    NotifierProvider<SignUpController, SignUpState>(SignUpController.new);

class SignUpController extends Notifier<SignUpState> {
  /// Heimdall's limits (UC-47). Feedback only; the API decides.
  static const maximumNameLength = 200;
  static const maximumEmailLength = 256;
  static const minimumPasswordLength = 8;

  @override
  SignUpState build() => const SignUpReady();

  /// Clears a refusal, so a correction is not masked by the complaint about
  /// what it corrected. An accepted request stays accepted.
  void reset() {
    if (state is SignUpInvalid ||
        state is SignUpRefused ||
        state is SignUpUnreachable) {
      state = const SignUpReady();
    }
  }

  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedName = name.trim();

    // AF-01 — before anything is submitted.
    if (trimmedName.isEmpty) {
      state = const SignUpInvalid(SignUpField.name, 'Enter your name.');
      return;
    }
    if (trimmedName.length > maximumNameLength) {
      state = const SignUpInvalid(
        SignUpField.name,
        'Use a name of $maximumNameLength characters or fewer.',
      );
      return;
    }
    if (!SignInController.isPlausibleEmail(email)) {
      state = const SignUpInvalid(
        SignUpField.email,
        'Enter the email address you want to sign in with.',
      );
      return;
    }
    if (email.trim().length > maximumEmailLength) {
      state = const SignUpInvalid(
        SignUpField.email,
        'Use an email address of $maximumEmailLength characters or fewer.',
      );
      return;
    }
    if (password.length < minimumPasswordLength) {
      state = const SignUpInvalid(
        SignUpField.password,
        'Use a password of at least $minimumPasswordLength characters.',
      );
      return;
    }

    state = const SignUpSubmitting();

    final result = await ref
        .read(registrationRepositoryProvider)
        .register(name: trimmedName, email: email.trim(), password: password);
    if (!ref.mounted) return;

    state = switch (result) {
      Success(:final value) => SignUpAccepted(value),
      // A 503 is Heimdall being down behind a reachable instance — as worth
      // retrying as an instance that did not answer at all.
      Failure(:final message, kind: FailureKind.unreachable) ||
      Failure(
        :final message,
        kind: FailureKind.serverError,
      ) => SignUpUnreachable(message),
      Failure(:final message) => SignUpRefused(message),
    };
  }
}

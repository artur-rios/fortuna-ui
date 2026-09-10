/// Creating the desktop local account (UC-06).
///
/// The screen has two halves and the state machine says which one is showing:
/// a form until the account exists, then the recovery codes until the user
/// confirms they have kept them. They are shown **once**, and this is the only
/// place they are ever held — nothing writes them anywhere.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/config/instance_config.dart';
import '../../../core/result/result.dart';
import '../../../core/session/session.dart';
import '../data/local_account_repository.dart';

@immutable
sealed class LocalAccountState {
  const LocalAccountState();

  bool get isBusy => this is LocalAccountCreating;

  String? get message => switch (this) {
    LocalAccountInvalid(:final reason) => reason,
    LocalAccountRefused(:final reason) => reason,
    LocalAccountUnavailable(:final reason) => reason,
    LocalAccountReady() ||
    LocalAccountCreating() ||
    LocalAccountCodesShown() ||
    LocalAccountConfirmed() => null,
  };
}

/// The form is showing and nothing has been attempted.
@immutable
final class LocalAccountReady extends LocalAccountState {
  const LocalAccountReady();
}

@immutable
final class LocalAccountCreating extends LocalAccountState {
  const LocalAccountCreating();
}

/// `AF-01`: a missing name or secret, rejected in the form.
@immutable
final class LocalAccountInvalid extends LocalAccountState {
  const LocalAccountInvalid(this.reason);

  final String reason;
}

/// `AF-02`, `AF-03`, `AF-05`: the core refused, in its own words.
@immutable
final class LocalAccountRefused extends LocalAccountState {
  const LocalAccountRefused(this.reason);

  final String reason;
}

/// Creation is not offered at all: this installation is not in desktop offline
/// mode, so there is no local identity to create.
@immutable
final class LocalAccountUnavailable extends LocalAccountState {
  const LocalAccountUnavailable(this.reason);

  final String reason;
}

/// Main-flow step 5. The codes are on screen, and this is the only time they
/// will be.
@immutable
final class LocalAccountCodesShown extends LocalAccountState {
  const LocalAccountCodesShown(this.account);

  final CreatedLocalAccount account;
}

/// The user confirmed they kept the codes; sign-in follows.
@immutable
final class LocalAccountConfirmed extends LocalAccountState {
  const LocalAccountConfirmed();
}

final localAccountControllerProvider =
    NotifierProvider<LocalAccountController, LocalAccountState>(
      LocalAccountController.new,
    );

class LocalAccountController extends Notifier<LocalAccountState> {
  @override
  LocalAccountState build() => const LocalAccountReady();

  void reset() {
    if (state is LocalAccountInvalid || state is LocalAccountRefused) {
      state = const LocalAccountReady();
    }
  }

  Future<void> create({
    required String displayName,
    required String secret,
  }) async {
    // Creating a local account outside desktop offline mode would be creating
    // an identity nothing signs in as.
    if (ref.read(instanceConfigProvider).mode != AppMode.desktopOffline) {
      state = const LocalAccountUnavailable(
        'A local account belongs to a desktop offline installation. '
        'This one signs in against an instance.',
      );
      return;
    }

    // AF-01 — before anything reaches the core.
    if (displayName.trim().isEmpty) {
      state = const LocalAccountInvalid('Enter a name for this account.');
      return;
    }
    if (secret.isEmpty) {
      state = const LocalAccountInvalid('Enter a secret for this account.');
      return;
    }

    state = const LocalAccountCreating();

    final result = await ref
        .read(localAccountRepositoryProvider)
        .create(displayName: displayName.trim(), secret: secret);

    state = switch (result) {
      // AF-02, AF-03, AF-05: the core's reason, unaltered. An account that
      // already exists, a credential store that will not open and local
      // accounts being disabled are all its to state, not this client's to
      // guess at — and none of them leaves a half-configured account, because
      // the core either created one or did not.
      Failure<CreatedLocalAccount>(:final message) => LocalAccountRefused(
        message,
      ),
      Success<CreatedLocalAccount>(:final value) => LocalAccountCodesShown(
        value,
      ),
    };
  }

  /// Main-flow step 6: the user says they have kept the codes.
  ///
  /// Nothing verifies that they did — nothing can. What this does guarantee is
  /// that the codes leave memory here and are never shown again.
  void confirmCodesKept() {
    if (state is! LocalAccountCodesShown) return;
    state = const LocalAccountConfirmed();
  }
}

/// Managing two-factor authentication (UC-10).
///
/// The state machine is the use case: idle with a status, a pending setup, the
/// recovery codes once, and back to idle.
///
/// `AF-02` is enforced by that shape rather than by a flag. A pending setup is
/// a state of *this screen*, not of the account — the account is whatever the
/// API last said it was. Abandoning the screen therefore leaves two-factor off,
/// because nothing ever recorded it as on.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/two_factor_repository.dart';

@immutable
sealed class TwoFactorState {
  const TwoFactorState();

  bool get isBusy => this is TwoFactorWorking;

  String? get message => switch (this) {
    TwoFactorUnavailable(:final reason) => reason,
    TwoFactorFailed(:final reason) => reason,
    TwoFactorPending(:final reason) => reason,
    _ => null,
  };
}

@immutable
final class TwoFactorLoading extends TwoFactorState {
  const TwoFactorLoading();
}

@immutable
final class TwoFactorWorking extends TwoFactorState {
  const TwoFactorWorking();
}

/// The account's configuration, as the API reports it.
@immutable
final class TwoFactorIdle extends TwoFactorState {
  const TwoFactorIdle(this.status);

  final TwoFactorStatus status;
}

/// `AF-05`: this account cannot hold a second factor, and the API said why.
@immutable
final class TwoFactorUnavailable extends TwoFactorState {
  const TwoFactorUnavailable(this.reason);

  final String reason;
}

/// A setup awaiting its first code. `AF-01` keeps the user here.
@immutable
final class TwoFactorPending extends TwoFactorState {
  const TwoFactorPending({required this.setup, this.reason});

  final TwoFactorSetup setup;

  /// Why the last confirmation attempt failed, where one did.
  final String? reason;
}

/// The codes, once (`FR-SE-14`).
@immutable
final class TwoFactorCodesIssued extends TwoFactorState {
  const TwoFactorCodesIssued(this.codes);

  final List<String> codes;
}

/// An operation the API refused, in its own words.
@immutable
final class TwoFactorFailed extends TwoFactorState {
  const TwoFactorFailed(this.reason, this.status);

  final String reason;

  /// Carried so the screen still shows where the account stands.
  final TwoFactorStatus? status;
}

final twoFactorControllerProvider =
    NotifierProvider<TwoFactorController, TwoFactorState>(
      TwoFactorController.new,
    );

class TwoFactorController extends Notifier<TwoFactorState> {
  @override
  TwoFactorState build() => const TwoFactorLoading();

  TwoFactorStatus? _status;

  Future<void> load() async {
    state = const TwoFactorLoading();

    final result = await ref.read(twoFactorRepositoryProvider).status();

    switch (result) {
      case Success<TwoFactorStatus>(:final value):
        _status = value;
        state = TwoFactorIdle(value);

      // AF-05. The API's reason, rather than a setup this account cannot use.
      case Failure<TwoFactorStatus>(:final message, :final kind):
        state = kind == FailureKind.forbidden || kind == FailureKind.conflict
            ? TwoFactorUnavailable(message)
            : TwoFactorFailed(message, null);
    }
  }

  /// Step 2: start a setup.
  Future<void> enable(List<TwoFactorMethod> methods) async {
    if (methods.isEmpty) {
      state = TwoFactorFailed('Choose at least one method.', _status);
      return;
    }

    state = const TwoFactorWorking();

    final result = await ref.read(twoFactorRepositoryProvider).enable(methods);

    state = switch (result) {
      Success<TwoFactorSetup>(:final value) => TwoFactorPending(setup: value),
      Failure<TwoFactorSetup>(:final message) => TwoFactorFailed(
        message,
        _status,
      ),
    };
  }

  /// Steps 4-5: confirm the pending setup.
  Future<void> confirm({String? appCode, String? emailCode}) async {
    final pending = state;
    if (pending is! TwoFactorPending) return;

    if ((appCode?.trim().isEmpty ?? true) &&
        (emailCode?.trim().isEmpty ?? true)) {
      state = TwoFactorPending(
        setup: pending.setup,
        reason: 'Enter the code from your authenticator or your email.',
      );
      return;
    }

    state = const TwoFactorWorking();

    final result = await ref
        .read(twoFactorRepositoryProvider)
        .confirm(appCode: appCode?.trim(), emailCode: emailCode?.trim());

    switch (result) {
      case Success<List<String>>(:final value):
        state = TwoFactorCodesIssued(value);

      // AF-01: the setup is still pending, and the user may try again. The
      // screen returns to exactly where it was, carrying the reason.
      case Failure<List<String>>(:final message):
        state = TwoFactorPending(setup: pending.setup, reason: message);
    }
  }

  /// `AF-02`: the user walks away from a pending setup.
  ///
  /// Nothing needs undoing, because nothing was recorded. The status is simply
  /// re-read, and it will say two-factor is off.
  Future<void> abandonSetup() => load();

  /// Step 6: turn it off.
  Future<void> disable({
    required String password,
    String? code,
    String? recoveryCode,
  }) async {
    state = const TwoFactorWorking();

    final result = await ref
        .read(twoFactorRepositoryProvider)
        .disable(
          password: password,
          code: code?.trim(),
          recoveryCode: recoveryCode?.trim(),
        );

    switch (result) {
      case Success<void>():
        await load();

      // AF-03 and AF-04: one message, whichever it was.
      case Failure<void>(:final message):
        state = TwoFactorFailed(message, _status);
    }
  }

  /// Step 6: replace the codes.
  Future<void> regenerateCodes({String? code, String? recoveryCode}) async {
    state = const TwoFactorWorking();

    final result = await ref
        .read(twoFactorRepositoryProvider)
        .regenerateRecoveryCodes(
          code: code?.trim(),
          recoveryCode: recoveryCode?.trim(),
        );

    state = switch (result) {
      Success<List<String>>(:final value) => TwoFactorCodesIssued(value),
      Failure<List<String>>(:final message) => TwoFactorFailed(
        message,
        _status,
      ),
    };
  }

  /// The codes have been kept; back to the configuration.
  Future<void> confirmCodesKept() => load();
}

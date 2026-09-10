/// The setup screen's decision-making (UC-01, steps 4-7).
///
/// Ordered so that each alternative flow is refused as early as it can be: the
/// form rejects a malformed address without a request (`AF-01`), an instance
/// that cannot be reached is reported without being persisted (`AF-02`), and an
/// instance that answers with the wrong contract is refused before the
/// application is pointed at it (`AF-05`).
///
/// Nothing about a successful probe is remembered. `AF-06` asks that a lost
/// connection be reported as one rather than papered over with what was true
/// earlier, and the way to guarantee that is to have nothing earlier to serve:
/// every attempt asks the instance again.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/config/api_contract.dart';
import '../../../core/config/instance_config.dart';
import '../../../core/result/result.dart';
import '../data/instance_probe.dart';

/// Where the setup screen is in its work.
@immutable
sealed class SetupState {
  const SetupState();

  /// Whether the form should be disabled while something is in flight.
  bool get isBusy => this is SetupChecking;

  /// The message to show, or `null` when there is nothing to say.
  String? get message => switch (this) {
    SetupRejected(:final reason) => reason,
    SetupUnreachable(:final reason) => reason,
    SetupOfflineUnavailable(:final reason) => reason,
    SetupIncompatible() => null,
    SetupIdle() || SetupChecking() || SetupComplete() => null,
  };
}

/// Nothing has been attempted yet.
@immutable
final class SetupIdle extends SetupState {
  const SetupIdle();
}

/// An instance is being asked who it is.
@immutable
final class SetupChecking extends SetupState {
  const SetupChecking();
}

/// `AF-01`: the address is not a well-formed URL, and no request was made.
@immutable
final class SetupRejected extends SetupState {
  const SetupRejected(this.reason);

  final String reason;
}

/// `AF-02`, and `AF-06` on a later attempt: nobody answered, and the address
/// was not persisted.
@immutable
final class SetupUnreachable extends SetupState {
  const SetupUnreachable(this.reason);

  final String reason;
}

/// `AF-05`: the instance answered, and speaks a contract this build does not.
@immutable
final class SetupIncompatible extends SetupState {
  const SetupIncompatible({required this.compatibility, required this.service});

  final ContractCompatibility compatibility;

  /// What the instance called itself, if it said.
  final String? service;
}

/// `AF-04`: the core library is there and will not load.
@immutable
final class SetupOfflineUnavailable extends SetupState {
  const SetupOfflineUnavailable(this.reason);

  final String reason;
}

/// The instance and mode are resolved and persisted.
@immutable
final class SetupComplete extends SetupState {
  const SetupComplete();
}

final setupControllerProvider = NotifierProvider<SetupController, SetupState>(
  SetupController.new,
);

class SetupController extends Notifier<SetupState> {
  @override
  SetupState build() => const SetupIdle();

  /// Returns the screen to a state where the form is editable again.
  ///
  /// Called as the user types: a rejection that stays on screen while its cause
  /// is being corrected reads as though the correction did not work.
  void reset() {
    if (state is! SetupIdle && state is! SetupChecking) {
      state = const SetupIdle();
    }
  }

  /// Steps 5 to 7 for a supplied address.
  Future<void> useAddress(String raw) async {
    final address = raw.trim();

    // AF-01 — before any request is attempted.
    if (!InstanceConfigController.isWellFormedAddress(address)) {
      state = const SetupRejected(
        'Enter a full address, including http:// or https:// — '
        'for example https://fortuna.example.',
      );
      return;
    }

    state = const SetupChecking();

    final result = await ref.read(instanceProbeProvider).probe(address);

    switch (result) {
      // AF-02 and AF-06: reported, and deliberately not persisted.
      case Failure<InstanceIdentity>(:final message):
        state = SetupUnreachable(message);

      case Success<InstanceIdentity>(:final value):
        final compatibility = value.compatibility;

        // AF-05: refused here rather than allowed to fail later somewhere that
        // would not explain itself.
        if (!compatibility.isCompatible) {
          state = SetupIncompatible(
            compatibility: compatibility,
            service: value.service,
          );
          return;
        }

        await ref.read(instanceConfigProvider.notifier).useInstance(address);
        state = const SetupComplete();
    }
  }

  /// Step 6 for desktop offline mode.
  ///
  /// The option is not offered where it cannot work (`AF-03`), and this refuses
  /// it again rather than trusting that — the two checks are cheap and the
  /// failure they prevent is an application talking to nothing.
  void useOfflineMode() {
    final instance = ref.read(instanceConfigProvider);

    if (instance.offlineFailed) {
      // AF-04: name what happened, and leave the connected paths on offer.
      state = const SetupOfflineUnavailable(
        'This installation carries the Fortuna core but it could not be '
        'loaded, so offline mode is unavailable. Connect to an instance '
        'instead.',
      );
      return;
    }

    if (!ref.read(instanceConfigProvider.notifier).useOfflineMode()) {
      state = const SetupOfflineUnavailable(
        'This installation cannot run offline. Connect to an instance '
        'instead.',
      );
      return;
    }

    state = const SetupComplete();
  }
}

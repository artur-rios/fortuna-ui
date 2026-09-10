/// Consents, and who controls the data (UC-42).
///
/// Two things this file is careful about.
///
/// **Nothing is assumed on failure.** `AF-06`: if the consent list cannot be
/// read, no feature that needs a consent may proceed — so the failure is a
/// state of its own, and [ConsentController.permits] answers false for
/// everything rather than defaulting to permissive.
///
/// **A withdrawal states its cost first.** `AF-02`: the connections that depend
/// on the consent are named before the confirmation, along with the fact that
/// imported data is kept. That is why withdrawal is two steps here rather than
/// one call.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/config/instance_config.dart';
import '../../../core/result/result.dart';
import '../../../core/session/session.dart';
import '../../ingestion/data/connection_repository.dart';
import '../data/consent_repository.dart';

/// Who is responsible for the data in this deployment (`FR-PR-09`).
enum DataController {
  /// A shared instance: the operator is the controller, and there is a privacy
  /// notice and a rights route to surface (`FR-PR-10`).
  operator,

  /// Self-hosted or offline: the user runs the instance, so the user is the
  /// controller. Implying an operator privacy notice here would be inventing a
  /// third party that does not exist (`AF-05`).
  theUser;

  static DataController forMode(AppMode mode) => switch (mode) {
    AppMode.connected => DataController.operator,
    AppMode.selfHosted || AppMode.desktopOffline => DataController.theUser,
  };

  /// Whether an operator's privacy notice and rights route apply.
  bool get hasOperatorNotice => this == DataController.operator;
}

@immutable
sealed class ConsentsState {
  const ConsentsState();
}

@immutable
final class ConsentsLoading extends ConsentsState {
  const ConsentsLoading();
}

@immutable
final class ConsentsReady extends ConsentsState {
  const ConsentsReady(this.consents, {this.notice});

  final List<Consent> consents;

  /// Something to say about the last action, where there is.
  final String? notice;

  Consent? forPurpose(String purpose) {
    for (final consent in consents) {
      if (consent.purpose == purpose) return consent;
    }
    return null;
  }
}

/// `AF-06`: the list could not be read, so nothing is known.
@immutable
final class ConsentsUnavailable extends ConsentsState {
  const ConsentsUnavailable(this.reason);

  final String reason;
}

/// What withdrawing a consent will cost, gathered before it is confirmed.
@immutable
class WithdrawalConsequences {
  const WithdrawalConsequences({
    required this.purpose,
    required this.connections,
  });

  final String purpose;

  /// The live connections that depend on this consent (`AF-02`).
  final List<Connection> connections;

  bool get revokesConnections => connections.isNotEmpty;
}

final consentControllerProvider =
    NotifierProvider<ConsentController, ConsentsState>(ConsentController.new);

class ConsentController extends Notifier<ConsentsState> {
  @override
  ConsentsState build() => const ConsentsLoading();

  /// Who the controller is for this deployment (`FR-PR-09`, `AF-05`).
  DataController get controller =>
      DataController.forMode(ref.read(instanceConfigProvider).mode);

  Future<void> load() async {
    state = const ConsentsLoading();

    final result = await ref.read(consentRepositoryProvider).list();

    state = switch (result) {
      Success<List<Consent>>(:final value) => ConsentsReady(value),
      // AF-06. Not an empty list: an empty list is a claim that the user has
      // consented to nothing, and this is the absence of a claim.
      Failure<List<Consent>>(:final message) => ConsentsUnavailable(message),
    };
  }

  /// Whether [purpose] may proceed.
  ///
  /// False while loading, false on failure, false for an outdated consent.
  /// Every uncertain answer is a refusal, which is the only safe direction for
  /// a question like this one (`FR-PR-01`, `FR-PR-02`, `AF-06`).
  bool permits(String purpose) {
    final current = state;
    if (current is! ConsentsReady) return false;

    return current.forPurpose(purpose)?.permits ?? false;
  }

  /// Step 4: record a decision, always against a version.
  Future<void> grant({required String purpose, required String version}) async {
    if (version.isEmpty) {
      // A consent with no version is not a consent to anything in particular,
      // and recording one would make AF-01 unenforceable later.
      state = const ConsentsUnavailable(
        'This instance did not say which version of the disclosure it is '
        'asking about, so nothing was recorded.',
      );
      return;
    }

    final result = await ref
        .read(consentRepositoryProvider)
        .grant(purpose: purpose, version: version);

    switch (result) {
      case Success<void>():
        await load();
      case Failure<void>(:final message):
        _note(message);
    }
  }

  /// `AF-04`: the user read the disclosure and said no.
  ///
  /// Nothing is recorded, deliberately — a declined disclosure is not a
  /// withdrawal, and writing anything would be inferring a decision the user
  /// did not make (`FR-PR-02`).
  void decline(String purpose) => _note(
    'Nothing was recorded. The features that need this consent stay '
    'unavailable until you give it.',
  );

  /// Step 5, first half: find out what withdrawing costs before asking.
  Future<WithdrawalConsequences> consequencesOfWithdrawing(
    String purpose,
  ) async {
    final result = await ref.read(connectionRepositoryProvider).list();

    return WithdrawalConsequences(
      purpose: purpose,
      connections: switch (result) {
        Success<List<Connection>>(:final value) => [
          for (final connection in value)
            if (!connection.isRevoked) connection,
        ],
        // A connection list that cannot be read is not evidence there are
        // none. The screen still warns in general terms rather than promising
        // nothing will be revoked.
        Failure<List<Connection>>() => const [],
      },
    );
  }

  /// Step 5-6: withdraw, once the user has confirmed knowing the cost.
  Future<void> withdraw(String purpose) async {
    final result = await ref.read(consentRepositoryProvider).withdraw(purpose);

    switch (result) {
      case Success<void>():
        await load();
      // AF-03: withdrawing what was never given, in the API's words.
      case Failure<void>(:final message):
        _note(message);
    }
  }

  void _note(String message) {
    final current = state;
    if (current is ConsentsReady) {
      state = ConsentsReady(current.consents, notice: message);
    } else {
      state = ConsentsUnavailable(message);
    }
  }
}

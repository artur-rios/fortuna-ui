/// Erasing the account (UC-44).
///
/// The confirmation is deliberately unlike every other confirmation in this
/// application. Deleting a record is a dialog with a Delete button, and it can
/// be undone from the deleted-records screen. This cannot be undone by anyone,
/// so `FR-PR-07` asks for a confirmation *distinct* from that — here, typing
/// the word the API itself demands. Nobody types ERASE by muscle memory.
///
/// `AF-02` shapes the failure path. The API erases everything or nothing, so a
/// failure means the account is intact — and the message says exactly that,
/// because a user who has just tried to erase their account and seen an error
/// has no way to guess which it was.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_controller.dart';
import '../../ingestion/data/connection_repository.dart';
import '../data/erasure_repository.dart';

@immutable
sealed class ErasureState {
  const ErasureState();

  String? get message => switch (this) {
    ErasureRefused(:final reason) => reason,
    _ => null,
  };
}

/// Nothing has been started.
@immutable
final class ErasureIdle extends ErasureState {
  const ErasureIdle();
}

/// Step 2-4: the consequences are on screen and the confirmation is awaited.
@immutable
final class ErasureConfirming extends ErasureState {
  const ErasureConfirming({required this.liveConnections});

  /// `AF-04`: named before the confirmation, because revoking them is part of
  /// what the user is agreeing to.
  final List<Connection> liveConnections;

  bool get revokesConnections => liveConnections.isNotEmpty;
}

@immutable
final class ErasureWorking extends ErasureState {
  const ErasureWorking();
}

/// `AF-02`, `AF-03`: nothing was erased, and the account is intact.
@immutable
final class ErasureRefused extends ErasureState {
  const ErasureRefused(this.reason);

  final String reason;
}

/// Step 6: what went, before the session ends.
@immutable
final class ErasureDone extends ErasureState {
  const ErasureDone(this.report);

  final ErasureReport report;
}

final erasureControllerProvider =
    NotifierProvider<ErasureController, ErasureState>(ErasureController.new);

class ErasureController extends Notifier<ErasureState> {
  @override
  ErasureState build() => const ErasureIdle();

  /// Whether [typed] is the confirmation the API will accept.
  ///
  /// Compared exactly. Accepting "erase" here and upper-casing it before
  /// sending would be completing a confirmation the user did not give.
  static bool isConfirmed(String typed) =>
      typed == HttpErasureRepository.requiredConfirmation;

  /// The word the screen asks the user to type.
  static String get requiredWord => HttpErasureRepository.requiredConfirmation;

  /// Steps 1-2: gather what erasure will cost, and show it.
  Future<void> begin() async {
    final connections = await ref.read(connectionRepositoryProvider).list();

    state = ErasureConfirming(
      liveConnections: switch (connections) {
        Success<List<Connection>>(:final value) => [
          for (final connection in value)
            if (!connection.isRevoked) connection,
        ],
        // A list that cannot be read is not evidence there are none; the
        // screen warns in general terms instead.
        Failure<List<Connection>>() => const [],
      },
    );
  }

  /// `AF-01`: the user backs out. Nothing was erased because nothing was sent.
  void cancel() => state = const ErasureIdle();

  /// Step 5: submit it.
  ///
  /// Refuses anything but the exact confirmation, so a caller cannot erase an
  /// account by passing a truthy value.
  Future<void> erase(String confirmation) async {
    if (!isConfirmed(confirmation)) {
      state = ErasureRefused(
        'Type $requiredWord exactly to confirm. Nothing has been erased.',
      );
      return;
    }

    state = const ErasureWorking();

    final result = await ref
        .read(erasureRepositoryProvider)
        .erase(confirmation);

    switch (result) {
      case Success<ErasureReport>(:final value):
        state = ErasureDone(value);

      // AF-02 and AF-03. The API rolls back entirely, so the account is
      // intact — and the user is told that, not just that something failed.
      case Failure<ErasureReport>(:final message):
        state = ErasureRefused(
          '$message Nothing was erased and your account is intact.',
        );
    }
  }

  /// Step 6, second half: end the session and clear everything local.
  ///
  /// Separate from [erase] so the report can be read before the application
  /// returns to sign-in. The token is worthless now regardless, which is why
  /// this uses the path that ends a session even if the store misbehaves.
  Future<void> finish() async {
    await ref
        .read(sessionProvider.notifier)
        .rejectedByApi(
          reason: 'Your account was erased. Nothing of it remains here.',
        );
  }
}

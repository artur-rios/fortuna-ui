/// Credit card statement state (UC-16).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/statement_repository.dart';
import 'account_providers.dart';
import 'credit_card_providers.dart';

/// A card's billing cycles, most recent first (`FR-HO-06`).
///
/// Keyed by card so two cards open in sequence do not read each other's
/// cycles, and so settling one card's statement re-reads only that card.
final cardStatementsProvider =
    FutureProvider.family<List<CardStatement>, String>(
      retry: (retryCount, error) => null,
      (ref, creditCardId) async {
        ref
            .read(sessionTeardownProvider)
            .register(
              'statements:$creditCardId',
              () async => ref.invalidateSelf(),
            );

        final result = await ref
            .read(statementRepositoryProvider)
            .listForCard(creditCardId);

        return switch (result) {
          Success<List<CardStatement>>(:final value) => value,
          Failure<List<CardStatement>>(:final message) =>
            throw StatementsUnavailable(message),
        };
      },
    );

/// One statement and its charges.
final statementProvider = FutureProvider.family<CardStatement, String>(
  retry: (retryCount, error) => null,
  (ref, statementId) async {
    ref
        .read(sessionTeardownProvider)
        .register('statement:$statementId', () async => ref.invalidateSelf());

    final result = await ref
        .read(statementRepositoryProvider)
        .read(statementId);

    return switch (result) {
      Success<CardStatement>(:final value) => value,
      // AF-05 arrives here as the API's own not-found message.
      Failure<CardStatement>(:final message) => throw StatementsUnavailable(
        message,
      ),
    };
  },
);

class StatementsUnavailable implements Exception {
  const StatementsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Closing and settling, each re-reading what it changed.
class StatementActions {
  const StatementActions(this._ref);

  final Ref _ref;

  /// Closing fixes the composition and is presented as irreversible
  /// (`FR-HO-07`). The confirmation lives in the screen; this only performs it.
  Future<Result<void>> close({
    required String statementId,
    required String creditCardId,
  }) => _afterChange(
    creditCardId: creditCardId,
    statementId: statementId,
    call: () => _ref.read(statementRepositoryProvider).close(statementId),
  );

  Future<Result<void>> settle({
    required String statementId,
    required String creditCardId,
    required String financialAccountId,
    required String amount,
    required DateTime paymentDate,
  }) async {
    final result = await _afterChange(
      creditCardId: creditCardId,
      statementId: statementId,
      call: () => _ref
          .read(statementRepositoryProvider)
          .settle(
            statementId: statementId,
            financialAccountId: financialAccountId,
            amount: amount,
            paymentDate: paymentDate,
          ),
    );

    // A settlement moves money: the card owes less and the account holds less.
    // Both were read before this happened, so both are now stale — leaving
    // them would show the user a card they have just paid as still unpaid.
    if (result.isSuccess) {
      _ref
        ..invalidate(creditCardsProvider)
        ..invalidate(accountBalanceProvider(financialAccountId));
    }

    return result;
  }

  Future<Result<void>> _afterChange({
    required String creditCardId,
    required String statementId,
    required Future<Result<void>> Function() call,
  }) async {
    final result = await call();

    if (result.isSuccess) {
      _ref
        ..invalidate(statementProvider(statementId))
        ..invalidate(cardStatementsProvider(creditCardId));
    }

    return result;
  }
}

final statementActionsProvider = Provider<StatementActions>(
  StatementActions.new,
);

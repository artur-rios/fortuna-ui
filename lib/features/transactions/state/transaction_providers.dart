/// One transaction, and the changes that can be made to it (UC-20).
library;

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../holdings/state/account_providers.dart';
import '../../holdings/state/credit_card_providers.dart';
import '../data/transaction_repository.dart';
import 'transaction_form.dart';

/// The transaction behind a detail screen, deleted ones included.
///
/// A deleted transaction is fetched rather than hidden so `AF-05` can offer
/// restoration; reporting it as missing would send the user looking for
/// something that is still there.
final transactionProvider = FutureProvider.family<Transaction, String>(
  retry: (retryCount, error) => null,
  (ref, id) async {
    final result = await ref.read(transactionRepositoryProvider).read(id);

    return switch (result) {
      Success<Transaction>(:final value) => value,
      // AF-02.
      Failure<Transaction>(:final message) => throw TransactionUnavailable(
        message,
      ),
    };
  },
);

class TransactionUnavailable implements Exception {
  const TransactionUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Updating and deleting, each re-reading what it changed.
class TransactionActions {
  const TransactionActions(this._ref);

  final Ref _ref;

  Future<Result<Transaction>> update({
    required String id,
    required DateTime occurredOn,
    required Decimal amount,
    required Direction direction,
    required String categoryId,
    required String currencyCode,
    required HoldingKind holdingKind,
    required String holdingId,
    String? description,
    String? counterparty,
    List<String> tags = const [],
  }) async {
    final result = await _ref
        .read(transactionRepositoryProvider)
        .update(
          id: id,
          occurredOn: occurredOn,
          // The exact decimal, serialized. The only representation that
          // leaves the form.
          amount: amount.toString(),
          direction: direction,
          categoryId: categoryId,
          currencyCode: currencyCode,
          financialAccountId: holdingKind == HoldingKind.account
              ? holdingId
              : null,
          creditCardId: holdingKind == HoldingKind.creditCard
              ? holdingId
              : null,
          description: description,
          counterparty: counterparty,
          tags: tags,
        );

    if (result.isSuccess) _invalidateAffected(id);

    return result;
  }

  Future<Result<void>> delete(String id) async {
    final result = await _ref.read(transactionRepositoryProvider).delete(id);

    if (result.isSuccess) _invalidateAffected(id);

    return result;
  }

  /// Reconciles a transaction (`UC-24`).
  ///
  /// [importedRecordId] and [importJobId] are passed where the API proposed a
  /// match, and omitted where the user is confirming the transaction
  /// themselves — which is `AF-02`, and is a different claim rather than a
  /// lesser one.
  Future<Result<Transaction>> reconcile({
    required String id,
    int? importedRecordId,
    String? importJobId,
  }) async {
    final result = await _ref
        .read(transactionRepositoryProvider)
        .reconcile(
          id: id,
          importedRecordId: importedRecordId,
          importJobId: importJobId,
        );

    // Reconciling changes no figure, so only the transaction is re-read.
    if (result.isSuccess) _ref.invalidate(transactionProvider(id));

    return result;
  }

  /// A transaction moves money, so anything that reported a figure including
  /// it is now stale. Re-reading is cheaper than showing a balance that
  /// disagrees with the record the user is looking at.
  void _invalidateAffected(String id) {
    _ref
      ..invalidate(transactionProvider(id))
      ..invalidate(accountsProvider)
      ..invalidate(creditCardsProvider);
  }
}

final transactionActionsProvider = Provider<TransactionActions>(
  TransactionActions.new,
);

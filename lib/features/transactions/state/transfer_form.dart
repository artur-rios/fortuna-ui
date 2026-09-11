/// The transfer form's rules and its submission (UC-21).
library;

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/money_parser.dart';
import '../../../core/result/result.dart';
import '../../holdings/state/account_providers.dart';
import '../data/transfer_repository.dart';

/// How many accounts a transfer needs before the form is usable (`AF-06`).
const accountsNeededForTransfer = 2;

/// Why a transfer form was refused.
enum TransferProblem {
  /// `AF-02`: not a number at all.
  amountUnreadable,

  /// `AF-02`: readable, but zero or less.
  amountNotPositive,

  /// `AF-01`.
  sameAccount,

  missingOrigin,
  missingDestination,
}

extension TransferProblemMessage on TransferProblem {
  String get message => switch (this) {
    TransferProblem.amountUnreadable =>
      'That amount could not be read. Enter a number.',
    TransferProblem.amountNotPositive =>
      'The amount must be greater than zero.',
    TransferProblem.sameAccount =>
      'Choose two different accounts. Money cannot be transferred to the '
          'account it came from.',
    TransferProblem.missingOrigin => 'Choose the account the money comes from.',
    TransferProblem.missingDestination =>
      'Choose the account the money goes to.',
  };
}

/// The transfer form's validation, as a pure function of what was entered.
abstract final class TransferRules {
  /// Checks what steps 2 and 3 require.
  ///
  /// Deliberately does **not** check whether the two accounts share a
  /// currency. That is `AF-03`, and it is the API's to answer: it may refuse
  /// the pair, or it may convert and say what rate it used. A client guessing
  /// either way would be wrong half the time.
  static TransferProblem? validate({
    required String amountText,
    required String? originAccountId,
    required String? destinationAccountId,
    required MoneyParser parser,
  }) {
    final amount = parser.parse(amountText);

    if (amount == null) return TransferProblem.amountUnreadable;
    if (amount <= Decimal.zero) return TransferProblem.amountNotPositive;

    if (originAccountId == null || originAccountId.isEmpty) {
      return TransferProblem.missingOrigin;
    }
    if (destinationAccountId == null || destinationAccountId.isEmpty) {
      return TransferProblem.missingDestination;
    }

    // Step 3, and AF-01.
    if (originAccountId == destinationAccountId) {
      return TransferProblem.sameAccount;
    }

    return null;
  }
}

/// Submits the transfer.
class TransferActions {
  const TransferActions(this._ref);

  final Ref _ref;

  Future<Result<Transfer>> submit({
    required String originAccountId,
    required String destinationAccountId,
    required Decimal amount,
    required DateTime occurredOn,
  }) async {
    final result = await _ref
        .read(transferRepositoryProvider)
        .record(
          originAccountId: originAccountId,
          destinationAccountId: destinationAccountId,
          // The exact decimal, serialized. The only representation that
          // leaves the form.
          amount: amount.toString(),
          occurredOn: occurredOn,
        );

    // Both accounts moved, so both balances read before this are stale.
    if (result.isSuccess) {
      _ref
        ..invalidate(accountBalanceProvider(originAccountId))
        ..invalidate(accountBalanceProvider(destinationAccountId))
        ..invalidate(accountsProvider);
    }

    return result;
  }
}

final transferActionsProvider = Provider<TransferActions>(TransferActions.new);

/// The recording form's rules and its submission (UC-19).
///
/// The rules live here rather than in the screen so they can be tested without
/// pumping a widget, and so `AF-08` — that the same amount typed under two
/// locales stores the identical value — is provable at the layer where the
/// parsing actually happens.
library;

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/money_parser.dart';
import '../../../core/result/result.dart';
import '../data/transaction_repository.dart';

/// How far ahead a transaction may be dated (`FR-MM-04`, `AF-02`).
///
/// One day, because a purchase made late at night in another time zone is a
/// real transaction that has already happened. Anything beyond that is a
/// commitment or a forecast, which the application models as a recurring rule
/// or a projection rather than as a record of something that occurred.
const maximumDaysAhead = 1;

/// Why a form was refused, at the granularity the screen reports.
enum FormProblem {
  /// `AF-01`: not a number at all.
  amountUnreadable,

  /// `AF-01`: readable, but zero or less.
  amountNotPositive,

  /// `AF-02`.
  dateTooFarAhead,

  /// `AF-03`.
  missingCategory,

  /// `AF-03`.
  missingHolding,
}

/// What the screen says for each refusal. Kept beside the enum so a new
/// problem cannot be added without a sentence to show for it.
extension FormProblemMessage on FormProblem {
  String get message => switch (this) {
    FormProblem.amountUnreadable =>
      'That amount could not be read. Enter a number.',
    FormProblem.amountNotPositive => 'The amount must be greater than zero.',
    FormProblem.dateTooFarAhead =>
      'That date is too far ahead. A movement in the future is a recurring '
          'commitment or a projection, not a transaction that has happened.',
    FormProblem.missingCategory => 'Choose a category.',
    FormProblem.missingHolding => 'Choose the account or card this is on.',
  };
}

/// The form's validation, as a pure function of what was entered.
abstract final class TransactionRules {
  /// Checks everything step 4 requires, in the order a user would fix it.
  ///
  /// [now] is passed rather than read from the clock so the rule is a pure
  /// function a test can pin; this repository has no injected clock.
  static FormProblem? validate({
    required String amountText,
    required DateTime occurredOn,
    required String? categoryId,
    required String? holdingId,
    required MoneyParser parser,
    required DateTime now,
  }) {
    final amount = parser.parse(amountText);

    if (amount == null) return FormProblem.amountUnreadable;
    if (amount <= Decimal.zero) return FormProblem.amountNotPositive;

    if (!isWithinDateLimit(occurredOn, now: now)) {
      return FormProblem.dateTooFarAhead;
    }

    if (categoryId == null || categoryId.isEmpty) {
      return FormProblem.missingCategory;
    }
    if (holdingId == null || holdingId.isEmpty) {
      return FormProblem.missingHolding;
    }

    return null;
  }

  /// Whether [date] is no more than [maximumDaysAhead] beyond today.
  ///
  /// Compared by day rather than by instant, so "tomorrow" means the whole of
  /// tomorrow and not the next twenty-four hours — a transaction dated
  /// tomorrow morning is not more future than one dated tomorrow night.
  static bool isWithinDateLimit(DateTime date, {required DateTime now}) {
    final day = DateTime(date.year, date.month, date.day);
    final limit = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: maximumDaysAhead));

    return !day.isAfter(limit);
  }
}

/// Which holding a transaction is being recorded against.
///
/// A transaction sits on an account **or** on a card, never both — the API
/// takes one id or the other, and offering both at once would let a user
/// build a request the contract cannot express.
enum HoldingKind { account, creditCard }

/// Submits the form. Separate from the rules so a screen can validate without
/// touching the network, and from the repository so the choice of which id to
/// send lives in one place.
class TransactionFormActions {
  const TransactionFormActions(this._ref);

  final Ref _ref;

  Future<Result<Transaction>> submit({
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
  }) => _ref
      .read(transactionRepositoryProvider)
      .record(
        occurredOn: occurredOn,
        // The exact decimal, serialized straight back to a string. This is the
        // only representation that leaves the form.
        amount: amount.toString(),
        direction: direction,
        categoryId: categoryId,
        currencyCode: currencyCode,
        financialAccountId: holdingKind == HoldingKind.account
            ? holdingId
            : null,
        creditCardId: holdingKind == HoldingKind.creditCard ? holdingId : null,
        description: description,
        counterparty: counterparty,
        tags: tags,
      );
}

final transactionFormActionsProvider = Provider<TransactionFormActions>(
  TransactionFormActions.new,
);

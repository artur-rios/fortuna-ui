/// The installment form's rules and its submission (UC-22).
library;

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/money_parser.dart';
import '../../../core/result/result.dart';
import '../../holdings/state/credit_card_providers.dart';
import '../data/installment_repository.dart';

/// The fewest charges a plan can have (`FR-MM-09`, `AF-01`).
///
/// Two, because one charge is simply a transaction — and saying that is more
/// useful than refusing without explaining what the user should do instead.
const minimumInstallments = 2;

/// Why an installment form was refused.
enum InstallmentProblem {
  /// `AF-02`: not a number at all.
  totalUnreadable,

  /// `AF-02`: readable, but zero or less.
  totalNotPositive,

  /// `AF-01`.
  tooFewInstallments,

  missingCard,
  missingCategory,
}

extension InstallmentProblemMessage on InstallmentProblem {
  String get message => switch (this) {
    InstallmentProblem.totalUnreadable =>
      'That total could not be read. Enter a number.',
    InstallmentProblem.totalNotPositive =>
      'The total must be greater than zero.',
    InstallmentProblem.tooFewInstallments =>
      'An installment plan needs at least $minimumInstallments charges. A '
          'single charge is just a transaction — record it as one instead.',
    InstallmentProblem.missingCard => 'Choose the card this was purchased on.',
    InstallmentProblem.missingCategory => 'Choose a category.',
  };
}

/// The installment form's validation, as a pure function of what was entered.
abstract final class InstallmentRules {
  /// Checks what step 3 requires, and nothing more.
  ///
  /// Notably absent: any check that the total divides evenly by the count.
  /// It usually does not, and that is not an error — `AF-04` says the uneven
  /// split the API generates is the correct answer, not a problem to prevent.
  static InstallmentProblem? validate({
    required String totalText,
    required int? installmentCount,
    required String? creditCardId,
    required String? categoryId,
    required MoneyParser parser,
  }) {
    final total = parser.parse(totalText);

    if (total == null) return InstallmentProblem.totalUnreadable;
    if (total <= Decimal.zero) return InstallmentProblem.totalNotPositive;

    if (installmentCount == null || installmentCount < minimumInstallments) {
      return InstallmentProblem.tooFewInstallments;
    }

    if (creditCardId == null || creditCardId.isEmpty) {
      return InstallmentProblem.missingCard;
    }
    if (categoryId == null || categoryId.isEmpty) {
      return InstallmentProblem.missingCategory;
    }

    return null;
  }
}

/// Submits the plan.
class InstallmentActions {
  const InstallmentActions(this._ref);

  final Ref _ref;

  Future<Result<InstallmentPlan>> submit({
    required String creditCardId,
    required String categoryId,
    required Decimal totalAmount,
    required int installmentCount,
    required DateTime purchasedOn,
    required String currencyCode,
    String? counterparty,
  }) async {
    final result = await _ref
        .read(installmentRepositoryProvider)
        .record(
          creditCardId: creditCardId,
          categoryId: categoryId,
          // The exact decimal, serialized. The split is the API's.
          totalAmount: totalAmount.toString(),
          installmentCount: installmentCount,
          purchasedOn: purchasedOn,
          currencyCode: currencyCode,
          counterparty: counterparty,
        );

    // The card now owes more than it did.
    if (result.isSuccess) _ref.invalidate(creditCardsProvider);

    return result;
  }
}

final installmentActionsProvider = Provider<InstallmentActions>(
  InstallmentActions.new,
);

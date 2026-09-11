/// Budget state (UC-28).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/budget_repository.dart';

/// The user's budgets, with the consumption the API computed for each.
final budgetsProvider = FutureProvider<List<Budget>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('budgets', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(budgetRepositoryProvider).list();

    return switch (result) {
      Success<List<Budget>>(:final value) => value,
      Failure<List<Budget>>(:final message) => throw BudgetsUnavailable(
        message,
      ),
    };
  },
);

class BudgetsUnavailable implements Exception {
  const BudgetsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Why a budget form was refused.
enum BudgetProblem {
  /// `AF-01`: not a number at all.
  amountUnreadable,

  /// `AF-01`: readable, but zero or less.
  amountNotPositive,

  /// `AF-02`.
  missingPeriodStart,

  missingCategory,
}

extension BudgetProblemMessage on BudgetProblem {
  String get message => switch (this) {
    BudgetProblem.amountUnreadable =>
      'That amount could not be read. Enter a number.',
    BudgetProblem.amountNotPositive => 'The budget must be greater than zero.',
    BudgetProblem.missingPeriodStart => 'Choose the date the period starts on.',
    BudgetProblem.missingCategory =>
      'Choose at least one category for this budget to cover.',
  };
}

/// What the form checks before anything is submitted (step 3).
abstract final class BudgetRules {
  /// Deliberately only the two rules the specification states. Whether a
  /// budget already covers this category and period is `AF-03`, which only
  /// the API can answer — it is the one party that can see every other
  /// budget.
  static BudgetProblem? validate({
    required String amountText,
    required DateTime? periodStart,
    required List<String> categoryIds,
    required bool Function(String) isPositiveAmount,
    required bool Function(String) isReadableAmount,
  }) {
    if (!isReadableAmount(amountText)) return BudgetProblem.amountUnreadable;
    if (!isPositiveAmount(amountText)) return BudgetProblem.amountNotPositive;
    if (periodStart == null) return BudgetProblem.missingPeriodStart;
    if (categoryIds.isEmpty) return BudgetProblem.missingCategory;

    return null;
  }
}

/// Changes to the budget set, re-reading the list after a confirmed change.
class BudgetActions {
  const BudgetActions(this._ref);

  final Ref _ref;

  Future<Result<void>> create({
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants = false,
  }) => _afterChange(
    () => _ref
        .read(budgetRepositoryProvider)
        .create(
          categoryIds: categoryIds,
          amount: amount,
          currencyCode: currencyCode,
          period: period,
          periodStart: periodStart,
          includeDescendants: includeDescendants,
        ),
  );

  Future<Result<void>> update({
    required String id,
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants = false,
  }) => _afterChange(
    () => _ref
        .read(budgetRepositoryProvider)
        .update(
          id: id,
          categoryIds: categoryIds,
          amount: amount,
          currencyCode: currencyCode,
          period: period,
          periodStart: periodStart,
          includeDescendants: includeDescendants,
        ),
  );

  Future<Result<void>> delete(String id) =>
      _afterChange(() => _ref.read(budgetRepositoryProvider).delete(id));

  Future<Result<void>> _afterChange(
    Future<Result<void>> Function() call,
  ) async {
    final result = await call();
    // The list carries each budget's consumption, so a change to any budget
    // means re-reading the figures the API computed rather than adjusting
    // them here.
    if (result.isSuccess) _ref.invalidate(budgetsProvider);
    return result;
  }
}

final budgetActionsProvider = Provider<BudgetActions>(BudgetActions.new);

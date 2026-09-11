/// Goal state (UC-29).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/goal_repository.dart';

/// The user's goals, with the progress the API computed for each.
final goalsProvider = FutureProvider<List<Goal>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('goals', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(goalRepositoryProvider).list();

    return switch (result) {
      Success<List<Goal>>(:final value) => value,
      Failure<List<Goal>>(:final message) => throw GoalsUnavailable(message),
    };
  },
);

class GoalsUnavailable implements Exception {
  const GoalsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Why a goal form was refused.
enum GoalProblem {
  /// `AF-01`: not a number at all.
  amountUnreadable,

  /// `AF-01`: readable, but zero or less.
  amountNotPositive,

  /// `AF-02`.
  targetDateNotInFuture,

  missingName,
  missingTargetDate,
}

extension GoalProblemMessage on GoalProblem {
  String get message => switch (this) {
    GoalProblem.amountUnreadable =>
      'That amount could not be read. Enter a number.',
    GoalProblem.amountNotPositive => 'The target must be greater than zero.',
    GoalProblem.targetDateNotInFuture =>
      'The target date must be in the future. A goal is something to reach, '
          'not something already past.',
    GoalProblem.missingName => 'Give the goal a name.',
    GoalProblem.missingTargetDate => 'Choose the date to reach it by.',
  };
}

/// What the form checks before anything is submitted (step 3).
abstract final class GoalRules {
  static GoalProblem? validate({
    required String name,
    required String amountText,
    required DateTime? targetDate,
    required DateTime now,
    required bool Function(String) isPositiveAmount,
    required bool Function(String) isReadableAmount,
  }) {
    if (name.trim().isEmpty) return GoalProblem.missingName;
    if (!isReadableAmount(amountText)) return GoalProblem.amountUnreadable;
    if (!isPositiveAmount(amountText)) return GoalProblem.amountNotPositive;
    if (targetDate == null) return GoalProblem.missingTargetDate;

    if (!isInFuture(targetDate, now: now)) {
      return GoalProblem.targetDateNotInFuture;
    }

    return null;
  }

  /// Whether [date] is after today (`AF-02`).
  ///
  /// Compared by day, and strictly after: a goal due today is not something
  /// to reach, it is something already due. [now] is passed rather than read
  /// from the clock so the rule is a pure function a test can pin.
  static bool isInFuture(DateTime date, {required DateTime now}) {
    final due = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);

    return due.isAfter(today);
  }
}

/// Changes to the goal set, re-reading the list after a confirmed change.
class GoalActions {
  const GoalActions(this._ref);

  final Ref _ref;

  Future<Result<void>> create({
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds = const [],
    List<String> investmentIds = const [],
  }) => _afterChange(
    () => _ref
        .read(goalRepositoryProvider)
        .create(
          name: name,
          targetAmount: targetAmount,
          currencyCode: currencyCode,
          targetDate: targetDate,
          accountIds: accountIds,
          investmentIds: investmentIds,
        ),
  );

  Future<Result<void>> update({
    required String id,
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds = const [],
    List<String> investmentIds = const [],
  }) => _afterChange(
    () => _ref
        .read(goalRepositoryProvider)
        .update(
          id: id,
          name: name,
          targetAmount: targetAmount,
          currencyCode: currencyCode,
          targetDate: targetDate,
          accountIds: accountIds,
          investmentIds: investmentIds,
        ),
  );

  Future<Result<void>> delete(String id) =>
      _afterChange(() => _ref.read(goalRepositoryProvider).delete(id));

  Future<Result<void>> _afterChange(
    Future<Result<void>> Function() call,
  ) async {
    final result = await call();
    // The list carries each goal's progress, so a change means re-reading the
    // figures the API computed rather than adjusting them here.
    if (result.isSuccess) _ref.invalidate(goalsProvider);
    return result;
  }
}

final goalActionsProvider = Provider<GoalActions>(GoalActions.new);

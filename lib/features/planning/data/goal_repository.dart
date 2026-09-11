/// Goals (UC-29).
///
/// `FR-OR-09` mirrors the budget rule: **progress is the API's figure, never
/// this client's.** Nothing here subtracts what has been saved from a target
/// to find what is left, or divides one by the other to find a proportion.
/// The API answers all three, and it is the only party that can see every
/// account and investment a goal draws on.
///
/// The proportion is carried as a decimal string rather than a `double` even
/// though it is only ever used to draw a bar. A proportion computed from money
/// is still money-derived, and `IR-14` does not make an exception for figures
/// that happen to be on their way to a pixel.
library;

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// How far along a goal is, as the API computed it.
@immutable
class GoalProgress {
  const GoalProgress({
    this.currentAmount,
    this.remaining,
    this.proportionReached,
    this.isReached,
  });

  /// All four as the API reported them, and all four nullable (`AF-03`).
  final Money? currentAmount;
  final Money? remaining;

  /// How much of the target has been reached, as an exact decimal between 0
  /// and 1. Never a `double`, for the reason the library comment gives.
  final Decimal? proportionReached;

  /// The same proportion in thousandths, as a plain integer.
  ///
  /// Exists so a progress bar can be drawn without a monetary value ever
  /// becoming a float. The division from money to ratio happens here in exact
  /// decimal arithmetic; what leaves is a unitless count of thousandths, and
  /// only *that* is divided into a fraction for a pixel. A proportion is not
  /// an amount, so this is the layout fraction `IR-14` explicitly permits
  /// rather than a hole in it.
  ///
  /// Rounded once, at the point of drawing, and never read back as a figure.
  int? get proportionPermille {
    final proportion = proportionReached;
    if (proportion == null) return null;

    return (proportion * Decimal.fromInt(1000)).round().toBigInt().toInt();
  }

  final bool? isReached;

  /// `AF-03`: the API gave no progress for this goal.
  bool get isUnavailable => currentAmount == null && remaining == null;
}

/// A savings target with a date.
@immutable
class Goal {
  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.targetDate,
    required this.accountNames,
    required this.investmentNames,
    this.progress,
  });

  final String id;
  final String name;

  /// The target, as recorded.
  final Money targetAmount;

  final DateTime targetDate;

  /// What the goal draws on, named for display.
  final List<String> accountNames;
  final List<String> investmentNames;

  final GoalProgress? progress;

  /// Whether progress is missing altogether (`AF-03`).
  bool get hasNoProgress => progress == null || progress!.isUnavailable;

  /// Whether the API says the target has been met.
  ///
  /// The API's verdict, not a comparison of two figures: where it could not
  /// compute progress there is no verdict, and comparing locally would
  /// invent one.
  bool get isReached => progress?.isReached ?? false;

  /// Whether the target date has passed (`AF-04`).
  ///
  /// [now] is passed rather than read from the clock so the rule is a pure
  /// function a test can pin. Compared by day: a goal due today has not
  /// elapsed merely because the morning has.
  bool hasElapsed({required DateTime now}) {
    final due = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final today = DateTime(now.year, now.month, now.day);

    return due.isBefore(today);
  }
}

abstract interface class GoalRepository {
  Future<Result<List<Goal>>> list();
  Future<Result<Goal>> read(String id);

  Future<Result<void>> create({
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds,
    List<String> investmentIds,
  });

  Future<Result<void>> update({
    required String id,
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds,
    List<String> investmentIds,
  });

  Future<Result<void>> delete(String id);
}

class HttpGoalRepository implements GoalRepository {
  HttpGoalRepository(this._client);

  factory HttpGoalRepository.fromDio(Dio dio) =>
      HttpGoalRepository(GoalsClient(dio));

  final GoalsClient _client;

  @override
  Future<Result<List<Goal>>> list() async {
    try {
      final output = (await _client.getApiGoals()).data;

      return Success([
        for (final goal in output?.goals ?? const <GoalOutput>[]) _from(goal),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<Goal>>(exception);
    }
  }

  @override
  Future<Result<Goal>> read(String id) async {
    try {
      final output = (await _client.getApiGoalsId(id: id)).data;

      // AF-05.
      if (output == null) {
        return const Failure(
          message: 'That goal was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      return failureFromDioException<Goal>(exception);
    }
  }

  @override
  Future<Result<void>> create({
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds = const [],
    List<String> investmentIds = const [],
  }) async {
    try {
      await _client.postApiGoals(
        body: CreateGoalCommand(
          name: name,
          // The string as typed. Never parsed to a number on the way out.
          targetAmount: targetAmount,
          currencyCode: currencyCode,
          targetDate: targetDate,
          accountIds: accountIds.isEmpty ? null : accountIds,
          investmentIds: investmentIds.isEmpty ? null : investmentIds,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds = const [],
    List<String> investmentIds = const [],
  }) async {
    try {
      await _client.putApiGoalsId(
        id: id,
        body: UpdateGoalCommand(
          name: name,
          targetAmount: targetAmount,
          currencyCode: currencyCode,
          targetDate: targetDate,
          accountIds: accountIds.isEmpty ? null : accountIds,
          investmentIds: investmentIds.isEmpty ? null : investmentIds,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _client.deleteApiGoalsId(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  static Goal _from(GoalOutput output) {
    final currency = output.currencyCode ?? '';
    final progress = output.currentProgress;

    Money? money(String? amount) =>
        amount == null ? null : Money.parse(amount, currency);

    return Goal(
      id: output.id ?? '',
      name: output.name ?? '',
      targetAmount: Money.parse(output.targetAmount ?? '0', currency),
      targetDate: output.targetDate ?? DateTime(1970),
      accountNames: [
        for (final account in output.accounts ?? const <GoalResourceOutput>[])
          account.name ?? '',
      ],
      investmentNames: [
        for (final investment
            in output.investments ?? const <GoalResourceOutput>[])
          investment.name ?? '',
      ],
      progress: progress == null
          ? null
          : GoalProgress(
              // AF-03 hinges on these staying null where the API sent none.
              currentAmount: money(progress.currentAmount),
              remaining: money(progress.remaining),
              proportionReached: progress.proportionReached == null
                  ? null
                  : Decimal.tryParse(progress.proportionReached!),
              isReached: progress.isReached,
            ),
    );
  }
}

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => HttpGoalRepository.fromDio(ref.watch(dioProvider)),
);

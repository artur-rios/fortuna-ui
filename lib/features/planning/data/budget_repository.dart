/// Budgets (UC-28).
///
/// `FR-OR-07` is the rule this file protects: **consumption is the API's
/// figure, never this client's.** Nothing here subtracts spending from a
/// ceiling to find what is left, or compares the two to decide whether a
/// budget is exceeded — the API answers all three, and it is the only party
/// that can see every transaction the budget covers.
///
/// That is also why each figure is nullable. A consumption the instance could
/// not compute is absent (`AF-04`), and absent is shown as absent: a zero in
/// its place would read as "you have spent nothing", which is a different and
/// much more comforting claim than "we could not tell you".
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// How long a budget's period runs.
///
/// Mapped from the contract's numbers rather than the generated names, for the
/// reason `AccountType` gives.
enum BudgetPeriod {
  monthly(1, 'Monthly'),
  quarterly(2, 'Quarterly'),
  yearly(3, 'Yearly');

  const BudgetPeriod(this.wire, this.label);

  final int wire;
  final String label;

  static BudgetPeriod from(BudgetPeriodType? type) => switch (type?.json) {
    2 => BudgetPeriod.quarterly,
    3 => BudgetPeriod.yearly,
    _ => BudgetPeriod.monthly,
  };

  BudgetPeriodType get asApi => BudgetPeriodType.fromJson(wire);
}

/// What has been spent against a budget, as the API computed it.
@immutable
class BudgetConsumption {
  const BudgetConsumption({
    required this.periodStart,
    required this.periodEnd,
    this.spent,
    this.remaining,
    this.overage,
    this.isExceeded,
  });

  final DateTime periodStart;
  final DateTime periodEnd;

  /// All four as the API reported them, and all four nullable.
  ///
  /// `remaining` is deliberately not `amount - spent`: the two are separate
  /// answers, and the arithmetic that looks obvious would be wrong wherever
  /// the instance counts something this client cannot see.
  final Money? spent;
  final Money? remaining;
  final Money? overage;
  final bool? isExceeded;

  /// `AF-04`: the API gave no figures for this period.
  bool get isUnavailable => spent == null && remaining == null;
}

/// A ceiling for one or more categories over a period.
@immutable
class Budget {
  const Budget({
    required this.id,
    required this.amount,
    required this.period,
    required this.periodStart,
    required this.categoryNames,
    required this.includeDescendants,
    this.consumption,
  });

  final String id;

  /// The ceiling, as recorded.
  final Money amount;

  final BudgetPeriod period;
  final DateTime periodStart;

  /// The categories this budget covers, named for display.
  final List<String> categoryNames;

  final bool includeDescendants;

  /// The current period's consumption, where the API supplied one.
  final BudgetConsumption? consumption;

  /// Whether consumption is missing altogether (`AF-04`).
  bool get hasNoConsumption =>
      consumption == null || consumption!.isUnavailable;

  /// Whether the API says this budget is over its ceiling.
  ///
  /// Reads the API's own verdict rather than comparing two figures: where the
  /// instance could not compute consumption there is no verdict to give, and
  /// a local comparison would invent one.
  bool get isExceeded => consumption?.isExceeded ?? false;
}

abstract interface class BudgetRepository {
  Future<Result<List<Budget>>> list();
  Future<Result<Budget>> read(String id);

  Future<Result<void>> create({
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants,
  });

  Future<Result<void>> update({
    required String id,
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants,
  });

  Future<Result<void>> delete(String id);
}

class HttpBudgetRepository implements BudgetRepository {
  HttpBudgetRepository(this._client);

  factory HttpBudgetRepository.fromDio(Dio dio) =>
      HttpBudgetRepository(BudgetsClient(dio));

  final BudgetsClient _client;

  @override
  Future<Result<List<Budget>>> list() async {
    try {
      final output = (await _client.getApiBudgets()).data;

      return Success([
        for (final budget in output?.budgets ?? const <BudgetOutput>[])
          _from(budget),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<Budget>>(exception);
    }
  }

  @override
  Future<Result<Budget>> read(String id) async {
    try {
      final output = (await _client.getApiBudgetsId(id: id)).data;

      // AF-05: not found and not yours are the same answer.
      if (output == null) {
        return const Failure(
          message: 'That budget was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      return failureFromDioException<Budget>(exception);
    }
  }

  @override
  Future<Result<void>> create({
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants = false,
  }) async {
    try {
      await _client.postApiBudgets(
        body: CreateBudgetCommand(
          categoryIds: categoryIds,
          // The string as typed. Never parsed to a number on the way out.
          amount: amount,
          currencyCode: currencyCode,
          periodType: period.asApi,
          periodStart: periodStart,
          includeDescendants: includeDescendants,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      // AF-03: an overlapping budget is the API's rule to state.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> update({
    required String id,
    required List<String> categoryIds,
    required String amount,
    required String currencyCode,
    required BudgetPeriod period,
    required DateTime periodStart,
    bool includeDescendants = false,
  }) async {
    try {
      await _client.putApiBudgetsId(
        id: id,
        body: UpdateBudgetCommand(
          categoryIds: categoryIds,
          amount: amount,
          currencyCode: currencyCode,
          periodType: period.asApi,
          periodStart: periodStart,
          includeDescendants: includeDescendants,
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
      await _client.deleteApiBudgetsId(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  static Budget _from(BudgetOutput output) {
    final currency = output.currencyCode ?? '';
    final period = output.currentPeriod;

    Money? money(String? amount) =>
        amount == null ? null : Money.parse(amount, currency);

    return Budget(
      id: output.id ?? '',
      amount: Money.parse(output.amount ?? '0', currency),
      period: BudgetPeriod.from(output.periodType),
      periodStart: output.periodStart ?? DateTime(1970),
      categoryNames: [
        for (final category
            in output.categories ?? const <BudgetCategoryOutput>[])
          category.name ?? '',
      ],
      includeDescendants: output.includeDescendants ?? false,
      consumption: period == null
          ? null
          : BudgetConsumption(
              periodStart: period.periodStart ?? DateTime(1970),
              periodEnd: period.periodEnd ?? DateTime(1970),
              // AF-04 hinges on these staying null where the API sent none.
              spent: money(period.spent),
              remaining: money(period.remaining),
              overage: money(period.overage),
              isExceeded: period.isExceeded,
            ),
    );
  }
}

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => HttpBudgetRepository.fromDio(ref.watch(dioProvider)),
);

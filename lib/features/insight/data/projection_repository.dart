/// The net position, projections and committed obligations (UC-38).
///
/// Two rules run through this whole file.
///
/// **`FR-PJ-05`: a projection is never a recorded fact, and is never stored.**
/// Nothing here caches a forecast. Every read asks the API again, because a
/// projection kept from an earlier read would age into a claim about the past
/// that nobody made.
///
/// **`FR-PJ-04` and `FR-PS-12`: a projected figure is marked as projected.**
/// [Money] already carries `isProjected`, so the distinction travels *on the
/// value* rather than alongside it — a projected amount cannot reach a widget
/// having lost the fact that it is a forecast, because the fact is part of
/// the amount.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// The net position in one currency, where it could not all be folded into
/// one (`AF-03`).
@immutable
class PositionInCurrency {
  const PositionInCurrency({
    required this.net,
    required this.accounts,
    required this.creditCards,
    required this.investments,
    this.unconvertedReason,
  });

  /// All four as the API reported them. The net is not accounts plus
  /// investments minus cards worked out here — that arithmetic looks obvious
  /// and is the API's to perform.
  final Money net;
  final Money accounts;
  final Money creditCards;
  final Money investments;

  /// Why this currency stayed in its own, where the API said.
  final String? unconvertedReason;
}

/// Where the user stands now (`FR-PJ-01`).
@immutable
class NetPosition {
  const NetPosition({
    required this.asOf,
    required this.byCurrency,
    required this.isFullyConverted,
    this.total,
    this.displayCurrencyCode,
  });

  final DateTime asOf;

  /// Each currency separately. Always populated, even where a total exists —
  /// it is what `AF-03` shows instead of a sum across currencies.
  final List<PositionInCurrency> byCurrency;

  final bool isFullyConverted;

  /// The figure in the display currency, where the API produced one.
  final Money? total;

  final String? displayCurrencyCode;

  /// `AF-05`: nothing held at all, which is a zero worth explaining rather
  /// than a failure.
  bool get hasNoHoldings => byCurrency.isEmpty;

  /// `AF-03`.
  bool get spansCurrencies => !isFullyConverted || byCurrency.length > 1;
}

/// One period of a forward projection.
@immutable
class ProjectedPeriod {
  const ProjectedPeriod({
    required this.periodStart,
    required this.periodEnd,
    required this.openingBalance,
    required this.closingBalance,
  });

  final DateTime periodStart;
  final DateTime periodEnd;

  /// Both carry `isProjected`, so nothing downstream can show them as
  /// recorded by accident.
  final Money openingBalance;
  final Money closingBalance;
}

/// A forward cash-flow projection (`FR-PJ-02`).
@immutable
class CashFlowProjection {
  const CashFlowProjection({
    required this.asOf,
    required this.through,
    required this.startingBalance,
    required this.periods,
    this.flatReason,
    this.displayCurrencyCode,
  });

  final DateTime asOf;
  final DateTime through;

  /// Where the projection starts from. Recorded, not projected — it is the
  /// balance as it stands today.
  final Money startingBalance;

  final List<ProjectedPeriod> periods;

  /// `AF-01`: the API's own reason for a projection it could not shape —
  /// usually too little history to extrapolate from. Presented instead of a
  /// forecast built on nothing.
  final String? flatReason;

  final String? displayCurrencyCode;

  /// `AF-01`.
  bool get hasNothingToProject =>
      periods.isEmpty || (flatReason?.isNotEmpty ?? false);
}

/// What kind of commitment an obligation is.
enum ObligationKind {
  installment(1, 'Installment'),
  statement(2, 'Card statement'),
  other(0, 'Commitment');

  const ObligationKind(this.wire, this.label);

  final int wire;
  final String label;

  static ObligationKind from(CommittedObligationKind? kind) =>
      switch (kind?.json) {
        1 => ObligationKind.installment,
        2 => ObligationKind.statement,
        _ => ObligationKind.other,
      };
}

/// Something already committed to but not yet materialized (`FR-PJ-03`).
@immutable
class CommittedObligation {
  const CommittedObligation({
    required this.id,
    required this.kind,
    required this.amount,
    required this.dueDate,
    required this.isOverdue,
    required this.daysOverdue,
  });

  final String id;
  final ObligationKind kind;

  /// Scheduled rather than recorded, and marked as such on the value itself.
  final Money amount;

  final DateTime dueDate;
  final bool isOverdue;
  final int daysOverdue;
}

/// The obligations ahead.
@immutable
class CommittedObligations {
  const CommittedObligations({
    required this.asOf,
    required this.through,
    required this.items,
    required this.isFullyConverted,
    this.total,
    this.displayCurrencyCode,
  });

  final DateTime asOf;
  final DateTime through;
  final List<CommittedObligation> items;
  final bool isFullyConverted;
  final Money? total;
  final String? displayCurrencyCode;

  bool get isEmpty => items.isEmpty;

  /// `AF-03`.
  bool get spansCurrencies => !isFullyConverted;
}

abstract interface class ProjectionRepository {
  Future<Result<NetPosition>> netPosition({String? displayCurrencyCode});

  Future<Result<CashFlowProjection>> cashFlow({
    required int horizonDays,
    String? displayCurrencyCode,
  });

  Future<Result<CommittedObligations>> obligations({
    required int horizonDays,
    String? displayCurrencyCode,
  });
}

class HttpProjectionRepository implements ProjectionRepository {
  HttpProjectionRepository(this._reports, this._projections);

  factory HttpProjectionRepository.fromDio(Dio dio) =>
      HttpProjectionRepository(ReportsClient(dio), ProjectionsClient(dio));

  final ReportsClient _reports;
  final ProjectionsClient _projections;

  @override
  Future<Result<NetPosition>> netPosition({String? displayCurrencyCode}) async {
    try {
      final output = (await _reports.getApiReportsNetPosition(
        displayCurrencyCode: displayCurrencyCode,
      )).data;

      if (output == null) {
        return const Failure(
          message: 'The instance returned no net position.',
          kind: FailureKind.serverError,
        );
      }

      final currency = output.displayCurrencyCode;
      final total = output.total;

      return Success(
        NetPosition(
          asOf: output.asOf ?? DateTime.now(),
          isFullyConverted: output.isFullyConverted ?? true,
          displayCurrencyCode: currency,
          total: (total != null && currency != null)
              ? Money.parse(total, currency)
              : null,
          byCurrency: [
            for (final group
                in output.currencyGroups ?? const <NetPositionCurrencyOutput>[])
              _positionFrom(group),
          ],
        ),
      );
    } on DioException catch (exception) {
      // AF-02.
      return failureFromDioException<NetPosition>(exception);
    }
  }

  @override
  Future<Result<CashFlowProjection>> cashFlow({
    required int horizonDays,
    String? displayCurrencyCode,
  }) async {
    try {
      final output = (await _projections.getApiProjectionsCashFlow(
        horizonDays: horizonDays,
        displayCurrencyCode: displayCurrencyCode,
      )).data;

      if (output == null) {
        return const Failure(
          message: 'The instance returned no projection.',
          kind: FailureKind.serverError,
        );
      }

      final currency = output.displayCurrencyCode ?? '';

      return Success(
        CashFlowProjection(
          asOf: output.asOf ?? DateTime.now(),
          through: output.through ?? DateTime.now(),
          // The starting point is today's balance: a record, not a forecast.
          startingBalance: Money.parse(output.startingBalance ?? '0', currency),
          flatReason: output.flatReason,
          displayCurrencyCode: output.displayCurrencyCode,
          periods: [
            for (final period
                in output.periods ?? const <CashFlowPeriodOutput>[])
              ProjectedPeriod(
                periodStart: period.periodStart ?? DateTime.now(),
                periodEnd: period.periodEnd ?? DateTime.now(),
                // FR-PJ-04: the distinction rides on the value, so nothing
                // downstream can lose it.
                openingBalance: Money.parse(
                  period.openingBalance ?? '0',
                  currency,
                  isProjected: true,
                ),
                closingBalance: Money.parse(
                  period.closingBalance ?? '0',
                  currency,
                  isProjected: true,
                ),
              ),
          ],
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<CashFlowProjection>(exception);
    }
  }

  @override
  Future<Result<CommittedObligations>> obligations({
    required int horizonDays,
    String? displayCurrencyCode,
  }) async {
    try {
      final output = (await _projections.getApiProjectionsCommitments(
        horizonDays: horizonDays,
        displayCurrencyCode: displayCurrencyCode,
      )).data;

      if (output == null) {
        return const Failure(
          message: 'The instance returned no obligations.',
          kind: FailureKind.serverError,
        );
      }

      final displayCurrency = output.displayCurrencyCode;
      final total = output.total;

      return Success(
        CommittedObligations(
          asOf: output.asOf ?? DateTime.now(),
          through: output.through ?? DateTime.now(),
          isFullyConverted: output.isFullyConverted ?? true,
          displayCurrencyCode: displayCurrency,
          total: (total != null && displayCurrency != null)
              ? Money.parse(total, displayCurrency, isProjected: true)
              : null,
          items: [
            for (final item
                in output.items ?? const <CommittedObligationOutput>[])
              CommittedObligation(
                id: item.id ?? '',
                kind: ObligationKind.from(item.kind),
                // Scheduled, not recorded — marked on the value itself.
                amount: Money.parse(
                  item.displayAmount ?? item.amount ?? '0',
                  (item.displayAmount != null ? displayCurrency : null) ??
                      item.currencyCode ??
                      '',
                  isProjected: true,
                ),
                dueDate: item.dueDate ?? DateTime.now(),
                isOverdue: item.isOverdue ?? false,
                daysOverdue: item.daysOverdue ?? 0,
              ),
          ],
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<CommittedObligations>(exception);
    }
  }

  static PositionInCurrency _positionFrom(NetPositionCurrencyOutput group) {
    final currency = group.sourceCurrencyCode ?? '';

    Money money(String? amount) => Money.parse(amount ?? '0', currency);

    return PositionInCurrency(
      // All four the API's. The net is not derived from the other three.
      net: money(group.sourceNet),
      accounts: money(group.financialAccounts),
      creditCards: money(group.creditCards),
      investments: money(group.investments),
      unconvertedReason: group.unconvertedReason,
    );
  }
}

final projectionRepositoryProvider = Provider<ProjectionRepository>(
  (ref) => HttpProjectionRepository.fromDio(ref.watch(dioProvider)),
);

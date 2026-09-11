/// Aggregations (UC-36).
///
/// `FR-CH-02` is absolute: **every aggregation comes from the API and this
/// client computes none.** There is no summing here, no grouping, no
/// proportion worked out from two totals. The instance is the only party that
/// can see every transaction an aggregation covers, and a figure derived here
/// would disagree with it the moment a filter or a currency entered the
/// picture.
///
/// `AF-03` follows from the same rule. Where the API could not convert
/// everything into one display currency, it reports what it could not convert
/// and why — and this client groups by currency rather than adding amounts
/// that are not in the same unit (`BR-07`).
library;

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';
import '../../transactions/data/transaction_repository.dart';

/// What an aggregation groups by.
///
/// Only the groupings the API supports are listed, which is `AF-04` — an
/// unsupported grouping is not one the user can pick, because there is no
/// control for it.
enum Grouping {
  period('period', 'Over time'),
  category('category', 'By category'),
  account('account', 'By account'),
  counterparty('counterparty', 'By counterparty');

  const Grouping(this.wireName, this.label);

  /// What the API calls this dimension.
  final String wireName;

  final String label;

  /// Whether this grouping is naturally ordered in time, which decides
  /// whether a line or a bar reads better (`step 3`).
  bool get isTemporal => this == Grouping.period;
}

/// How finely a temporal aggregation is cut.
enum Granularity {
  daily('daily', 'Daily'),
  weekly('weekly', 'Weekly'),
  monthly('monthly', 'Monthly'),
  yearly('yearly', 'Yearly');

  const Granularity(this.wireName, this.label);

  final String wireName;
  final String label;
}

/// One amount the API could not fold into the display currency (`AF-03`).
@immutable
class UnconvertedAmount {
  const UnconvertedAmount({required this.amount, this.reason});

  /// In its own currency, which is the point: it is not added to anything.
  final Money amount;

  /// The API's reason, where it gave one.
  final String? reason;
}

/// One element of an aggregation.
@immutable
class AggregationBucket {
  const AggregationBucket({
    required this.label,
    required this.isFullyConverted,
    required this.unconverted,
    this.total,
    this.share,
    this.drillDownKey,
    this.periodStart,
    this.periodEnd,
  });

  final String label;

  /// The bucket's figure in the display currency, where the API produced one.
  ///
  /// Absent when nothing could be converted — in which case [unconverted]
  /// carries the amounts in their own currencies and the interface shows
  /// those instead of a total that would mean nothing.
  final Money? total;

  /// The bucket's share of the whole, as the API computed it.
  ///
  /// Read, never derived from [total] and a sum of the others. It is also
  /// what the chart plots: a share is a proportion, so a bar's height carries
  /// no monetary meaning at all and `FR-CH-08` holds by construction.
  final Decimal? share;

  /// Whether every amount behind this bucket reached the display currency.
  final bool isFullyConverted;

  /// What could not be converted, in its own currency (`AF-03`).
  final List<UnconvertedAmount> unconverted;

  /// What UC-37 descends with. A bucket without one cannot be drilled into.
  final String? drillDownKey;

  final DateTime? periodStart;
  final DateTime? periodEnd;

  /// Whether descending from this element is possible (`FR-CH-03`).
  bool get canDrillDown => drillDownKey?.isNotEmpty ?? false;

  /// The share in thousandths, as a plain integer.
  ///
  /// The one conversion a chart needs, done in exact decimal arithmetic and
  /// yielding a unitless count rather than a monetary value — the same device
  /// `GoalProgress.proportionPermille` uses, and for the same reason.
  int? get sharePermille {
    final proportion = share;
    if (proportion == null) return null;

    return (proportion * Decimal.fromInt(1000)).round().toBigInt().toInt();
  }
}

/// An aggregation, as the API computed it.
@immutable
class Aggregation {
  const Aggregation({
    required this.grouping,
    required this.buckets,
    required this.from,
    required this.to,
    required this.isFullyConverted,
    this.displayCurrencyCode,
  });

  final Grouping grouping;
  final List<AggregationBucket> buckets;
  final DateTime from;
  final DateTime to;

  /// Whether every amount reached one currency. False is `AF-03`.
  final bool isFullyConverted;

  final String? displayCurrencyCode;

  /// `AF-01`: nothing in the period, which is not a failure.
  bool get isEmpty => buckets.isEmpty;

  /// `AF-03`: the figures are in more than one currency, so they are shown
  /// grouped by currency rather than summed across them.
  bool get spansCurrencies =>
      !isFullyConverted || buckets.any((bucket) => !bucket.isFullyConverted);
}

abstract interface class AggregationRepository {
  /// Asks the API for an aggregation (`FR-CH-02`).
  Future<Result<Aggregation>> aggregate({
    required Grouping grouping,
    required DateTime from,
    required DateTime to,
    Granularity? granularity,
    String? displayCurrencyCode,
    Direction? direction,
    String? financialAccountId,
    String? categoryId,
    String? counterpartyId,
    bool rollUpSmallest,
  });
}

class HttpAggregationRepository implements AggregationRepository {
  HttpAggregationRepository(this._client);

  factory HttpAggregationRepository.fromDio(Dio dio) =>
      HttpAggregationRepository(ReportsClient(dio));

  final ReportsClient _client;

  @override
  Future<Result<Aggregation>> aggregate({
    required Grouping grouping,
    required DateTime from,
    required DateTime to,
    Granularity? granularity,
    String? displayCurrencyCode,
    Direction? direction,
    String? financialAccountId,
    String? categoryId,
    String? counterpartyId,
    // AF-05: the API rolls the smallest elements into a remainder, which it
    // returns with a drill-down key of its own. Doing it here would mean
    // subdividing an aggregate this client holds, which `FR-CH-04` forbids.
    bool rollUpSmallest = true,
  }) async {
    try {
      final output = (await _client.getApiReportsAggregate(
        dimension: grouping.wireName,
        granularity: granularity?.wireName,
        from: from,
        to: to,
        rollupCategories: rollUpSmallest,
        displayCurrencyCode: displayCurrencyCode,
        direction: direction?.asApi,
        financialAccountId: financialAccountId,
        categoryId: categoryId,
        counterpartyId: counterpartyId,
      )).data;

      if (output == null) {
        return const Failure(
          message: 'The instance returned no aggregation.',
          kind: FailureKind.serverError,
        );
      }

      return Success(_from(output, grouping, from, to));
    } on DioException catch (exception) {
      // AF-02.
      return failureFromDioException<Aggregation>(exception);
    }
  }

  static Aggregation _from(
    TransactionAggregationOutput output,
    Grouping grouping,
    DateTime from,
    DateTime to,
  ) {
    final currency = output.displayCurrencyCode;

    return Aggregation(
      grouping: grouping,
      from: output.from ?? from,
      to: output.to ?? to,
      isFullyConverted: output.isFullyConverted ?? true,
      displayCurrencyCode: currency,
      buckets: [
        for (final bucket
            in output.buckets ?? const <TransactionAggregationBucketOutput>[])
          _bucketFrom(bucket, currency),
      ],
    );
  }

  static AggregationBucket _bucketFrom(
    TransactionAggregationBucketOutput bucket,
    String? displayCurrency,
  ) {
    final total = bucket.total;

    return AggregationBucket(
      label: bucket.label ?? '',
      // Only where there is a currency to denominate it in. A total without
      // one is a bare number, which is what `BR-07` exists to prevent.
      total: (total != null && displayCurrency != null)
          ? Money.parse(total, displayCurrency)
          : null,
      share: bucket.share == null ? null : Decimal.tryParse(bucket.share!),
      isFullyConverted: bucket.isFullyConverted ?? true,
      drillDownKey: bucket.drillDownKey,
      periodStart: bucket.periodStart,
      periodEnd: bucket.periodEnd,
      unconverted: [
        for (final conversion
            in bucket.conversions ??
                const <TransactionAggregationConversionOutput>[])
          // Only the ones that did not convert. A converted amount is already
          // inside the total and listing it again would double-count it to
          // the reader.
          if (conversion.displayAmount == null)
            UnconvertedAmount(
              amount: Money.parse(
                conversion.sourceAmount ?? '0',
                conversion.sourceCurrencyCode ?? '',
              ),
              reason: conversion.unconvertedReason,
            ),
      ],
    );
  }
}

final aggregationRepositoryProvider = Provider<AggregationRepository>(
  (ref) => HttpAggregationRepository.fromDio(ref.watch(dioProvider)),
);

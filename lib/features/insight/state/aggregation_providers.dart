/// Aggregation state (UC-36).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/aggregation_repository.dart';

/// What the chart is asking for.
@immutable
class AggregationRequest {
  const AggregationRequest({
    required this.grouping,
    required this.from,
    required this.to,
    this.granularity = Granularity.monthly,
    this.displayCurrencyCode,
  });

  final Grouping grouping;
  final DateTime from;
  final DateTime to;
  final Granularity granularity;

  /// The currency to fold everything into, where the user chose one.
  ///
  /// `null` is not an oversight: without one the API reports each currency
  /// separately, which `AF-03` requires rather than summing across them.
  final String? displayCurrencyCode;

  AggregationRequest copyWith({
    Grouping? grouping,
    DateTime? from,
    DateTime? to,
    Granularity? granularity,
    String? displayCurrencyCode,
  }) => AggregationRequest(
    grouping: grouping ?? this.grouping,
    from: from ?? this.from,
    to: to ?? this.to,
    granularity: granularity ?? this.granularity,
    displayCurrencyCode: displayCurrencyCode ?? this.displayCurrencyCode,
  );

  @override
  bool operator ==(Object other) =>
      other is AggregationRequest &&
      other.grouping == grouping &&
      other.from == from &&
      other.to == to &&
      other.granularity == granularity &&
      other.displayCurrencyCode == displayCurrencyCode;

  @override
  int get hashCode =>
      Object.hash(grouping, from, to, granularity, displayCurrencyCode);
}

/// The aggregation the current request asks for.
///
/// Keyed on the request, so changing the grouping is a different question
/// rather than a mutation of this one — which is what keeps a chart for one
/// grouping from being shown as though it answered another.
final aggregationProvider =
    FutureProvider.family<Aggregation, AggregationRequest>(
      retry: (retryCount, error) => null,
      (ref, request) async {
        final result = await ref
            .read(aggregationRepositoryProvider)
            .aggregate(
              grouping: request.grouping,
              from: request.from,
              to: request.to,
              granularity: request.grouping.isTemporal
                  ? request.granularity
                  : null,
              displayCurrencyCode: request.displayCurrencyCode,
            );

        return switch (result) {
          Success<Aggregation>(:final value) => value,
          // AF-02.
          Failure<Aggregation>(:final message) => throw AggregationUnavailable(
            message,
          ),
        };
      },
    );

class AggregationUnavailable implements Exception {
  const AggregationUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

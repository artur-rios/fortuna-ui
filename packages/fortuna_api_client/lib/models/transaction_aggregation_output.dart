// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_aggregation_bucket_output.dart';

part 'transaction_aggregation_output.g.dart';

@JsonSerializable()
class TransactionAggregationOutput {
  const TransactionAggregationOutput({
    this.buckets,
    this.dimension,
    this.displayCurrencyCode,
    this.from,
    this.granularity,
    this.isFullyConverted,
    this.to,
  });

  factory TransactionAggregationOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionAggregationOutputFromJson(json);

  final List<TransactionAggregationBucketOutput>? buckets;
  final String? dimension;
  final String? displayCurrencyCode;
  final DateTime? from;
  final String? granularity;
  final bool? isFullyConverted;
  final DateTime? to;

  Map<String, Object?> toJson() => _$TransactionAggregationOutputToJson(this);
}

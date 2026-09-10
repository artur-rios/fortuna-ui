// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_aggregation_conversion_output.dart';

part 'transaction_aggregation_bucket_output.g.dart';

@JsonSerializable()
class TransactionAggregationBucketOutput {
  const TransactionAggregationBucketOutput({
    this.conversions,
    this.drillDownKey,
    this.isFullyConverted,
    this.label,
    this.periodEnd,
    this.periodStart,
    this.share,
    this.total,
  });

  factory TransactionAggregationBucketOutput.fromJson(
    Map<String, Object?> json,
  ) => _$TransactionAggregationBucketOutputFromJson(json);

  final List<TransactionAggregationConversionOutput>? conversions;
  final String? drillDownKey;
  final bool? isFullyConverted;
  final String? label;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final String? share;
  final String? total;

  Map<String, Object?> toJson() =>
      _$TransactionAggregationBucketOutputToJson(this);
}

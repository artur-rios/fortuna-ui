// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_aggregation_bucket_output.dart';
import 'transaction_output.dart';

part 'transaction_drill_down_output.g.dart';

@JsonSerializable()
class TransactionDrillDownOutput {
  const TransactionDrillDownOutput({
    this.buckets,
    this.dimension,
    this.mayDifferFromChart,
    this.mode,
    this.pageNumber,
    this.pageSize,
    this.sourceDimension,
    this.totalItems,
    this.totalPages,
    this.transaction,
    this.transactions,
  });

  factory TransactionDrillDownOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionDrillDownOutputFromJson(json);

  final List<TransactionAggregationBucketOutput>? buckets;
  final String? dimension;
  final bool? mayDifferFromChart;
  final String? mode;
  final int? pageNumber;
  final int? pageSize;
  final String? sourceDimension;
  final int? totalItems;
  final int? totalPages;
  final TransactionOutput? transaction;
  final List<TransactionOutput>? transactions;

  Map<String, Object?> toJson() => _$TransactionDrillDownOutputToJson(this);
}

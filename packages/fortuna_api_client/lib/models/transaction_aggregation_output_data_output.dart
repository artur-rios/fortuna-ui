// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_aggregation_output.dart';

part 'transaction_aggregation_output_data_output.g.dart';

@JsonSerializable()
class TransactionAggregationOutputDataOutput {
  const TransactionAggregationOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory TransactionAggregationOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$TransactionAggregationOutputDataOutputFromJson(json);

  final TransactionAggregationOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$TransactionAggregationOutputDataOutputToJson(this);
}

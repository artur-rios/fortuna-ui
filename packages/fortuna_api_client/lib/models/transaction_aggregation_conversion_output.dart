// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'transaction_aggregation_conversion_output.g.dart';

@JsonSerializable()
class TransactionAggregationConversionOutput {
  const TransactionAggregationConversionOutput({
    this.appliedRate,
    this.displayAmount,
    this.figureDate,
    this.rateDate,
    this.rateSource,
    this.sourceAmount,
    this.sourceCurrencyCode,
    this.unconvertedReason,
  });

  factory TransactionAggregationConversionOutput.fromJson(
    Map<String, Object?> json,
  ) => _$TransactionAggregationConversionOutputFromJson(json);

  final String? appliedRate;
  final String? displayAmount;
  final DateTime? figureDate;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final String? sourceAmount;
  final String? sourceCurrencyCode;
  final String? unconvertedReason;

  Map<String, Object?> toJson() =>
      _$TransactionAggregationConversionOutputToJson(this);
}

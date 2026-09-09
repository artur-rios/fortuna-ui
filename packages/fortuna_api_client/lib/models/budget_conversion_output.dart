// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'budget_conversion_output.g.dart';

@JsonSerializable()
class BudgetConversionOutput {
  const BudgetConversionOutput({
    this.appliedRate,
    this.convertedAmount,
    this.rateDate,
    this.rateSource,
    this.sourceAmount,
    this.sourceCurrencyCode,
    this.unconvertedReason,
  });

  factory BudgetConversionOutput.fromJson(Map<String, Object?> json) =>
      _$BudgetConversionOutputFromJson(json);

  final double? appliedRate;
  final double? convertedAmount;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final double? sourceAmount;
  final String? sourceCurrencyCode;
  final String? unconvertedReason;

  Map<String, Object?> toJson() => _$BudgetConversionOutputToJson(this);
}

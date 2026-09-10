// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'converted_currency_group_output.g.dart';

@JsonSerializable()
class ConvertedCurrencyGroupOutput {
  const ConvertedCurrencyGroupOutput({
    this.appliedRate,
    this.displayAmount,
    this.rateDate,
    this.rateSource,
    this.sourceAmount,
    this.sourceCurrencyCode,
    this.unconvertedReason,
  });

  factory ConvertedCurrencyGroupOutput.fromJson(Map<String, Object?> json) =>
      _$ConvertedCurrencyGroupOutputFromJson(json);

  final String? appliedRate;
  final String? displayAmount;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final String? sourceAmount;
  final String? sourceCurrencyCode;
  final String? unconvertedReason;

  Map<String, Object?> toJson() => _$ConvertedCurrencyGroupOutputToJson(this);
}

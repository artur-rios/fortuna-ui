// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'cash_flow_rate_output.g.dart';

@JsonSerializable()
class CashFlowRateOutput {
  const CashFlowRateOutput({
    this.baseCurrencyCode,
    this.quoteCurrencyCode,
    this.rate,
    this.rateDate,
    this.source,
  });

  factory CashFlowRateOutput.fromJson(Map<String, Object?> json) =>
      _$CashFlowRateOutputFromJson(json);

  final String? baseCurrencyCode;
  final String? quoteCurrencyCode;
  final double? rate;
  final DateTime? rateDate;
  final ExchangeRateSource? source;

  Map<String, Object?> toJson() => _$CashFlowRateOutputToJson(this);
}

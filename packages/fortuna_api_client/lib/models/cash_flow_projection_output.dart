// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'cash_flow_period_output.dart';
import 'cash_flow_periodicity.dart';
import 'cash_flow_rate_output.dart';

part 'cash_flow_projection_output.g.dart';

@JsonSerializable()
class CashFlowProjectionOutput {
  const CashFlowProjectionOutput({
    this.asOf,
    this.displayCurrencyCode,
    this.estimateOmittedReason,
    this.flatReason,
    this.periodicity,
    this.periods,
    this.rates,
    this.startingBalance,
    this.through,
  });

  factory CashFlowProjectionOutput.fromJson(Map<String, Object?> json) =>
      _$CashFlowProjectionOutputFromJson(json);

  final DateTime? asOf;
  final String? displayCurrencyCode;
  final String? estimateOmittedReason;
  final String? flatReason;
  final CashFlowPeriodicity? periodicity;
  final List<CashFlowPeriodOutput>? periods;
  final List<CashFlowRateOutput>? rates;
  final String? startingBalance;
  final DateTime? through;

  Map<String, Object?> toJson() => _$CashFlowProjectionOutputToJson(this);
}

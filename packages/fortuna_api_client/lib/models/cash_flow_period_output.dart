// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'cash_flow_figure_output.dart';

part 'cash_flow_period_output.g.dart';

@JsonSerializable()
class CashFlowPeriodOutput {
  const CashFlowPeriodOutput({
    this.closingBalance,
    this.figures,
    this.openingBalance,
    this.periodEnd,
    this.periodStart,
  });

  factory CashFlowPeriodOutput.fromJson(Map<String, Object?> json) =>
      _$CashFlowPeriodOutputFromJson(json);

  final double? closingBalance;
  final List<CashFlowFigureOutput>? figures;
  final double? openingBalance;
  final DateTime? periodEnd;
  final DateTime? periodStart;

  Map<String, Object?> toJson() => _$CashFlowPeriodOutputToJson(this);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'budget_conversion_output.dart';

part 'budget_consumption_detail_output.g.dart';

@JsonSerializable()
class BudgetConsumptionDetailOutput {
  const BudgetConsumptionDetailOutput({
    this.budgetAmount,
    this.budgetId,
    this.conversions,
    this.currencyCode,
    this.isCovered,
    this.isExceeded,
    this.isFullyConverted,
    this.overage,
    this.periodEnd,
    this.periodStart,
    this.reason,
    this.remaining,
    this.requestedDate,
    this.spent,
  });

  factory BudgetConsumptionDetailOutput.fromJson(Map<String, Object?> json) =>
      _$BudgetConsumptionDetailOutputFromJson(json);

  final double? budgetAmount;
  final String? budgetId;
  final List<BudgetConversionOutput>? conversions;
  final String? currencyCode;
  final bool? isCovered;
  final bool? isExceeded;
  final bool? isFullyConverted;
  final double? overage;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final String? reason;
  final double? remaining;
  final DateTime? requestedDate;
  final double? spent;

  Map<String, Object?> toJson() => _$BudgetConsumptionDetailOutputToJson(this);
}

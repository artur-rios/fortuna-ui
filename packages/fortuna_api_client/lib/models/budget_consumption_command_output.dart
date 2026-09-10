// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'budget_consumption_command_output.g.dart';

@JsonSerializable()
class BudgetConsumptionCommandOutput {
  const BudgetConsumptionCommandOutput({
    this.isExceeded,
    this.isFullyConverted,
    this.overage,
    this.periodEnd,
    this.periodStart,
    this.remaining,
    this.spent,
  });

  factory BudgetConsumptionCommandOutput.fromJson(Map<String, Object?> json) =>
      _$BudgetConsumptionCommandOutputFromJson(json);

  final bool? isExceeded;
  final bool? isFullyConverted;
  final String? overage;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final String? remaining;
  final String? spent;

  Map<String, Object?> toJson() => _$BudgetConsumptionCommandOutputToJson(this);
}

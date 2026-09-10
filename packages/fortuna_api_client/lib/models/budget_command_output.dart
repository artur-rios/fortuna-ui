// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'budget_category_command_output.dart';
import 'budget_consumption_command_output.dart';
import 'budget_period_type.dart';

part 'budget_command_output.g.dart';

@JsonSerializable()
class BudgetCommandOutput {
  const BudgetCommandOutput({
    this.amount,
    this.categories,
    this.createdAt,
    this.currencyCode,
    this.currentPeriod,
    this.id,
    this.includeDescendants,
    this.isDeleted,
    this.periodStart,
    this.periodType,
    this.updatedAt,
  });

  factory BudgetCommandOutput.fromJson(Map<String, Object?> json) =>
      _$BudgetCommandOutputFromJson(json);

  final String? amount;
  final List<BudgetCategoryCommandOutput>? categories;
  final DateTime? createdAt;
  final String? currencyCode;
  final BudgetConsumptionCommandOutput? currentPeriod;
  final String? id;
  final bool? includeDescendants;
  final bool? isDeleted;
  final DateTime? periodStart;
  final BudgetPeriodType? periodType;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$BudgetCommandOutputToJson(this);
}

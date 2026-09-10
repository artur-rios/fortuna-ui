// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'budget_period_type.dart';

part 'create_budget_command.g.dart';

@JsonSerializable()
class CreateBudgetCommand {
  const CreateBudgetCommand({
    this.amount,
    this.categoryIds,
    this.currencyCode,
    this.includeDescendants,
    this.periodStart,
    this.periodType,
  });

  factory CreateBudgetCommand.fromJson(Map<String, Object?> json) =>
      _$CreateBudgetCommandFromJson(json);

  final String? amount;
  final List<String>? categoryIds;
  final String? currencyCode;
  final bool? includeDescendants;
  final DateTime? periodStart;
  final BudgetPeriodType? periodType;

  Map<String, Object?> toJson() => _$CreateBudgetCommandToJson(this);
}

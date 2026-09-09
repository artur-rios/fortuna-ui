// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'budget_output.dart';

part 'budget_list_output.g.dart';

@JsonSerializable()
class BudgetListOutput {
  const BudgetListOutput({this.budgets});

  factory BudgetListOutput.fromJson(Map<String, Object?> json) =>
      _$BudgetListOutputFromJson(json);

  final List<BudgetOutput>? budgets;

  Map<String, Object?> toJson() => _$BudgetListOutputToJson(this);
}

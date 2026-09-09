// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'budget_category_output.g.dart';

@JsonSerializable()
class BudgetCategoryOutput {
  const BudgetCategoryOutput({this.id, this.name});

  factory BudgetCategoryOutput.fromJson(Map<String, Object?> json) =>
      _$BudgetCategoryOutputFromJson(json);

  final String? id;
  final String? name;

  Map<String, Object?> toJson() => _$BudgetCategoryOutputToJson(this);
}

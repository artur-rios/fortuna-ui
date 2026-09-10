// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'goal_progress_output.dart';
import 'goal_resource_output.dart';

part 'goal_output.g.dart';

@JsonSerializable()
class GoalOutput {
  const GoalOutput({
    this.accounts,
    this.createdAt,
    this.currencyCode,
    this.currentProgress,
    this.id,
    this.investments,
    this.isDeleted,
    this.name,
    this.targetAmount,
    this.targetDate,
    this.updatedAt,
  });

  factory GoalOutput.fromJson(Map<String, Object?> json) =>
      _$GoalOutputFromJson(json);

  final List<GoalResourceOutput>? accounts;
  final DateTime? createdAt;
  final String? currencyCode;
  final GoalProgressOutput? currentProgress;
  final String? id;
  final List<GoalResourceOutput>? investments;
  final bool? isDeleted;
  final String? name;
  final String? targetAmount;
  final DateTime? targetDate;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$GoalOutputToJson(this);
}

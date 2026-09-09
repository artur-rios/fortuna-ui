// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'goal_progress_command_output.dart';
import 'goal_resource_command_output.dart';

part 'goal_command_output.g.dart';

@JsonSerializable()
class GoalCommandOutput {
  const GoalCommandOutput({
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

  factory GoalCommandOutput.fromJson(Map<String, Object?> json) =>
      _$GoalCommandOutputFromJson(json);

  final List<GoalResourceCommandOutput>? accounts;
  final DateTime? createdAt;
  final String? currencyCode;
  final GoalProgressCommandOutput? currentProgress;
  final String? id;
  final List<GoalResourceCommandOutput>? investments;
  final bool? isDeleted;
  final String? name;
  final double? targetAmount;
  final DateTime? targetDate;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$GoalCommandOutputToJson(this);
}

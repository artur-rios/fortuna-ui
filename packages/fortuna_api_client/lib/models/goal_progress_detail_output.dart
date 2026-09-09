// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'goal_resource_progress_output.dart';

part 'goal_progress_detail_output.g.dart';

@JsonSerializable()
class GoalProgressDetailOutput {
  const GoalProgressDetailOutput({
    this.asOf,
    this.currencyCode,
    this.currentAmount,
    this.daysRemaining,
    this.goalId,
    this.isFullyConverted,
    this.isPastDue,
    this.isReached,
    this.proportionReached,
    this.resources,
    this.shortfall,
    this.targetAmount,
    this.targetDate,
  });

  factory GoalProgressDetailOutput.fromJson(Map<String, Object?> json) =>
      _$GoalProgressDetailOutputFromJson(json);

  final DateTime? asOf;
  final String? currencyCode;
  final double? currentAmount;
  final int? daysRemaining;
  final String? goalId;
  final bool? isFullyConverted;
  final bool? isPastDue;
  final bool? isReached;
  final double? proportionReached;
  final List<GoalResourceProgressOutput>? resources;
  final double? shortfall;
  final double? targetAmount;
  final DateTime? targetDate;

  Map<String, Object?> toJson() => _$GoalProgressDetailOutputToJson(this);
}

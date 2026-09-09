// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'goal_progress_command_output.g.dart';

@JsonSerializable()
class GoalProgressCommandOutput {
  const GoalProgressCommandOutput({
    this.currentAmount,
    this.isFullyConverted,
    this.isReached,
    this.proportionReached,
    this.remaining,
  });

  factory GoalProgressCommandOutput.fromJson(Map<String, Object?> json) =>
      _$GoalProgressCommandOutputFromJson(json);

  final double? currentAmount;
  final bool? isFullyConverted;
  final bool? isReached;
  final double? proportionReached;
  final double? remaining;

  Map<String, Object?> toJson() => _$GoalProgressCommandOutputToJson(this);
}

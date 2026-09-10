// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'goal_progress_output.g.dart';

@JsonSerializable()
class GoalProgressOutput {
  const GoalProgressOutput({
    this.currentAmount,
    this.isFullyConverted,
    this.isReached,
    this.proportionReached,
    this.remaining,
  });

  factory GoalProgressOutput.fromJson(Map<String, Object?> json) =>
      _$GoalProgressOutputFromJson(json);

  final String? currentAmount;
  final bool? isFullyConverted;
  final bool? isReached;
  final String? proportionReached;
  final String? remaining;

  Map<String, Object?> toJson() => _$GoalProgressOutputToJson(this);
}

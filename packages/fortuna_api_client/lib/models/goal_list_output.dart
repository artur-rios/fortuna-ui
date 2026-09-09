// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'goal_output.dart';

part 'goal_list_output.g.dart';

@JsonSerializable()
class GoalListOutput {
  const GoalListOutput({this.goals});

  factory GoalListOutput.fromJson(Map<String, Object?> json) =>
      _$GoalListOutputFromJson(json);

  final List<GoalOutput>? goals;

  Map<String, Object?> toJson() => _$GoalListOutputToJson(this);
}

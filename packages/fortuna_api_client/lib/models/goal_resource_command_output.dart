// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'goal_resource_command_output.g.dart';

@JsonSerializable()
class GoalResourceCommandOutput {
  const GoalResourceCommandOutput({this.id, this.name});

  factory GoalResourceCommandOutput.fromJson(Map<String, Object?> json) =>
      _$GoalResourceCommandOutputFromJson(json);

  final String? id;
  final String? name;

  Map<String, Object?> toJson() => _$GoalResourceCommandOutputToJson(this);
}

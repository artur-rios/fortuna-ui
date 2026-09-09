// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'goal_resource_output.g.dart';

@JsonSerializable()
class GoalResourceOutput {
  const GoalResourceOutput({this.id, this.name});

  factory GoalResourceOutput.fromJson(Map<String, Object?> json) =>
      _$GoalResourceOutputFromJson(json);

  final String? id;
  final String? name;

  Map<String, Object?> toJson() => _$GoalResourceOutputToJson(this);
}

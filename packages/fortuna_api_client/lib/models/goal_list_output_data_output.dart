// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'goal_list_output.dart';

part 'goal_list_output_data_output.g.dart';

@JsonSerializable()
class GoalListOutputDataOutput {
  const GoalListOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory GoalListOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$GoalListOutputDataOutputFromJson(json);

  final GoalListOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$GoalListOutputDataOutputToJson(this);
}

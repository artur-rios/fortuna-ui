// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'goal_output.dart';

part 'goal_output_data_output.g.dart';

@JsonSerializable()
class GoalOutputDataOutput {
  const GoalOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory GoalOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$GoalOutputDataOutputFromJson(json);

  final GoalOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$GoalOutputDataOutputToJson(this);
}

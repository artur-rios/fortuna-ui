// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'goal_progress_detail_output.dart';

part 'goal_progress_detail_output_data_output.g.dart';

@JsonSerializable()
class GoalProgressDetailOutputDataOutput {
  const GoalProgressDetailOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory GoalProgressDetailOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$GoalProgressDetailOutputDataOutputFromJson(json);

  final GoalProgressDetailOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$GoalProgressDetailOutputDataOutputToJson(this);
}

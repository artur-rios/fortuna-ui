// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'reset_password_through_api_command_output.dart';

part 'reset_password_through_api_command_output_data_output.g.dart';

@JsonSerializable()
class ResetPasswordThroughApiCommandOutputDataOutput {
  const ResetPasswordThroughApiCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory ResetPasswordThroughApiCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ResetPasswordThroughApiCommandOutputDataOutputFromJson(json);

  final ResetPasswordThroughApiCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$ResetPasswordThroughApiCommandOutputDataOutputToJson(this);
}

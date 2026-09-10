// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'resend_verification_through_api_command_output.dart';

part 'resend_verification_through_api_command_output_data_output.g.dart';

@JsonSerializable()
class ResendVerificationThroughApiCommandOutputDataOutput {
  const ResendVerificationThroughApiCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory ResendVerificationThroughApiCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ResendVerificationThroughApiCommandOutputDataOutputFromJson(json);

  final ResendVerificationThroughApiCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$ResendVerificationThroughApiCommandOutputDataOutputToJson(this);
}

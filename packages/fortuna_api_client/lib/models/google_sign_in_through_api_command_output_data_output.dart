// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'google_sign_in_through_api_command_output.dart';

part 'google_sign_in_through_api_command_output_data_output.g.dart';

@JsonSerializable()
class GoogleSignInThroughApiCommandOutputDataOutput {
  const GoogleSignInThroughApiCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory GoogleSignInThroughApiCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$GoogleSignInThroughApiCommandOutputDataOutputFromJson(json);

  final GoogleSignInThroughApiCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$GoogleSignInThroughApiCommandOutputDataOutputToJson(this);
}

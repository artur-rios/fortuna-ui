// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'regenerate_recovery_codes_through_api_command_output.dart';

part 'regenerate_recovery_codes_through_api_command_output_data_output.g.dart';

@JsonSerializable()
class RegenerateRecoveryCodesThroughApiCommandOutputDataOutput {
  const RegenerateRecoveryCodesThroughApiCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory RegenerateRecoveryCodesThroughApiCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RegenerateRecoveryCodesThroughApiCommandOutputDataOutputFromJson(json);

  final RegenerateRecoveryCodesThroughApiCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$RegenerateRecoveryCodesThroughApiCommandOutputDataOutputToJson(this);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'get_two_factor_status_through_api_command_output.dart';

part 'get_two_factor_status_through_api_command_output_data_output.g.dart';

@JsonSerializable()
class GetTwoFactorStatusThroughApiCommandOutputDataOutput {
  const GetTwoFactorStatusThroughApiCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory GetTwoFactorStatusThroughApiCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$GetTwoFactorStatusThroughApiCommandOutputDataOutputFromJson(json);

  final GetTwoFactorStatusThroughApiCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$GetTwoFactorStatusThroughApiCommandOutputDataOutputToJson(this);
}

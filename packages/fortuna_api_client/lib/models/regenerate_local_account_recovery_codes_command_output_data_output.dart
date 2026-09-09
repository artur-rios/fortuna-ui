// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'regenerate_local_account_recovery_codes_command_output.dart';

part 'regenerate_local_account_recovery_codes_command_output_data_output.g.dart';

@JsonSerializable()
class RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput {
  const RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RegenerateLocalAccountRecoveryCodesCommandOutputDataOutputFromJson(
    json,
  );

  final RegenerateLocalAccountRecoveryCodesCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$RegenerateLocalAccountRecoveryCodesCommandOutputDataOutputToJson(this);
}

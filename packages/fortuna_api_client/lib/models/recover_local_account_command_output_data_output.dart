// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'recover_local_account_command_output.dart';

part 'recover_local_account_command_output_data_output.g.dart';

@JsonSerializable()
class RecoverLocalAccountCommandOutputDataOutput {
  const RecoverLocalAccountCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory RecoverLocalAccountCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecoverLocalAccountCommandOutputDataOutputFromJson(json);

  final RecoverLocalAccountCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$RecoverLocalAccountCommandOutputDataOutputToJson(this);
}

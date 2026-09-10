// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'request_personal_data_export_command_output.dart';

part 'request_personal_data_export_command_output_data_output.g.dart';

@JsonSerializable()
class RequestPersonalDataExportCommandOutputDataOutput {
  const RequestPersonalDataExportCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory RequestPersonalDataExportCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RequestPersonalDataExportCommandOutputDataOutputFromJson(json);

  final RequestPersonalDataExportCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$RequestPersonalDataExportCommandOutputDataOutputToJson(this);
}

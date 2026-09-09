// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'retry_import_job_command_output.dart';

part 'retry_import_job_command_output_data_output.g.dart';

@JsonSerializable()
class RetryImportJobCommandOutputDataOutput {
  const RetryImportJobCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory RetryImportJobCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RetryImportJobCommandOutputDataOutputFromJson(json);

  final RetryImportJobCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$RetryImportJobCommandOutputDataOutputToJson(this);
}

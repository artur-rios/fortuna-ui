// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'synchronize_connection_command_output.dart';

part 'synchronize_connection_command_output_data_output.g.dart';

@JsonSerializable()
class SynchronizeConnectionCommandOutputDataOutput {
  const SynchronizeConnectionCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory SynchronizeConnectionCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$SynchronizeConnectionCommandOutputDataOutputFromJson(json);

  final SynchronizeConnectionCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$SynchronizeConnectionCommandOutputDataOutputToJson(this);
}

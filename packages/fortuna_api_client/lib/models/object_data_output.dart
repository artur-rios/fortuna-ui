// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'object_data_output.g.dart';

@JsonSerializable()
class ObjectDataOutput {
  const ObjectDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory ObjectDataOutput.fromJson(Map<String, Object?> json) =>
      _$ObjectDataOutputFromJson(json);

  final dynamic data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$ObjectDataOutputToJson(this);
}

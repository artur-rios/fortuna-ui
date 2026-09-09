// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'net_position_output.dart';

part 'net_position_output_data_output.g.dart';

@JsonSerializable()
class NetPositionOutputDataOutput {
  const NetPositionOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory NetPositionOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$NetPositionOutputDataOutputFromJson(json);

  final NetPositionOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$NetPositionOutputDataOutputToJson(this);
}

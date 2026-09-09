// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_source_list_output.dart';

part 'data_source_list_output_data_output.g.dart';

@JsonSerializable()
class DataSourceListOutputDataOutput {
  const DataSourceListOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory DataSourceListOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$DataSourceListOutputDataOutputFromJson(json);

  final DataSourceListOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$DataSourceListOutputDataOutputToJson(this);
}

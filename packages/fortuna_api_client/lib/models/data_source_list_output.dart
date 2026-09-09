// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_source_output.dart';

part 'data_source_list_output.g.dart';

@JsonSerializable()
class DataSourceListOutput {
  const DataSourceListOutput({this.sources});

  factory DataSourceListOutput.fromJson(Map<String, Object?> json) =>
      _$DataSourceListOutputFromJson(json);

  final List<DataSourceOutput>? sources;

  Map<String, Object?> toJson() => _$DataSourceListOutputToJson(this);
}

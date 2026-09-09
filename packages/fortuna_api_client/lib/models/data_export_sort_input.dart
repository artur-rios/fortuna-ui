// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'data_export_sort_input.g.dart';

@JsonSerializable()
class DataExportSortInput {
  const DataExportSortInput({this.descending, this.field});

  factory DataExportSortInput.fromJson(Map<String, Object?> json) =>
      _$DataExportSortInputFromJson(json);

  final bool? descending;
  final String? field;

  Map<String, Object?> toJson() => _$DataExportSortInputToJson(this);
}

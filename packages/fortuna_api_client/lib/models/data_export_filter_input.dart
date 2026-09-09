// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'data_export_filter_input.g.dart';

@JsonSerializable()
class DataExportFilterInput {
  const DataExportFilterInput({this.field, this.operatorValue, this.value});

  factory DataExportFilterInput.fromJson(Map<String, Object?> json) =>
      _$DataExportFilterInputFromJson(json);

  final String? field;

  /// The name has been replaced because it contains a keyword. Original name: `operator`.
  @JsonKey(name: 'operator')
  final String? operatorValue;
  final String? value;

  Map<String, Object?> toJson() => _$DataExportFilterInputToJson(this);
}

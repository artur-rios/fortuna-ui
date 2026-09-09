// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'table_filter_input.g.dart';

@JsonSerializable()
class TableFilterInput {
  const TableFilterInput({this.field, this.operatorValue, this.value});

  factory TableFilterInput.fromJson(Map<String, Object?> json) =>
      _$TableFilterInputFromJson(json);

  final String? field;

  /// The name has been replaced because it contains a keyword. Original name: `operator`.
  @JsonKey(name: 'operator')
  final String? operatorValue;
  final String? value;

  Map<String, Object?> toJson() => _$TableFilterInputToJson(this);
}

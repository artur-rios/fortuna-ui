// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'table_column_type.dart';

part 'table_column_output.g.dart';

@JsonSerializable()
class TableColumnOutput {
  const TableColumnOutput({
    this.currencyColumn,
    this.isNumeric,
    this.name,
    this.type,
  });

  factory TableColumnOutput.fromJson(Map<String, Object?> json) =>
      _$TableColumnOutputFromJson(json);

  final String? currencyColumn;
  final bool? isNumeric;
  final String? name;
  final TableColumnType? type;

  Map<String, Object?> toJson() => _$TableColumnOutputToJson(this);
}

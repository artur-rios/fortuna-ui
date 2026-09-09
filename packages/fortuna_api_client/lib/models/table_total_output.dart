// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'table_total_conversion_output.dart';

part 'table_total_output.g.dart';

@JsonSerializable()
class TableTotalOutput {
  const TableTotalOutput({
    this.column,
    this.conversions,
    this.currencyCode,
    this.isFullyConverted,
    this.value,
  });

  factory TableTotalOutput.fromJson(Map<String, Object?> json) =>
      _$TableTotalOutputFromJson(json);

  final String? column;
  final List<TableTotalConversionOutput>? conversions;
  final String? currencyCode;
  final bool? isFullyConverted;
  final double? value;

  Map<String, Object?> toJson() => _$TableTotalOutputToJson(this);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'table_report_output.dart';

part 'table_report_output_data_output.g.dart';

@JsonSerializable()
class TableReportOutputDataOutput {
  const TableReportOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory TableReportOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$TableReportOutputDataOutputFromJson(json);

  final TableReportOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$TableReportOutputDataOutputToJson(this);
}

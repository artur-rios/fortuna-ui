// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'table_column_output.dart';
import 'table_total_output.dart';

part 'table_report_output.g.dart';

@JsonSerializable()
class TableReportOutput {
  const TableReportOutput({
    this.columns,
    this.pageNumber,
    this.pageSize,
    this.recordSet,
    this.rows,
    this.totalCount,
    this.totals,
  });

  factory TableReportOutput.fromJson(Map<String, Object?> json) =>
      _$TableReportOutputFromJson(json);

  final List<TableColumnOutput>? columns;
  final int? pageNumber;
  final int? pageSize;
  final String? recordSet;
  final List<Map<String, dynamic>>? rows;
  final int? totalCount;
  final List<TableTotalOutput>? totals;

  Map<String, Object?> toJson() => _$TableReportOutputToJson(this);
}

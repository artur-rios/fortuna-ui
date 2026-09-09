// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'table_filter_input.dart';
import 'table_sort_input.dart';

part 'query_records_as_table_query.g.dart';

@JsonSerializable()
class QueryRecordsAsTableQuery {
  const QueryRecordsAsTableQuery({
    this.columns,
    this.displayCurrencyCode,
    this.filters,
    this.pageNumber,
    this.pageSize,
    this.recordSet,
    this.sorts,
  });

  factory QueryRecordsAsTableQuery.fromJson(Map<String, Object?> json) =>
      _$QueryRecordsAsTableQueryFromJson(json);

  final List<String>? columns;
  final String? displayCurrencyCode;
  final List<TableFilterInput>? filters;
  final int? pageNumber;
  final int? pageSize;
  final String? recordSet;
  final List<TableSortInput>? sorts;

  Map<String, Object?> toJson() => _$QueryRecordsAsTableQueryToJson(this);
}

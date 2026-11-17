// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_report_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableReportOutput _$TableReportOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'columns',
      'missingRates',
      'pageNumber',
      'pageSize',
      'recordSet',
      'rows',
      'totalCount',
      'totals',
    ],
    disallowNullValues: const ['pageNumber', 'pageSize', 'totalCount'],
  );
  return TableReportOutput(
    columns: !json.containsKey('columns')
        ? null
        : TableReportOutput._read_columns(json['columns']),
    missingRates: !json.containsKey('missingRates')
        ? null
        : TableReportOutput._read_missingRates(json['missingRates']),
    pageNumber: TableReportOutput._read_pageNumber(json['pageNumber']),
    pageSize: TableReportOutput._read_pageSize(json['pageSize']),
    recordSet: !json.containsKey('recordSet')
        ? null
        : TableReportOutput._read_recordSet(json['recordSet']),
    rows: !json.containsKey('rows')
        ? null
        : TableReportOutput._read_rows(json['rows']),
    totalCount: TableReportOutput._read_totalCount(json['totalCount']),
    totals: !json.containsKey('totals')
        ? null
        : TableReportOutput._read_totals(json['totals']),
  );
}

Map<String, dynamic> _$TableReportOutputToJson(TableReportOutput instance) =>
    <String, dynamic>{
      if (instance.columns case final $value?)
        'columns': TableReportOutput._write_columns($value),
      if (instance.missingRates case final $value?)
        'missingRates': TableReportOutput._write_missingRates($value),
      'pageNumber': ?TableReportOutput._write_pageNumber(instance.pageNumber),
      'pageSize': ?TableReportOutput._write_pageSize(instance.pageSize),
      if (instance.recordSet case final $value?)
        'recordSet': TableReportOutput._write_recordSet($value),
      if (instance.rows case final $value?)
        'rows': TableReportOutput._write_rows($value),
      'totalCount': ?TableReportOutput._write_totalCount(instance.totalCount),
      if (instance.totals case final $value?)
        'totals': TableReportOutput._write_totals($value),
    };

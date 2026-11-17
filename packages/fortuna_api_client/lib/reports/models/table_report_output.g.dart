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
    columns: (json['columns'] as List<dynamic>?)
        ?.map((e) => TableColumnOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    missingRates: (json['missingRates'] as List<dynamic>?)
        ?.map(
          (e) => MissingExchangeRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    pageNumber: TableReportOutput._read_pageNumber(json['pageNumber']),
    pageSize: TableReportOutput._read_pageSize(json['pageSize']),
    recordSet: json['recordSet'] as String?,
    rows: (json['rows'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    totalCount: TableReportOutput._read_totalCount(json['totalCount']),
    totals: (json['totals'] as List<dynamic>?)
        ?.map((e) => TableTotalOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TableReportOutputToJson(TableReportOutput instance) =>
    <String, dynamic>{
      'columns': ?instance.columns?.map((e) => e.toJson()).toList(),
      'missingRates': ?instance.missingRates?.map((e) => e.toJson()).toList(),
      'pageNumber': ?TableReportOutput._write_pageNumber(instance.pageNumber),
      'pageSize': ?TableReportOutput._write_pageSize(instance.pageSize),
      'recordSet': ?instance.recordSet,
      'rows': ?instance.rows,
      'totalCount': ?TableReportOutput._write_totalCount(instance.totalCount),
      'totals': ?instance.totals?.map((e) => e.toJson()).toList(),
    };

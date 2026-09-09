// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_report_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableReportOutput _$TableReportOutputFromJson(Map<String, dynamic> json) =>
    TableReportOutput(
      columns: (json['columns'] as List<dynamic>?)
          ?.map((e) => TableColumnOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      recordSet: json['recordSet'] as String?,
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      totals: (json['totals'] as List<dynamic>?)
          ?.map((e) => TableTotalOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TableReportOutputToJson(TableReportOutput instance) =>
    <String, dynamic>{
      'columns': instance.columns,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'recordSet': instance.recordSet,
      'rows': instance.rows,
      'totalCount': instance.totalCount,
      'totals': instance.totals,
    };

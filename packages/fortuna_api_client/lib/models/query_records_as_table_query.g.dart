// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_records_as_table_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryRecordsAsTableQuery _$QueryRecordsAsTableQueryFromJson(
  Map<String, dynamic> json,
) => QueryRecordsAsTableQuery(
  columns: (json['columns'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  filters: (json['filters'] as List<dynamic>?)
      ?.map((e) => TableFilterInput.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  recordSet: json['recordSet'] as String?,
  sorts: (json['sorts'] as List<dynamic>?)
      ?.map((e) => TableSortInput.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryRecordsAsTableQueryToJson(
  QueryRecordsAsTableQuery instance,
) => <String, dynamic>{
  'columns': instance.columns,
  'displayCurrencyCode': instance.displayCurrencyCode,
  'filters': instance.filters,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'recordSet': instance.recordSet,
  'sorts': instance.sorts,
};

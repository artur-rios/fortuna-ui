// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_records_as_table_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryRecordsAsTableQuery _$QueryRecordsAsTableQueryFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'columns',
      'displayCurrencyCode',
      'filters',
      'pageNumber',
      'pageSize',
      'recordSet',
      'sorts',
    ],
    disallowNullValues: const ['pageNumber', 'pageSize'],
  );
  return QueryRecordsAsTableQuery(
    columns: (json['columns'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    filters: (json['filters'] as List<dynamic>?)
        ?.map((e) => TableFilterInput.fromJson(e as Map<String, dynamic>))
        .toList(),
    pageNumber: QueryRecordsAsTableQuery._read_pageNumber(json['pageNumber']),
    pageSize: QueryRecordsAsTableQuery._read_pageSize(json['pageSize']),
    recordSet: json['recordSet'] as String?,
    sorts: (json['sorts'] as List<dynamic>?)
        ?.map((e) => TableSortInput.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$QueryRecordsAsTableQueryToJson(
  QueryRecordsAsTableQuery instance,
) => <String, dynamic>{
  'columns': ?instance.columns,
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'filters': ?instance.filters?.map((e) => e.toJson()).toList(),
  'pageNumber': ?QueryRecordsAsTableQuery._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?QueryRecordsAsTableQuery._write_pageSize(instance.pageSize),
  'recordSet': ?instance.recordSet,
  'sorts': ?instance.sorts?.map((e) => e.toJson()).toList(),
};

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
    columns: !json.containsKey('columns')
        ? null
        : QueryRecordsAsTableQuery._read_columns(json['columns']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : QueryRecordsAsTableQuery._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    filters: !json.containsKey('filters')
        ? null
        : QueryRecordsAsTableQuery._read_filters(json['filters']),
    pageNumber: QueryRecordsAsTableQuery._read_pageNumber(json['pageNumber']),
    pageSize: QueryRecordsAsTableQuery._read_pageSize(json['pageSize']),
    recordSet: !json.containsKey('recordSet')
        ? null
        : QueryRecordsAsTableQuery._read_recordSet(json['recordSet']),
    sorts: !json.containsKey('sorts')
        ? null
        : QueryRecordsAsTableQuery._read_sorts(json['sorts']),
  );
}

Map<String, dynamic> _$QueryRecordsAsTableQueryToJson(
  QueryRecordsAsTableQuery instance,
) => <String, dynamic>{
  if (instance.columns case final $value?)
    'columns': QueryRecordsAsTableQuery._write_columns($value),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode': QueryRecordsAsTableQuery._write_displayCurrencyCode(
      $value,
    ),
  if (instance.filters case final $value?)
    'filters': QueryRecordsAsTableQuery._write_filters($value),
  'pageNumber': ?QueryRecordsAsTableQuery._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?QueryRecordsAsTableQuery._write_pageSize(instance.pageSize),
  if (instance.recordSet case final $value?)
    'recordSet': QueryRecordsAsTableQuery._write_recordSet($value),
  if (instance.sorts case final $value?)
    'sorts': QueryRecordsAsTableQuery._write_sorts($value),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_total_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableTotalOutput _$TableTotalOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'column',
      'conversions',
      'currencyCode',
      'isFullyConverted',
      'value',
    ],
    disallowNullValues: const ['isFullyConverted'],
  );
  return TableTotalOutput(
    column: !json.containsKey('column')
        ? null
        : TableTotalOutput._read_column(json['column']),
    conversions: !json.containsKey('conversions')
        ? null
        : TableTotalOutput._read_conversions(json['conversions']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : TableTotalOutput._read_currencyCode(json['currencyCode']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    value: !json.containsKey('value')
        ? null
        : TableTotalOutput._read_value(json['value']),
  );
}

Map<String, dynamic> _$TableTotalOutputToJson(TableTotalOutput instance) =>
    <String, dynamic>{
      if (instance.column case final $value?)
        'column': TableTotalOutput._write_column($value),
      if (instance.conversions case final $value?)
        'conversions': TableTotalOutput._write_conversions($value),
      if (instance.currencyCode case final $value?)
        'currencyCode': TableTotalOutput._write_currencyCode($value),
      'isFullyConverted': ?instance.isFullyConverted,
      if (instance.value case final $value?)
        'value': TableTotalOutput._write_value($value),
    };

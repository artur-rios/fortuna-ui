// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_column_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableColumnOutput _$TableColumnOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['currencyColumn', 'isNumeric', 'name', 'type'],
    disallowNullValues: const ['isNumeric', 'type'],
  );
  return TableColumnOutput(
    currencyColumn: !json.containsKey('currencyColumn')
        ? null
        : TableColumnOutput._read_currencyColumn(json['currencyColumn']),
    isNumeric: json['isNumeric'] as bool?,
    name: !json.containsKey('name')
        ? null
        : TableColumnOutput._read_name(json['name']),
    type: TableColumnOutput._read_type(json['type']),
  );
}

Map<String, dynamic> _$TableColumnOutputToJson(TableColumnOutput instance) =>
    <String, dynamic>{
      if (instance.currencyColumn case final $value?)
        'currencyColumn': TableColumnOutput._write_currencyColumn($value),
      'isNumeric': ?instance.isNumeric,
      if (instance.name case final $value?)
        'name': TableColumnOutput._write_name($value),
      'type': ?TableColumnOutput._write_type(instance.type),
    };

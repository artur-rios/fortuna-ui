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
    currencyColumn: json['currencyColumn'] as String?,
    isNumeric: json['isNumeric'] as bool?,
    name: json['name'] as String?,
    type: TableColumnOutput._read_type(json['type']),
  );
}

Map<String, dynamic> _$TableColumnOutputToJson(TableColumnOutput instance) =>
    <String, dynamic>{
      'currencyColumn': ?instance.currencyColumn,
      'isNumeric': ?instance.isNumeric,
      'name': ?instance.name,
      'type': ?TableColumnOutput._write_type(instance.type),
    };

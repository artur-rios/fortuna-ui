// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_sort_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableSortInput _$TableSortInputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['descending', 'field'],
    disallowNullValues: const ['descending'],
  );
  return TableSortInput(
    descending: json['descending'] as bool?,
    field: !json.containsKey('field')
        ? null
        : TableSortInput._read_field(json['field']),
  );
}

Map<String, dynamic> _$TableSortInputToJson(TableSortInput instance) =>
    <String, dynamic>{
      'descending': ?instance.descending,
      if (instance.field case final $value?)
        'field': TableSortInput._write_field($value),
    };

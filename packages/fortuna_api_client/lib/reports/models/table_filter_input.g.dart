// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_filter_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableFilterInput _$TableFilterInputFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['field', 'operator', 'value']);
  return TableFilterInput(
    field: !json.containsKey('field')
        ? null
        : TableFilterInput._read_field(json['field']),
    operator2: !json.containsKey('operator')
        ? null
        : TableFilterInput._read_operator2(json['operator']),
    value: !json.containsKey('value')
        ? null
        : TableFilterInput._read_value(json['value']),
  );
}

Map<String, dynamic> _$TableFilterInputToJson(TableFilterInput instance) =>
    <String, dynamic>{
      if (instance.field case final $value?)
        'field': TableFilterInput._write_field($value),
      if (instance.operator2 case final $value?)
        'operator': TableFilterInput._write_operator2($value),
      if (instance.value case final $value?)
        'value': TableFilterInput._write_value($value),
    };

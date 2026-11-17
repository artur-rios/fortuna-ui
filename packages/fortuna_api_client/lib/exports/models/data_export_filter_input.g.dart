// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_export_filter_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataExportFilterInput _$DataExportFilterInputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['field', 'operator', 'value']);
  return DataExportFilterInput(
    field: !json.containsKey('field')
        ? null
        : DataExportFilterInput._read_field(json['field']),
    operator2: !json.containsKey('operator')
        ? null
        : DataExportFilterInput._read_operator2(json['operator']),
    value: !json.containsKey('value')
        ? null
        : DataExportFilterInput._read_value(json['value']),
  );
}

Map<String, dynamic> _$DataExportFilterInputToJson(
  DataExportFilterInput instance,
) => <String, dynamic>{
  if (instance.field case final $value?)
    'field': DataExportFilterInput._write_field($value),
  if (instance.operator2 case final $value?)
    'operator': DataExportFilterInput._write_operator2($value),
  if (instance.value case final $value?)
    'value': DataExportFilterInput._write_value($value),
};

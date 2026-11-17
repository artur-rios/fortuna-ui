// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_export_sort_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataExportSortInput _$DataExportSortInputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['descending', 'field'],
    disallowNullValues: const ['descending'],
  );
  return DataExportSortInput(
    descending: json['descending'] as bool?,
    field: !json.containsKey('field')
        ? null
        : DataExportSortInput._read_field(json['field']),
  );
}

Map<String, dynamic> _$DataExportSortInputToJson(
  DataExportSortInput instance,
) => <String, dynamic>{
  'descending': ?instance.descending,
  if (instance.field case final $value?)
    'field': DataExportSortInput._write_field($value),
};

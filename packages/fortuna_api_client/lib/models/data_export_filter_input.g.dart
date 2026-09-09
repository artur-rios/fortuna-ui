// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_export_filter_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataExportFilterInput _$DataExportFilterInputFromJson(
  Map<String, dynamic> json,
) => DataExportFilterInput(
  field: json['field'] as String?,
  operatorValue: json['operator'] as String?,
  value: json['value'] as String?,
);

Map<String, dynamic> _$DataExportFilterInputToJson(
  DataExportFilterInput instance,
) => <String, dynamic>{
  'field': instance.field,
  'operator': instance.operatorValue,
  'value': instance.value,
};

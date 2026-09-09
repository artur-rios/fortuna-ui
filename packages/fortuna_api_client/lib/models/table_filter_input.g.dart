// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_filter_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableFilterInput _$TableFilterInputFromJson(Map<String, dynamic> json) =>
    TableFilterInput(
      field: json['field'] as String?,
      operatorValue: json['operator'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$TableFilterInputToJson(TableFilterInput instance) =>
    <String, dynamic>{
      'field': instance.field,
      'operator': instance.operatorValue,
      'value': instance.value,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_column_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableColumnOutput _$TableColumnOutputFromJson(Map<String, dynamic> json) =>
    TableColumnOutput(
      currencyColumn: json['currencyColumn'] as String?,
      isNumeric: json['isNumeric'] as bool?,
      name: json['name'] as String?,
      type: json['type'] == null
          ? null
          : TableColumnType.fromJson((json['type'] as num).toInt()),
    );

Map<String, dynamic> _$TableColumnOutputToJson(TableColumnOutput instance) =>
    <String, dynamic>{
      'currencyColumn': instance.currencyColumn,
      'isNumeric': instance.isNumeric,
      'name': instance.name,
      'type': instance.type,
    };

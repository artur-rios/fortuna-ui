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
      'type': _$TableColumnTypeEnumMap[instance.type],
    };

const _$TableColumnTypeEnumMap = {
  TableColumnType.value1: 1,
  TableColumnType.value2: 2,
  TableColumnType.value3: 3,
  TableColumnType.value4: 4,
  TableColumnType.value5: 5,
  TableColumnType.value6: 6,
  TableColumnType.value7: 7,
  TableColumnType.value8: 8,
  TableColumnType.$unknown: r'$unknown',
};

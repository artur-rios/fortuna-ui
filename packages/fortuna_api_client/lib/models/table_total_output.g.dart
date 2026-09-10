// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_total_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableTotalOutput _$TableTotalOutputFromJson(Map<String, dynamic> json) =>
    TableTotalOutput(
      column: json['column'] as String?,
      conversions: (json['conversions'] as List<dynamic>?)
          ?.map(
            (e) =>
                TableTotalConversionOutput.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      currencyCode: json['currencyCode'] as String?,
      isFullyConverted: json['isFullyConverted'] as bool?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$TableTotalOutputToJson(TableTotalOutput instance) =>
    <String, dynamic>{
      'column': instance.column,
      'conversions': instance.conversions,
      'currencyCode': instance.currencyCode,
      'isFullyConverted': instance.isFullyConverted,
      'value': instance.value,
    };

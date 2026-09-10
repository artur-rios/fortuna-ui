// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_total_conversion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableTotalConversionOutput _$TableTotalConversionOutputFromJson(
  Map<String, dynamic> json,
) => TableTotalConversionOutput(
  appliedRate: json['appliedRate'] as String?,
  convertedValue: json['convertedValue'] as String?,
  figureDate: json['figureDate'] == null
      ? null
      : DateTime.parse(json['figureDate'] as String),
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
  sourceValue: json['sourceValue'] as String?,
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$TableTotalConversionOutputToJson(
  TableTotalConversionOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'convertedValue': instance.convertedValue,
  'figureDate': instance.figureDate?.toIso8601String(),
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': _$ExchangeRateSourceEnumMap[instance.rateSource],
  'sourceCurrencyCode': instance.sourceCurrencyCode,
  'sourceValue': instance.sourceValue,
  'unconvertedReason': instance.unconvertedReason,
};

const _$ExchangeRateSourceEnumMap = {
  ExchangeRateSource.value1: 1,
  ExchangeRateSource.value2: 2,
  ExchangeRateSource.$unknown: r'$unknown',
};

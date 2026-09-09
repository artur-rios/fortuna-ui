// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_total_conversion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableTotalConversionOutput _$TableTotalConversionOutputFromJson(
  Map<String, dynamic> json,
) => TableTotalConversionOutput(
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  convertedValue: (json['convertedValue'] as num?)?.toDouble(),
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
  sourceValue: (json['sourceValue'] as num?)?.toDouble(),
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$TableTotalConversionOutputToJson(
  TableTotalConversionOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'convertedValue': instance.convertedValue,
  'figureDate': instance.figureDate?.toIso8601String(),
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': instance.rateSource,
  'sourceCurrencyCode': instance.sourceCurrencyCode,
  'sourceValue': instance.sourceValue,
  'unconvertedReason': instance.unconvertedReason,
};

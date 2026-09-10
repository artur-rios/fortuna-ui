// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converted_currency_group_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertedCurrencyGroupOutput _$ConvertedCurrencyGroupOutputFromJson(
  Map<String, dynamic> json,
) => ConvertedCurrencyGroupOutput(
  appliedRate: json['appliedRate'] as String?,
  displayAmount: json['displayAmount'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  sourceAmount: json['sourceAmount'] as String?,
  sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$ConvertedCurrencyGroupOutputToJson(
  ConvertedCurrencyGroupOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'displayAmount': instance.displayAmount,
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': _$ExchangeRateSourceEnumMap[instance.rateSource],
  'sourceAmount': instance.sourceAmount,
  'sourceCurrencyCode': instance.sourceCurrencyCode,
  'unconvertedReason': instance.unconvertedReason,
};

const _$ExchangeRateSourceEnumMap = {
  ExchangeRateSource.value1: 1,
  ExchangeRateSource.value2: 2,
  ExchangeRateSource.$unknown: r'$unknown',
};

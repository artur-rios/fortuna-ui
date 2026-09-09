// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converted_currency_group_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertedCurrencyGroupOutput _$ConvertedCurrencyGroupOutputFromJson(
  Map<String, dynamic> json,
) => ConvertedCurrencyGroupOutput(
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  displayAmount: (json['displayAmount'] as num?)?.toDouble(),
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  sourceAmount: (json['sourceAmount'] as num?)?.toDouble(),
  sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$ConvertedCurrencyGroupOutputToJson(
  ConvertedCurrencyGroupOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'displayAmount': instance.displayAmount,
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': instance.rateSource,
  'sourceAmount': instance.sourceAmount,
  'sourceCurrencyCode': instance.sourceCurrencyCode,
  'unconvertedReason': instance.unconvertedReason,
};

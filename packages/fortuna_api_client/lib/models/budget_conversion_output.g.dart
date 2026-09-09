// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_conversion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConversionOutput _$BudgetConversionOutputFromJson(
  Map<String, dynamic> json,
) => BudgetConversionOutput(
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  convertedAmount: (json['convertedAmount'] as num?)?.toDouble(),
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

Map<String, dynamic> _$BudgetConversionOutputToJson(
  BudgetConversionOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'convertedAmount': instance.convertedAmount,
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

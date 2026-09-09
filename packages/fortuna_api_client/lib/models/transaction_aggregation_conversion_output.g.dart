// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_conversion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationConversionOutput
_$TransactionAggregationConversionOutputFromJson(Map<String, dynamic> json) =>
    TransactionAggregationConversionOutput(
      appliedRate: (json['appliedRate'] as num?)?.toDouble(),
      displayAmount: (json['displayAmount'] as num?)?.toDouble(),
      figureDate: json['figureDate'] == null
          ? null
          : DateTime.parse(json['figureDate'] as String),
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

Map<String, dynamic> _$TransactionAggregationConversionOutputToJson(
  TransactionAggregationConversionOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'displayAmount': instance.displayAmount,
  'figureDate': instance.figureDate?.toIso8601String(),
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_rate_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowRateOutput _$CashFlowRateOutputFromJson(Map<String, dynamic> json) =>
    CashFlowRateOutput(
      baseCurrencyCode: json['baseCurrencyCode'] as String?,
      quoteCurrencyCode: json['quoteCurrencyCode'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      source: json['source'] == null
          ? null
          : ExchangeRateSource.fromJson((json['source'] as num).toInt()),
    );

Map<String, dynamic> _$CashFlowRateOutputToJson(CashFlowRateOutput instance) =>
    <String, dynamic>{
      'baseCurrencyCode': instance.baseCurrencyCode,
      'quoteCurrencyCode': instance.quoteCurrencyCode,
      'rate': instance.rate,
      'rateDate': instance.rateDate?.toIso8601String(),
      'source': _$ExchangeRateSourceEnumMap[instance.source],
    };

const _$ExchangeRateSourceEnumMap = {
  ExchangeRateSource.value1: 1,
  ExchangeRateSource.value2: 2,
  ExchangeRateSource.$unknown: r'$unknown',
};

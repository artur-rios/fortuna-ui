// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_rate_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowRateOutput _$CashFlowRateOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'baseCurrencyCode',
      'quoteCurrencyCode',
      'rate',
      'rateDate',
      'source',
    ],
    disallowNullValues: const ['rate', 'rateDate', 'source'],
  );
  return CashFlowRateOutput(
    baseCurrencyCode: json['baseCurrencyCode'] as String?,
    quoteCurrencyCode: json['quoteCurrencyCode'] as String?,
    rate: json['rate'] as String?,
    rateDate: json['rateDate'] as String?,
    source: CashFlowRateOutput._read_source(json['source']),
  );
}

Map<String, dynamic> _$CashFlowRateOutputToJson(CashFlowRateOutput instance) =>
    <String, dynamic>{
      'baseCurrencyCode': ?instance.baseCurrencyCode,
      'quoteCurrencyCode': ?instance.quoteCurrencyCode,
      'rate': ?instance.rate,
      'rateDate': ?instance.rateDate,
      'source': ?CashFlowRateOutput._write_source(instance.source),
    };

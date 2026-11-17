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
    baseCurrencyCode: !json.containsKey('baseCurrencyCode')
        ? null
        : CashFlowRateOutput._read_baseCurrencyCode(json['baseCurrencyCode']),
    quoteCurrencyCode: !json.containsKey('quoteCurrencyCode')
        ? null
        : CashFlowRateOutput._read_quoteCurrencyCode(json['quoteCurrencyCode']),
    rate: json['rate'] as String?,
    rateDate: json['rateDate'] as String?,
    source: CashFlowRateOutput._read_source(json['source']),
  );
}

Map<String, dynamic> _$CashFlowRateOutputToJson(
  CashFlowRateOutput instance,
) => <String, dynamic>{
  if (instance.baseCurrencyCode case final $value?)
    'baseCurrencyCode': CashFlowRateOutput._write_baseCurrencyCode($value),
  if (instance.quoteCurrencyCode case final $value?)
    'quoteCurrencyCode': CashFlowRateOutput._write_quoteCurrencyCode($value),
  'rate': ?instance.rate,
  'rateDate': ?instance.rateDate,
  'source': ?CashFlowRateOutput._write_source(instance.source),
};

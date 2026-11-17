// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_rate_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationRateOutput _$CommittedObligationRateOutputFromJson(
  Map<String, dynamic> json,
) {
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
  return CommittedObligationRateOutput(
    baseCurrencyCode: json['baseCurrencyCode'] as String?,
    quoteCurrencyCode: json['quoteCurrencyCode'] as String?,
    rate: json['rate'] as String?,
    rateDate: json['rateDate'] as String?,
    source: CommittedObligationRateOutput._read_source(json['source']),
  );
}

Map<String, dynamic> _$CommittedObligationRateOutputToJson(
  CommittedObligationRateOutput instance,
) => <String, dynamic>{
  'baseCurrencyCode': ?instance.baseCurrencyCode,
  'quoteCurrencyCode': ?instance.quoteCurrencyCode,
  'rate': ?instance.rate,
  'rateDate': ?instance.rateDate,
  'source': ?CommittedObligationRateOutput._write_source(instance.source),
};

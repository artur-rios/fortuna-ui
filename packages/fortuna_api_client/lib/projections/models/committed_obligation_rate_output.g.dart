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
    baseCurrencyCode: !json.containsKey('baseCurrencyCode')
        ? null
        : CommittedObligationRateOutput._read_baseCurrencyCode(
            json['baseCurrencyCode'],
          ),
    quoteCurrencyCode: !json.containsKey('quoteCurrencyCode')
        ? null
        : CommittedObligationRateOutput._read_quoteCurrencyCode(
            json['quoteCurrencyCode'],
          ),
    rate: json['rate'] as String?,
    rateDate: json['rateDate'] as String?,
    source: CommittedObligationRateOutput._read_source(json['source']),
  );
}

Map<String, dynamic> _$CommittedObligationRateOutputToJson(
  CommittedObligationRateOutput instance,
) => <String, dynamic>{
  if (instance.baseCurrencyCode case final $value?)
    'baseCurrencyCode': CommittedObligationRateOutput._write_baseCurrencyCode(
      $value,
    ),
  if (instance.quoteCurrencyCode case final $value?)
    'quoteCurrencyCode': CommittedObligationRateOutput._write_quoteCurrencyCode(
      $value,
    ),
  'rate': ?instance.rate,
  'rateDate': ?instance.rateDate,
  'source': ?CommittedObligationRateOutput._write_source(instance.source),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_manual_exchange_rate_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordManualExchangeRateCommandOutput
_$RecordManualExchangeRateCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'baseCurrencyCode',
      'quoteCurrencyCode',
      'rate',
      'rateDate',
      'replacedExisting',
      'source',
      'takesPrecedence',
    ],
    disallowNullValues: const [
      'rate',
      'rateDate',
      'replacedExisting',
      'source',
      'takesPrecedence',
    ],
  );
  return RecordManualExchangeRateCommandOutput(
    baseCurrencyCode: !json.containsKey('baseCurrencyCode')
        ? null
        : RecordManualExchangeRateCommandOutput._read_baseCurrencyCode(
            json['baseCurrencyCode'],
          ),
    quoteCurrencyCode: !json.containsKey('quoteCurrencyCode')
        ? null
        : RecordManualExchangeRateCommandOutput._read_quoteCurrencyCode(
            json['quoteCurrencyCode'],
          ),
    rate: json['rate'] as String?,
    rateDate: json['rateDate'] as String?,
    replacedExisting: json['replacedExisting'] as bool?,
    source: RecordManualExchangeRateCommandOutput._read_source(json['source']),
    takesPrecedence: json['takesPrecedence'] as bool?,
  );
}

Map<String, dynamic> _$RecordManualExchangeRateCommandOutputToJson(
  RecordManualExchangeRateCommandOutput instance,
) => <String, dynamic>{
  if (instance.baseCurrencyCode case final $value?)
    'baseCurrencyCode':
        RecordManualExchangeRateCommandOutput._write_baseCurrencyCode($value),
  if (instance.quoteCurrencyCode case final $value?)
    'quoteCurrencyCode':
        RecordManualExchangeRateCommandOutput._write_quoteCurrencyCode($value),
  'rate': ?instance.rate,
  'rateDate': ?instance.rateDate,
  'replacedExisting': ?instance.replacedExisting,
  'source': ?RecordManualExchangeRateCommandOutput._write_source(
    instance.source,
  ),
  'takesPrecedence': ?instance.takesPrecedence,
};

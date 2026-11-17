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
    baseCurrencyCode: json['baseCurrencyCode'] as String?,
    quoteCurrencyCode: json['quoteCurrencyCode'] as String?,
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
  'baseCurrencyCode': ?instance.baseCurrencyCode,
  'quoteCurrencyCode': ?instance.quoteCurrencyCode,
  'rate': ?instance.rate,
  'rateDate': ?instance.rateDate,
  'replacedExisting': ?instance.replacedExisting,
  'source': ?RecordManualExchangeRateCommandOutput._write_source(
    instance.source,
  ),
  'takesPrecedence': ?instance.takesPrecedence,
};

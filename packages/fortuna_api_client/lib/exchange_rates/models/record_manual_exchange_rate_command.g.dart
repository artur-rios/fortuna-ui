// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_manual_exchange_rate_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordManualExchangeRateCommand _$RecordManualExchangeRateCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'baseCurrencyCode',
      'quoteCurrencyCode',
      'rate',
      'rateDate',
    ],
    disallowNullValues: const ['rate', 'rateDate'],
  );
  return RecordManualExchangeRateCommand(
    baseCurrencyCode: !json.containsKey('baseCurrencyCode')
        ? null
        : RecordManualExchangeRateCommand._read_baseCurrencyCode(
            json['baseCurrencyCode'],
          ),
    quoteCurrencyCode: !json.containsKey('quoteCurrencyCode')
        ? null
        : RecordManualExchangeRateCommand._read_quoteCurrencyCode(
            json['quoteCurrencyCode'],
          ),
    rate: json['rate'] as String?,
    rateDate: json['rateDate'] as String?,
  );
}

Map<String, dynamic> _$RecordManualExchangeRateCommandToJson(
  RecordManualExchangeRateCommand instance,
) => <String, dynamic>{
  if (instance.baseCurrencyCode case final $value?)
    'baseCurrencyCode': RecordManualExchangeRateCommand._write_baseCurrencyCode(
      $value,
    ),
  if (instance.quoteCurrencyCode case final $value?)
    'quoteCurrencyCode':
        RecordManualExchangeRateCommand._write_quoteCurrencyCode($value),
  'rate': ?instance.rate,
  'rateDate': ?instance.rateDate,
};

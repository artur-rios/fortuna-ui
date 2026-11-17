// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_exchange_rate_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissingExchangeRateOutput _$MissingExchangeRateOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['baseCurrencyCode', 'quoteCurrencyCode'],
  );
  return MissingExchangeRateOutput(
    baseCurrencyCode: !json.containsKey('baseCurrencyCode')
        ? null
        : MissingExchangeRateOutput._read_baseCurrencyCode(
            json['baseCurrencyCode'],
          ),
    quoteCurrencyCode: !json.containsKey('quoteCurrencyCode')
        ? null
        : MissingExchangeRateOutput._read_quoteCurrencyCode(
            json['quoteCurrencyCode'],
          ),
  );
}

Map<String, dynamic> _$MissingExchangeRateOutputToJson(
  MissingExchangeRateOutput instance,
) => <String, dynamic>{
  if (instance.baseCurrencyCode case final $value?)
    'baseCurrencyCode': MissingExchangeRateOutput._write_baseCurrencyCode(
      $value,
    ),
  if (instance.quoteCurrencyCode case final $value?)
    'quoteCurrencyCode': MissingExchangeRateOutput._write_quoteCurrencyCode(
      $value,
    ),
};

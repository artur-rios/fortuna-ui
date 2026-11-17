// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converted_currency_group_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertedCurrencyGroupOutput _$ConvertedCurrencyGroupOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'displayAmount',
      'rateDate',
      'rateSource',
      'sourceAmount',
      'sourceCurrencyCode',
      'unconvertedReason',
    ],
    disallowNullValues: const ['rateSource', 'sourceAmount'],
  );
  return ConvertedCurrencyGroupOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : ConvertedCurrencyGroupOutput._read_appliedRate(json['appliedRate']),
    displayAmount: !json.containsKey('displayAmount')
        ? null
        : ConvertedCurrencyGroupOutput._read_displayAmount(
            json['displayAmount'],
          ),
    rateDate: !json.containsKey('rateDate')
        ? null
        : ConvertedCurrencyGroupOutput._read_rateDate(json['rateDate']),
    rateSource: ConvertedCurrencyGroupOutput._read_rateSource(
      json['rateSource'],
    ),
    sourceAmount: json['sourceAmount'] as String?,
    sourceCurrencyCode: !json.containsKey('sourceCurrencyCode')
        ? null
        : ConvertedCurrencyGroupOutput._read_sourceCurrencyCode(
            json['sourceCurrencyCode'],
          ),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : ConvertedCurrencyGroupOutput._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$ConvertedCurrencyGroupOutputToJson(
  ConvertedCurrencyGroupOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': ConvertedCurrencyGroupOutput._write_appliedRate($value),
  if (instance.displayAmount case final $value?)
    'displayAmount': ConvertedCurrencyGroupOutput._write_displayAmount($value),
  if (instance.rateDate case final $value?)
    'rateDate': ConvertedCurrencyGroupOutput._write_rateDate($value),
  'rateSource': ?ConvertedCurrencyGroupOutput._write_rateSource(
    instance.rateSource,
  ),
  'sourceAmount': ?instance.sourceAmount,
  if (instance.sourceCurrencyCode case final $value?)
    'sourceCurrencyCode':
        ConvertedCurrencyGroupOutput._write_sourceCurrencyCode($value),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason': ConvertedCurrencyGroupOutput._write_unconvertedReason(
      $value,
    ),
};

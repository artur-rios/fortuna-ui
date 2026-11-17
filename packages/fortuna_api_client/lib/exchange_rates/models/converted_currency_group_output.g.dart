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
    disallowNullValues: const ['sourceAmount'],
  );
  return ConvertedCurrencyGroupOutput(
    appliedRate: json['appliedRate'] as String?,
    displayAmount: json['displayAmount'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: ConvertedCurrencyGroupOutput._read_rateSource(
      json['rateSource'],
    ),
    sourceAmount: json['sourceAmount'] as String?,
    sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$ConvertedCurrencyGroupOutputToJson(
  ConvertedCurrencyGroupOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'displayAmount': ?instance.displayAmount,
  'rateDate': ?instance.rateDate,
  'rateSource': ?ConvertedCurrencyGroupOutput._write_rateSource(
    instance.rateSource,
  ),
  'sourceAmount': ?instance.sourceAmount,
  'sourceCurrencyCode': ?instance.sourceCurrencyCode,
  'unconvertedReason': ?instance.unconvertedReason,
};

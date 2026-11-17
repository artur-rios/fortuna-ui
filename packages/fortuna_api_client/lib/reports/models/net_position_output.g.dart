// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_position_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetPositionOutput _$NetPositionOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'asOf',
      'currencyGroups',
      'displayCurrencyCode',
      'isFullyConverted',
      'missingRates',
      'total',
    ],
    disallowNullValues: const ['asOf', 'isFullyConverted'],
  );
  return NetPositionOutput(
    asOf: json['asOf'] as String?,
    currencyGroups: !json.containsKey('currencyGroups')
        ? null
        : NetPositionOutput._read_currencyGroups(json['currencyGroups']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : NetPositionOutput._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: !json.containsKey('missingRates')
        ? null
        : NetPositionOutput._read_missingRates(json['missingRates']),
    total: !json.containsKey('total')
        ? null
        : NetPositionOutput._read_total(json['total']),
  );
}

Map<String, dynamic> _$NetPositionOutputToJson(
  NetPositionOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  if (instance.currencyGroups case final $value?)
    'currencyGroups': NetPositionOutput._write_currencyGroups($value),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode': NetPositionOutput._write_displayCurrencyCode($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.missingRates case final $value?)
    'missingRates': NetPositionOutput._write_missingRates($value),
  if (instance.total case final $value?)
    'total': NetPositionOutput._write_total($value),
};

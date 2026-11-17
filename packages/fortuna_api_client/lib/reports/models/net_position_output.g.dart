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
    currencyGroups: (json['currencyGroups'] as List<dynamic>?)
        ?.map(
          (e) => NetPositionCurrencyOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: (json['missingRates'] as List<dynamic>?)
        ?.map(
          (e) => MissingExchangeRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$NetPositionOutputToJson(
  NetPositionOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  'currencyGroups': ?instance.currencyGroups?.map((e) => e.toJson()).toList(),
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'isFullyConverted': ?instance.isFullyConverted,
  'missingRates': ?instance.missingRates?.map((e) => e.toJson()).toList(),
  'total': ?instance.total,
};

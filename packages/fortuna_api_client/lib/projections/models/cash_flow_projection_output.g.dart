// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_projection_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowProjectionOutput _$CashFlowProjectionOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'asOf',
      'displayCurrencyCode',
      'estimateOmittedReason',
      'flatReason',
      'isFullyConverted',
      'missingRates',
      'periodicity',
      'periods',
      'rates',
      'startingBalance',
      'through',
    ],
    disallowNullValues: const [
      'asOf',
      'isFullyConverted',
      'periodicity',
      'startingBalance',
      'through',
    ],
  );
  return CashFlowProjectionOutput(
    asOf: json['asOf'] as String?,
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    estimateOmittedReason: json['estimateOmittedReason'] as String?,
    flatReason: json['flatReason'] as String?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: (json['missingRates'] as List<dynamic>?)
        ?.map(
          (e) => MissingExchangeRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    periodicity: CashFlowProjectionOutput._read_periodicity(
      json['periodicity'],
    ),
    periods: (json['periods'] as List<dynamic>?)
        ?.map((e) => CashFlowPeriodOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    rates: (json['rates'] as List<dynamic>?)
        ?.map((e) => CashFlowRateOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    startingBalance: json['startingBalance'] as String?,
    through: json['through'] as String?,
  );
}

Map<String, dynamic> _$CashFlowProjectionOutputToJson(
  CashFlowProjectionOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'estimateOmittedReason': ?instance.estimateOmittedReason,
  'flatReason': ?instance.flatReason,
  'isFullyConverted': ?instance.isFullyConverted,
  'missingRates': ?instance.missingRates?.map((e) => e.toJson()).toList(),
  'periodicity': ?CashFlowProjectionOutput._write_periodicity(
    instance.periodicity,
  ),
  'periods': ?instance.periods?.map((e) => e.toJson()).toList(),
  'rates': ?instance.rates?.map((e) => e.toJson()).toList(),
  'startingBalance': ?instance.startingBalance,
  'through': ?instance.through,
};

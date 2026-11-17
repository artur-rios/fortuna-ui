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
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : CashFlowProjectionOutput._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    estimateOmittedReason: !json.containsKey('estimateOmittedReason')
        ? null
        : CashFlowProjectionOutput._read_estimateOmittedReason(
            json['estimateOmittedReason'],
          ),
    flatReason: !json.containsKey('flatReason')
        ? null
        : CashFlowProjectionOutput._read_flatReason(json['flatReason']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: !json.containsKey('missingRates')
        ? null
        : CashFlowProjectionOutput._read_missingRates(json['missingRates']),
    periodicity: CashFlowProjectionOutput._read_periodicity(
      json['periodicity'],
    ),
    periods: !json.containsKey('periods')
        ? null
        : CashFlowProjectionOutput._read_periods(json['periods']),
    rates: !json.containsKey('rates')
        ? null
        : CashFlowProjectionOutput._read_rates(json['rates']),
    startingBalance: json['startingBalance'] as String?,
    through: json['through'] as String?,
  );
}

Map<String, dynamic> _$CashFlowProjectionOutputToJson(
  CashFlowProjectionOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode': CashFlowProjectionOutput._write_displayCurrencyCode(
      $value,
    ),
  if (instance.estimateOmittedReason case final $value?)
    'estimateOmittedReason':
        CashFlowProjectionOutput._write_estimateOmittedReason($value),
  if (instance.flatReason case final $value?)
    'flatReason': CashFlowProjectionOutput._write_flatReason($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.missingRates case final $value?)
    'missingRates': CashFlowProjectionOutput._write_missingRates($value),
  'periodicity': ?CashFlowProjectionOutput._write_periodicity(
    instance.periodicity,
  ),
  if (instance.periods case final $value?)
    'periods': CashFlowProjectionOutput._write_periods($value),
  if (instance.rates case final $value?)
    'rates': CashFlowProjectionOutput._write_rates($value),
  'startingBalance': ?instance.startingBalance,
  'through': ?instance.through,
};

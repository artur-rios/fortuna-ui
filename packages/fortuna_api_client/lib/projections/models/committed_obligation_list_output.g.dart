// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationListOutput _$CommittedObligationListOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'asOf',
      'displayCurrencyCode',
      'isFullyConverted',
      'items',
      'missingRates',
      'periods',
      'rates',
      'through',
      'total',
    ],
    disallowNullValues: const ['asOf', 'isFullyConverted', 'through'],
  );
  return CommittedObligationListOutput(
    asOf: json['asOf'] as String?,
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : CommittedObligationListOutput._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    isFullyConverted: json['isFullyConverted'] as bool?,
    items: !json.containsKey('items')
        ? null
        : CommittedObligationListOutput._read_items(json['items']),
    missingRates: !json.containsKey('missingRates')
        ? null
        : CommittedObligationListOutput._read_missingRates(
            json['missingRates'],
          ),
    periods: !json.containsKey('periods')
        ? null
        : CommittedObligationListOutput._read_periods(json['periods']),
    rates: !json.containsKey('rates')
        ? null
        : CommittedObligationListOutput._read_rates(json['rates']),
    through: json['through'] as String?,
    total: !json.containsKey('total')
        ? null
        : CommittedObligationListOutput._read_total(json['total']),
  );
}

Map<String, dynamic> _$CommittedObligationListOutputToJson(
  CommittedObligationListOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode':
        CommittedObligationListOutput._write_displayCurrencyCode($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.items case final $value?)
    'items': CommittedObligationListOutput._write_items($value),
  if (instance.missingRates case final $value?)
    'missingRates': CommittedObligationListOutput._write_missingRates($value),
  if (instance.periods case final $value?)
    'periods': CommittedObligationListOutput._write_periods($value),
  if (instance.rates case final $value?)
    'rates': CommittedObligationListOutput._write_rates($value),
  'through': ?instance.through,
  if (instance.total case final $value?)
    'total': CommittedObligationListOutput._write_total($value),
};

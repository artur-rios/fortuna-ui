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
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    items: (json['items'] as List<dynamic>?)
        ?.map(
          (e) => CommittedObligationOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    missingRates: (json['missingRates'] as List<dynamic>?)
        ?.map(
          (e) => MissingExchangeRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    periods: (json['periods'] as List<dynamic>?)
        ?.map(
          (e) => CommittedObligationPeriodOutput.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList(),
    rates: (json['rates'] as List<dynamic>?)
        ?.map(
          (e) =>
              CommittedObligationRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    through: json['through'] as String?,
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$CommittedObligationListOutputToJson(
  CommittedObligationListOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'isFullyConverted': ?instance.isFullyConverted,
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
  'missingRates': ?instance.missingRates?.map((e) => e.toJson()).toList(),
  'periods': ?instance.periods?.map((e) => e.toJson()).toList(),
  'rates': ?instance.rates?.map((e) => e.toJson()).toList(),
  'through': ?instance.through,
  'total': ?instance.total,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationListOutput _$CommittedObligationListOutputFromJson(
  Map<String, dynamic> json,
) => CommittedObligationListOutput(
  asOf: json['asOf'] == null ? null : DateTime.parse(json['asOf'] as String),
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  isFullyConverted: json['isFullyConverted'] as bool?,
  items: (json['items'] as List<dynamic>?)
      ?.map(
        (e) => CommittedObligationOutput.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  periods: (json['periods'] as List<dynamic>?)
      ?.map(
        (e) =>
            CommittedObligationPeriodOutput.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  rates: (json['rates'] as List<dynamic>?)
      ?.map(
        (e) =>
            CommittedObligationRateOutput.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  through: json['through'] == null
      ? null
      : DateTime.parse(json['through'] as String),
  total: (json['total'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CommittedObligationListOutputToJson(
  CommittedObligationListOutput instance,
) => <String, dynamic>{
  'asOf': instance.asOf?.toIso8601String(),
  'displayCurrencyCode': instance.displayCurrencyCode,
  'isFullyConverted': instance.isFullyConverted,
  'items': instance.items,
  'periods': instance.periods,
  'rates': instance.rates,
  'through': instance.through?.toIso8601String(),
  'total': instance.total,
};

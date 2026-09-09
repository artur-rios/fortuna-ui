// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_period_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationPeriodOutput _$CommittedObligationPeriodOutputFromJson(
  Map<String, dynamic> json,
) => CommittedObligationPeriodOutput(
  isFullyConverted: json['isFullyConverted'] as bool?,
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
  total: (json['total'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CommittedObligationPeriodOutputToJson(
  CommittedObligationPeriodOutput instance,
) => <String, dynamic>{
  'isFullyConverted': instance.isFullyConverted,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'total': instance.total,
};

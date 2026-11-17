// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_period_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationPeriodOutput _$CommittedObligationPeriodOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'isFullyConverted',
      'periodEnd',
      'periodStart',
      'total',
    ],
    disallowNullValues: const ['isFullyConverted', 'periodEnd', 'periodStart'],
  );
  return CommittedObligationPeriodOutput(
    isFullyConverted: json['isFullyConverted'] as bool?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$CommittedObligationPeriodOutputToJson(
  CommittedObligationPeriodOutput instance,
) => <String, dynamic>{
  'isFullyConverted': ?instance.isFullyConverted,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'total': ?instance.total,
};

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
    total: !json.containsKey('total')
        ? null
        : CommittedObligationPeriodOutput._read_total(json['total']),
  );
}

Map<String, dynamic> _$CommittedObligationPeriodOutputToJson(
  CommittedObligationPeriodOutput instance,
) => <String, dynamic>{
  'isFullyConverted': ?instance.isFullyConverted,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  if (instance.total case final $value?)
    'total': CommittedObligationPeriodOutput._write_total($value),
};

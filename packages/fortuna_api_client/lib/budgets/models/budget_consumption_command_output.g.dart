// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_consumption_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConsumptionCommandOutput _$BudgetConsumptionCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'isExceeded',
      'isFullyConverted',
      'overage',
      'periodEnd',
      'periodStart',
      'remaining',
      'spent',
    ],
    disallowNullValues: const ['isFullyConverted', 'periodEnd', 'periodStart'],
  );
  return BudgetConsumptionCommandOutput(
    isExceeded: !json.containsKey('isExceeded')
        ? null
        : BudgetConsumptionCommandOutput._read_isExceeded(json['isExceeded']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    overage: !json.containsKey('overage')
        ? null
        : BudgetConsumptionCommandOutput._read_overage(json['overage']),
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    remaining: !json.containsKey('remaining')
        ? null
        : BudgetConsumptionCommandOutput._read_remaining(json['remaining']),
    spent: !json.containsKey('spent')
        ? null
        : BudgetConsumptionCommandOutput._read_spent(json['spent']),
  );
}

Map<String, dynamic> _$BudgetConsumptionCommandOutputToJson(
  BudgetConsumptionCommandOutput instance,
) => <String, dynamic>{
  if (instance.isExceeded case final $value?)
    'isExceeded': BudgetConsumptionCommandOutput._write_isExceeded($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.overage case final $value?)
    'overage': BudgetConsumptionCommandOutput._write_overage($value),
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  if (instance.remaining case final $value?)
    'remaining': BudgetConsumptionCommandOutput._write_remaining($value),
  if (instance.spent case final $value?)
    'spent': BudgetConsumptionCommandOutput._write_spent($value),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_consumption_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConsumptionOutput _$BudgetConsumptionOutputFromJson(
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
  return BudgetConsumptionOutput(
    isExceeded: !json.containsKey('isExceeded')
        ? null
        : BudgetConsumptionOutput._read_isExceeded(json['isExceeded']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    overage: !json.containsKey('overage')
        ? null
        : BudgetConsumptionOutput._read_overage(json['overage']),
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    remaining: !json.containsKey('remaining')
        ? null
        : BudgetConsumptionOutput._read_remaining(json['remaining']),
    spent: !json.containsKey('spent')
        ? null
        : BudgetConsumptionOutput._read_spent(json['spent']),
  );
}

Map<String, dynamic> _$BudgetConsumptionOutputToJson(
  BudgetConsumptionOutput instance,
) => <String, dynamic>{
  if (instance.isExceeded case final $value?)
    'isExceeded': BudgetConsumptionOutput._write_isExceeded($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.overage case final $value?)
    'overage': BudgetConsumptionOutput._write_overage($value),
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  if (instance.remaining case final $value?)
    'remaining': BudgetConsumptionOutput._write_remaining($value),
  if (instance.spent case final $value?)
    'spent': BudgetConsumptionOutput._write_spent($value),
};

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
    isExceeded: json['isExceeded'] as bool?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    overage: json['overage'] as String?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    remaining: json['remaining'] as String?,
    spent: json['spent'] as String?,
  );
}

Map<String, dynamic> _$BudgetConsumptionOutputToJson(
  BudgetConsumptionOutput instance,
) => <String, dynamic>{
  'isExceeded': ?instance.isExceeded,
  'isFullyConverted': ?instance.isFullyConverted,
  'overage': ?instance.overage,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'remaining': ?instance.remaining,
  'spent': ?instance.spent,
};

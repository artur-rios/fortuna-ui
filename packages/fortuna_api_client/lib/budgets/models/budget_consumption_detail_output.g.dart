// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_consumption_detail_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConsumptionDetailOutput _$BudgetConsumptionDetailOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'budgetAmount',
      'budgetId',
      'conversions',
      'currencyCode',
      'isCovered',
      'isExceeded',
      'isFullyConverted',
      'overage',
      'periodEnd',
      'periodStart',
      'reason',
      'remaining',
      'requestedDate',
      'spent',
    ],
    disallowNullValues: const [
      'budgetAmount',
      'budgetId',
      'isCovered',
      'isFullyConverted',
      'requestedDate',
    ],
  );
  return BudgetConsumptionDetailOutput(
    budgetAmount: json['budgetAmount'] as String?,
    budgetId: json['budgetId'] as String?,
    conversions: !json.containsKey('conversions')
        ? null
        : BudgetConsumptionDetailOutput._read_conversions(json['conversions']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : BudgetConsumptionDetailOutput._read_currencyCode(
            json['currencyCode'],
          ),
    isCovered: json['isCovered'] as bool?,
    isExceeded: !json.containsKey('isExceeded')
        ? null
        : BudgetConsumptionDetailOutput._read_isExceeded(json['isExceeded']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    overage: !json.containsKey('overage')
        ? null
        : BudgetConsumptionDetailOutput._read_overage(json['overage']),
    periodEnd: !json.containsKey('periodEnd')
        ? null
        : BudgetConsumptionDetailOutput._read_periodEnd(json['periodEnd']),
    periodStart: !json.containsKey('periodStart')
        ? null
        : BudgetConsumptionDetailOutput._read_periodStart(json['periodStart']),
    reason: !json.containsKey('reason')
        ? null
        : BudgetConsumptionDetailOutput._read_reason(json['reason']),
    remaining: !json.containsKey('remaining')
        ? null
        : BudgetConsumptionDetailOutput._read_remaining(json['remaining']),
    requestedDate: json['requestedDate'] as String?,
    spent: !json.containsKey('spent')
        ? null
        : BudgetConsumptionDetailOutput._read_spent(json['spent']),
  );
}

Map<String, dynamic> _$BudgetConsumptionDetailOutputToJson(
  BudgetConsumptionDetailOutput instance,
) => <String, dynamic>{
  'budgetAmount': ?instance.budgetAmount,
  'budgetId': ?instance.budgetId,
  if (instance.conversions case final $value?)
    'conversions': BudgetConsumptionDetailOutput._write_conversions($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': BudgetConsumptionDetailOutput._write_currencyCode($value),
  'isCovered': ?instance.isCovered,
  if (instance.isExceeded case final $value?)
    'isExceeded': BudgetConsumptionDetailOutput._write_isExceeded($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.overage case final $value?)
    'overage': BudgetConsumptionDetailOutput._write_overage($value),
  if (instance.periodEnd case final $value?)
    'periodEnd': BudgetConsumptionDetailOutput._write_periodEnd($value),
  if (instance.periodStart case final $value?)
    'periodStart': BudgetConsumptionDetailOutput._write_periodStart($value),
  if (instance.reason case final $value?)
    'reason': BudgetConsumptionDetailOutput._write_reason($value),
  if (instance.remaining case final $value?)
    'remaining': BudgetConsumptionDetailOutput._write_remaining($value),
  'requestedDate': ?instance.requestedDate,
  if (instance.spent case final $value?)
    'spent': BudgetConsumptionDetailOutput._write_spent($value),
};

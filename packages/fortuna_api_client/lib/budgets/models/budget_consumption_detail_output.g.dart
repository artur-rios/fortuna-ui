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
    conversions: (json['conversions'] as List<dynamic>?)
        ?.map((e) => BudgetConversionOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    currencyCode: json['currencyCode'] as String?,
    isCovered: json['isCovered'] as bool?,
    isExceeded: json['isExceeded'] as bool?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    overage: json['overage'] as String?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    reason: json['reason'] as String?,
    remaining: json['remaining'] as String?,
    requestedDate: json['requestedDate'] as String?,
    spent: json['spent'] as String?,
  );
}

Map<String, dynamic> _$BudgetConsumptionDetailOutputToJson(
  BudgetConsumptionDetailOutput instance,
) => <String, dynamic>{
  'budgetAmount': ?instance.budgetAmount,
  'budgetId': ?instance.budgetId,
  'conversions': ?instance.conversions?.map((e) => e.toJson()).toList(),
  'currencyCode': ?instance.currencyCode,
  'isCovered': ?instance.isCovered,
  'isExceeded': ?instance.isExceeded,
  'isFullyConverted': ?instance.isFullyConverted,
  'overage': ?instance.overage,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'reason': ?instance.reason,
  'remaining': ?instance.remaining,
  'requestedDate': ?instance.requestedDate,
  'spent': ?instance.spent,
};

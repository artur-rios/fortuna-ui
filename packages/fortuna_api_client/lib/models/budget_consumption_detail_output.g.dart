// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_consumption_detail_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConsumptionDetailOutput _$BudgetConsumptionDetailOutputFromJson(
  Map<String, dynamic> json,
) => BudgetConsumptionDetailOutput(
  budgetAmount: (json['budgetAmount'] as num?)?.toDouble(),
  budgetId: json['budgetId'] as String?,
  conversions: (json['conversions'] as List<dynamic>?)
      ?.map((e) => BudgetConversionOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  currencyCode: json['currencyCode'] as String?,
  isCovered: json['isCovered'] as bool?,
  isExceeded: json['isExceeded'] as bool?,
  isFullyConverted: json['isFullyConverted'] as bool?,
  overage: (json['overage'] as num?)?.toDouble(),
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
  reason: json['reason'] as String?,
  remaining: (json['remaining'] as num?)?.toDouble(),
  requestedDate: json['requestedDate'] == null
      ? null
      : DateTime.parse(json['requestedDate'] as String),
  spent: (json['spent'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BudgetConsumptionDetailOutputToJson(
  BudgetConsumptionDetailOutput instance,
) => <String, dynamic>{
  'budgetAmount': instance.budgetAmount,
  'budgetId': instance.budgetId,
  'conversions': instance.conversions,
  'currencyCode': instance.currencyCode,
  'isCovered': instance.isCovered,
  'isExceeded': instance.isExceeded,
  'isFullyConverted': instance.isFullyConverted,
  'overage': instance.overage,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'reason': instance.reason,
  'remaining': instance.remaining,
  'requestedDate': instance.requestedDate?.toIso8601String(),
  'spent': instance.spent,
};

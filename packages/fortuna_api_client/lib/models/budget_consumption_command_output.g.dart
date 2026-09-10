// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_consumption_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConsumptionCommandOutput _$BudgetConsumptionCommandOutputFromJson(
  Map<String, dynamic> json,
) => BudgetConsumptionCommandOutput(
  isExceeded: json['isExceeded'] as bool?,
  isFullyConverted: json['isFullyConverted'] as bool?,
  overage: json['overage'] as String?,
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
  remaining: json['remaining'] as String?,
  spent: json['spent'] as String?,
);

Map<String, dynamic> _$BudgetConsumptionCommandOutputToJson(
  BudgetConsumptionCommandOutput instance,
) => <String, dynamic>{
  'isExceeded': instance.isExceeded,
  'isFullyConverted': instance.isFullyConverted,
  'overage': instance.overage,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'remaining': instance.remaining,
  'spent': instance.spent,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_budget_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBudgetCommand _$UpdateBudgetCommandFromJson(Map<String, dynamic> json) =>
    UpdateBudgetCommand(
      amount: (json['amount'] as num?)?.toDouble(),
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      currencyCode: json['currencyCode'] as String?,
      includeDescendants: json['includeDescendants'] as bool?,
      periodStart: json['periodStart'] == null
          ? null
          : DateTime.parse(json['periodStart'] as String),
      periodType: json['periodType'] == null
          ? null
          : BudgetPeriodType.fromJson((json['periodType'] as num).toInt()),
    );

Map<String, dynamic> _$UpdateBudgetCommandToJson(
  UpdateBudgetCommand instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'categoryIds': instance.categoryIds,
  'currencyCode': instance.currencyCode,
  'includeDescendants': instance.includeDescendants,
  'periodStart': instance.periodStart?.toIso8601String(),
  'periodType': _$BudgetPeriodTypeEnumMap[instance.periodType],
};

const _$BudgetPeriodTypeEnumMap = {
  BudgetPeriodType.value1: 1,
  BudgetPeriodType.value2: 2,
  BudgetPeriodType.value3: 3,
  BudgetPeriodType.$unknown: r'$unknown',
};

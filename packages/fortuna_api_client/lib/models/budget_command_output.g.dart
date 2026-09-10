// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetCommandOutput _$BudgetCommandOutputFromJson(Map<String, dynamic> json) =>
    BudgetCommandOutput(
      amount: json['amount'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map(
            (e) =>
                BudgetCategoryCommandOutput.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      currencyCode: json['currencyCode'] as String?,
      currentPeriod: json['currentPeriod'] == null
          ? null
          : BudgetConsumptionCommandOutput.fromJson(
              json['currentPeriod'] as Map<String, dynamic>,
            ),
      id: json['id'] as String?,
      includeDescendants: json['includeDescendants'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      periodStart: json['periodStart'] == null
          ? null
          : DateTime.parse(json['periodStart'] as String),
      periodType: json['periodType'] == null
          ? null
          : BudgetPeriodType.fromJson((json['periodType'] as num).toInt()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BudgetCommandOutputToJson(
  BudgetCommandOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'categories': instance.categories,
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'currentPeriod': instance.currentPeriod,
  'id': instance.id,
  'includeDescendants': instance.includeDescendants,
  'isDeleted': instance.isDeleted,
  'periodStart': instance.periodStart?.toIso8601String(),
  'periodType': _$BudgetPeriodTypeEnumMap[instance.periodType],
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$BudgetPeriodTypeEnumMap = {
  BudgetPeriodType.value1: 1,
  BudgetPeriodType.value2: 2,
  BudgetPeriodType.value3: 3,
  BudgetPeriodType.$unknown: r'$unknown',
};

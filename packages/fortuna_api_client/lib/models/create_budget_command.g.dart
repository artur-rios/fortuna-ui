// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_budget_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBudgetCommand _$CreateBudgetCommandFromJson(Map<String, dynamic> json) =>
    CreateBudgetCommand(
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

Map<String, dynamic> _$CreateBudgetCommandToJson(
  CreateBudgetCommand instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'categoryIds': instance.categoryIds,
  'currencyCode': instance.currencyCode,
  'includeDescendants': instance.includeDescendants,
  'periodStart': instance.periodStart?.toIso8601String(),
  'periodType': instance.periodType,
};

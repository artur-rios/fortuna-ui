// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_budget_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBudgetCommand _$CreateBudgetCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'categoryIds',
      'currencyCode',
      'includeDescendants',
      'periodStart',
      'periodType',
    ],
    disallowNullValues: const [
      'amount',
      'includeDescendants',
      'periodStart',
      'periodType',
    ],
  );
  return CreateBudgetCommand(
    amount: json['amount'] as String?,
    categoryIds: (json['categoryIds'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    currencyCode: json['currencyCode'] as String?,
    includeDescendants: json['includeDescendants'] as bool?,
    periodStart: json['periodStart'] as String?,
    periodType: CreateBudgetCommand._read_periodType(json['periodType']),
  );
}

Map<String, dynamic> _$CreateBudgetCommandToJson(
  CreateBudgetCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryIds': ?instance.categoryIds,
  'currencyCode': ?instance.currencyCode,
  'includeDescendants': ?instance.includeDescendants,
  'periodStart': ?instance.periodStart,
  'periodType': ?CreateBudgetCommand._write_periodType(instance.periodType),
};

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
    categoryIds: !json.containsKey('categoryIds')
        ? null
        : CreateBudgetCommand._read_categoryIds(json['categoryIds']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateBudgetCommand._read_currencyCode(json['currencyCode']),
    includeDescendants: json['includeDescendants'] as bool?,
    periodStart: json['periodStart'] as String?,
    periodType: CreateBudgetCommand._read_periodType(json['periodType']),
  );
}

Map<String, dynamic> _$CreateBudgetCommandToJson(
  CreateBudgetCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.categoryIds case final $value?)
    'categoryIds': CreateBudgetCommand._write_categoryIds($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': CreateBudgetCommand._write_currencyCode($value),
  'includeDescendants': ?instance.includeDescendants,
  'periodStart': ?instance.periodStart,
  'periodType': ?CreateBudgetCommand._write_periodType(instance.periodType),
};

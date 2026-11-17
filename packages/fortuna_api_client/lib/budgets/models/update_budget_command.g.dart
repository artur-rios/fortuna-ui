// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_budget_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBudgetCommand _$UpdateBudgetCommandFromJson(Map<String, dynamic> json) {
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
  return UpdateBudgetCommand(
    amount: json['amount'] as String?,
    categoryIds: !json.containsKey('categoryIds')
        ? null
        : UpdateBudgetCommand._read_categoryIds(json['categoryIds']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateBudgetCommand._read_currencyCode(json['currencyCode']),
    includeDescendants: json['includeDescendants'] as bool?,
    periodStart: json['periodStart'] as String?,
    periodType: UpdateBudgetCommand._read_periodType(json['periodType']),
  );
}

Map<String, dynamic> _$UpdateBudgetCommandToJson(
  UpdateBudgetCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.categoryIds case final $value?)
    'categoryIds': UpdateBudgetCommand._write_categoryIds($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateBudgetCommand._write_currencyCode($value),
  'includeDescendants': ?instance.includeDescendants,
  'periodStart': ?instance.periodStart,
  'periodType': ?UpdateBudgetCommand._write_periodType(instance.periodType),
};

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
    categoryIds: (json['categoryIds'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    currencyCode: json['currencyCode'] as String?,
    includeDescendants: json['includeDescendants'] as bool?,
    periodStart: json['periodStart'] as String?,
    periodType: UpdateBudgetCommand._read_periodType(json['periodType']),
  );
}

Map<String, dynamic> _$UpdateBudgetCommandToJson(
  UpdateBudgetCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryIds': ?instance.categoryIds,
  'currencyCode': ?instance.currencyCode,
  'includeDescendants': ?instance.includeDescendants,
  'periodStart': ?instance.periodStart,
  'periodType': ?UpdateBudgetCommand._write_periodType(instance.periodType),
};

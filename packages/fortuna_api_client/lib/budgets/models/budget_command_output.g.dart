// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetCommandOutput _$BudgetCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'categories',
      'createdAt',
      'currencyCode',
      'currentPeriod',
      'id',
      'includeDescendants',
      'isDeleted',
      'periodStart',
      'periodType',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amount',
      'createdAt',
      'currentPeriod',
      'id',
      'includeDescendants',
      'isDeleted',
      'periodStart',
      'periodType',
      'updatedAt',
    ],
  );
  return BudgetCommandOutput(
    amount: json['amount'] as String?,
    categories: !json.containsKey('categories')
        ? null
        : BudgetCommandOutput._read_categories(json['categories']),
    createdAt: BudgetCommandOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : BudgetCommandOutput._read_currencyCode(json['currencyCode']),
    currentPeriod: json['currentPeriod'] == null
        ? null
        : BudgetConsumptionCommandOutput.fromJson(
            json['currentPeriod'] as Map<String, dynamic>,
          ),
    id: json['id'] as String?,
    includeDescendants: json['includeDescendants'] as bool?,
    isDeleted: json['isDeleted'] as bool?,
    periodStart: json['periodStart'] as String?,
    periodType: BudgetCommandOutput._read_periodType(json['periodType']),
    updatedAt: BudgetCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$BudgetCommandOutputToJson(
  BudgetCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.categories case final $value?)
    'categories': BudgetCommandOutput._write_categories($value),
  'createdAt': ?BudgetCommandOutput._write_createdAt(instance.createdAt),
  if (instance.currencyCode case final $value?)
    'currencyCode': BudgetCommandOutput._write_currencyCode($value),
  'currentPeriod': ?instance.currentPeriod?.toJson(),
  'id': ?instance.id,
  'includeDescendants': ?instance.includeDescendants,
  'isDeleted': ?instance.isDeleted,
  'periodStart': ?instance.periodStart,
  'periodType': ?BudgetCommandOutput._write_periodType(instance.periodType),
  'updatedAt': ?BudgetCommandOutput._write_updatedAt(instance.updatedAt),
};

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
    categories: (json['categories'] as List<dynamic>?)
        ?.map(
          (e) =>
              BudgetCategoryCommandOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    createdAt: BudgetCommandOutput._read_createdAt(json['createdAt']),
    currencyCode: json['currencyCode'] as String?,
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
  'categories': ?instance.categories?.map((e) => e.toJson()).toList(),
  'createdAt': ?BudgetCommandOutput._write_createdAt(instance.createdAt),
  'currencyCode': ?instance.currencyCode,
  'currentPeriod': ?instance.currentPeriod?.toJson(),
  'id': ?instance.id,
  'includeDescendants': ?instance.includeDescendants,
  'isDeleted': ?instance.isDeleted,
  'periodStart': ?instance.periodStart,
  'periodType': ?BudgetCommandOutput._write_periodType(instance.periodType),
  'updatedAt': ?BudgetCommandOutput._write_updatedAt(instance.updatedAt),
};

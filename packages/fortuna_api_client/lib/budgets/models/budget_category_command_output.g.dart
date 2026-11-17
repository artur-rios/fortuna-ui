// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_category_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetCategoryCommandOutput _$BudgetCategoryCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'name'],
    disallowNullValues: const ['id'],
  );
  return BudgetCategoryCommandOutput(
    id: json['id'] as String?,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$BudgetCategoryCommandOutputToJson(
  BudgetCategoryCommandOutput instance,
) => <String, dynamic>{'id': ?instance.id, 'name': ?instance.name};

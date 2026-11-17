// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_category_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetCategoryOutput _$BudgetCategoryOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'name'],
    disallowNullValues: const ['id'],
  );
  return BudgetCategoryOutput(
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : BudgetCategoryOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$BudgetCategoryOutputToJson(
  BudgetCategoryOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': BudgetCategoryOutput._write_name($value),
};

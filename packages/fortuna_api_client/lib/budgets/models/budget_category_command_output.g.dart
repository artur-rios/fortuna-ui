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
    name: !json.containsKey('name')
        ? null
        : BudgetCategoryCommandOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$BudgetCategoryCommandOutputToJson(
  BudgetCategoryCommandOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': BudgetCategoryCommandOutput._write_name($value),
};

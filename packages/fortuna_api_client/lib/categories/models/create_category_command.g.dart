// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryCommand _$CreateCategoryCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['name', 'parentId']);
  return CreateCategoryCommand(
    name: !json.containsKey('name')
        ? null
        : CreateCategoryCommand._read_name(json['name']),
    parentId: !json.containsKey('parentId')
        ? null
        : CreateCategoryCommand._read_parentId(json['parentId']),
  );
}

Map<String, dynamic> _$CreateCategoryCommandToJson(
  CreateCategoryCommand instance,
) => <String, dynamic>{
  if (instance.name case final $value?)
    'name': CreateCategoryCommand._write_name($value),
  if (instance.parentId case final $value?)
    'parentId': CreateCategoryCommand._write_parentId($value),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryCommand _$UpdateCategoryCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['name', 'parentId']);
  return UpdateCategoryCommand(
    name: !json.containsKey('name')
        ? null
        : UpdateCategoryCommand._read_name(json['name']),
    parentId: !json.containsKey('parentId')
        ? null
        : UpdateCategoryCommand._read_parentId(json['parentId']),
  );
}

Map<String, dynamic> _$UpdateCategoryCommandToJson(
  UpdateCategoryCommand instance,
) => <String, dynamic>{
  if (instance.name case final $value?)
    'name': UpdateCategoryCommand._write_name($value),
  if (instance.parentId case final $value?)
    'parentId': UpdateCategoryCommand._write_parentId($value),
};

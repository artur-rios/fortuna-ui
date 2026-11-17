// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryCommandOutput _$UpdateCategoryCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['createdAt', 'id', 'name', 'parentId', 'updatedAt'],
    disallowNullValues: const ['createdAt', 'id', 'updatedAt'],
  );
  return UpdateCategoryCommandOutput(
    createdAt: UpdateCategoryCommandOutput._read_createdAt(json['createdAt']),
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : UpdateCategoryCommandOutput._read_name(json['name']),
    parentId: !json.containsKey('parentId')
        ? null
        : UpdateCategoryCommandOutput._read_parentId(json['parentId']),
    updatedAt: UpdateCategoryCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$UpdateCategoryCommandOutputToJson(
  UpdateCategoryCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?UpdateCategoryCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': UpdateCategoryCommandOutput._write_name($value),
  if (instance.parentId case final $value?)
    'parentId': UpdateCategoryCommandOutput._write_parentId($value),
  'updatedAt': ?UpdateCategoryCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

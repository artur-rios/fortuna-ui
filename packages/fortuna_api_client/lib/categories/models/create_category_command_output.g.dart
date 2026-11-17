// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryCommandOutput _$CreateCategoryCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['createdAt', 'id', 'name', 'parentId', 'updatedAt'],
    disallowNullValues: const ['createdAt', 'id', 'updatedAt'],
  );
  return CreateCategoryCommandOutput(
    createdAt: CreateCategoryCommandOutput._read_createdAt(json['createdAt']),
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : CreateCategoryCommandOutput._read_name(json['name']),
    parentId: !json.containsKey('parentId')
        ? null
        : CreateCategoryCommandOutput._read_parentId(json['parentId']),
    updatedAt: CreateCategoryCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$CreateCategoryCommandOutputToJson(
  CreateCategoryCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?CreateCategoryCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': CreateCategoryCommandOutput._write_name($value),
  if (instance.parentId case final $value?)
    'parentId': CreateCategoryCommandOutput._write_parentId($value),
  'updatedAt': ?CreateCategoryCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

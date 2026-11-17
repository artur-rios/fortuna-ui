// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryOutput _$CategoryOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'children',
      'createdAt',
      'id',
      'isDeleted',
      'name',
      'parentId',
      'updatedAt',
      'usageCount',
    ],
    disallowNullValues: const ['createdAt', 'id', 'isDeleted', 'updatedAt'],
  );
  return CategoryOutput(
    children: !json.containsKey('children')
        ? null
        : CategoryOutput._read_children(json['children']),
    createdAt: CategoryOutput._read_createdAt(json['createdAt']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    name: !json.containsKey('name')
        ? null
        : CategoryOutput._read_name(json['name']),
    parentId: !json.containsKey('parentId')
        ? null
        : CategoryOutput._read_parentId(json['parentId']),
    updatedAt: CategoryOutput._read_updatedAt(json['updatedAt']),
    usageCount: !json.containsKey('usageCount')
        ? null
        : CategoryOutput._read_usageCount(json['usageCount']),
  );
}

Map<String, dynamic> _$CategoryOutputToJson(CategoryOutput instance) =>
    <String, dynamic>{
      if (instance.children case final $value?)
        'children': CategoryOutput._write_children($value),
      'createdAt': ?CategoryOutput._write_createdAt(instance.createdAt),
      'id': ?instance.id,
      'isDeleted': ?instance.isDeleted,
      if (instance.name case final $value?)
        'name': CategoryOutput._write_name($value),
      if (instance.parentId case final $value?)
        'parentId': CategoryOutput._write_parentId($value),
      'updatedAt': ?CategoryOutput._write_updatedAt(instance.updatedAt),
      if (instance.usageCount case final $value?)
        'usageCount': CategoryOutput._write_usageCount($value),
    };

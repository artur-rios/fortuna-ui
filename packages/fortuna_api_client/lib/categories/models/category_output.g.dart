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
    children: (json['children'] as List<dynamic>?)
        ?.map((e) => CategoryOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: CategoryOutput._read_createdAt(json['createdAt']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    name: json['name'] as String?,
    parentId: json['parentId'] as String?,
    updatedAt: CategoryOutput._read_updatedAt(json['updatedAt']),
    usageCount: CategoryOutput._read_usageCount(json['usageCount']),
  );
}

Map<String, dynamic> _$CategoryOutputToJson(CategoryOutput instance) =>
    <String, dynamic>{
      'children': ?instance.children?.map((e) => e.toJson()).toList(),
      'createdAt': ?CategoryOutput._write_createdAt(instance.createdAt),
      'id': ?instance.id,
      'isDeleted': ?instance.isDeleted,
      'name': ?instance.name,
      'parentId': ?instance.parentId,
      'updatedAt': ?CategoryOutput._write_updatedAt(instance.updatedAt),
      'usageCount': ?CategoryOutput._write_usageCount(instance.usageCount),
    };

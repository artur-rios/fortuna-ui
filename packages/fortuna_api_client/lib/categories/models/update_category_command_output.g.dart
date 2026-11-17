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
    name: json['name'] as String?,
    parentId: json['parentId'] as String?,
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
  'name': ?instance.name,
  'parentId': ?instance.parentId,
  'updatedAt': ?UpdateCategoryCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

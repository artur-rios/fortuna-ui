// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryCommandOutput _$UpdateCategoryCommandOutputFromJson(
  Map<String, dynamic> json,
) => UpdateCategoryCommandOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  id: json['id'] as String?,
  name: json['name'] as String?,
  parentId: json['parentId'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UpdateCategoryCommandOutputToJson(
  UpdateCategoryCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'id': instance.id,
  'name': instance.name,
  'parentId': instance.parentId,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

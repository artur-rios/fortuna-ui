// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryCommandOutput _$CreateCategoryCommandOutputFromJson(
  Map<String, dynamic> json,
) => CreateCategoryCommandOutput(
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

Map<String, dynamic> _$CreateCategoryCommandOutputToJson(
  CreateCategoryCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'id': instance.id,
  'name': instance.name,
  'parentId': instance.parentId,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

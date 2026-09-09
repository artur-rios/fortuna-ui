// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryOutput _$CategoryOutputFromJson(Map<String, dynamic> json) =>
    CategoryOutput(
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => CategoryOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      id: json['id'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      name: json['name'] as String?,
      parentId: json['parentId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      usageCount: (json['usageCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CategoryOutputToJson(CategoryOutput instance) =>
    <String, dynamic>{
      'children': instance.children,
      'createdAt': instance.createdAt?.toIso8601String(),
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'name': instance.name,
      'parentId': instance.parentId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'usageCount': instance.usageCount,
    };

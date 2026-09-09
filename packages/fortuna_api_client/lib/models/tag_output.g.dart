// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagOutput _$TagOutputFromJson(Map<String, dynamic> json) => TagOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  id: json['id'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  name: json['name'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TagOutputToJson(TagOutput instance) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'name': instance.name,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

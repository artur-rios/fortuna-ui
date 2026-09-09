// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagCommandOutput _$TagCommandOutputFromJson(Map<String, dynamic> json) =>
    TagCommandOutput(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      detachedTransactionCount: (json['detachedTransactionCount'] as num?)
          ?.toInt(),
      id: json['id'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      name: json['name'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TagCommandOutputToJson(TagCommandOutput instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'detachedTransactionCount': instance.detachedTransactionCount,
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'name': instance.name,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

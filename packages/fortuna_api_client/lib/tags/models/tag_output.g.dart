// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagOutput _$TagOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['createdAt', 'id', 'isDeleted', 'name', 'updatedAt'],
    disallowNullValues: const ['createdAt', 'id', 'isDeleted', 'updatedAt'],
  );
  return TagOutput(
    createdAt: TagOutput._read_createdAt(json['createdAt']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    name: json['name'] as String?,
    updatedAt: TagOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$TagOutputToJson(TagOutput instance) => <String, dynamic>{
  'createdAt': ?TagOutput._write_createdAt(instance.createdAt),
  'id': ?instance.id,
  'isDeleted': ?instance.isDeleted,
  'name': ?instance.name,
  'updatedAt': ?TagOutput._write_updatedAt(instance.updatedAt),
};

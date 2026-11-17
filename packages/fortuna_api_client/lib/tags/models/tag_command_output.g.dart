// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagCommandOutput _$TagCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'detachedTransactionCount',
      'id',
      'isDeleted',
      'name',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'detachedTransactionCount',
      'id',
      'isDeleted',
      'updatedAt',
    ],
  );
  return TagCommandOutput(
    createdAt: TagCommandOutput._read_createdAt(json['createdAt']),
    detachedTransactionCount: TagCommandOutput._read_detachedTransactionCount(
      json['detachedTransactionCount'],
    ),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    name: json['name'] as String?,
    updatedAt: TagCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$TagCommandOutputToJson(
  TagCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?TagCommandOutput._write_createdAt(instance.createdAt),
  'detachedTransactionCount': ?TagCommandOutput._write_detachedTransactionCount(
    instance.detachedTransactionCount,
  ),
  'id': ?instance.id,
  'isDeleted': ?instance.isDeleted,
  'name': ?instance.name,
  'updatedAt': ?TagCommandOutput._write_updatedAt(instance.updatedAt),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentOutput _$AttachmentOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'contentType',
      'createdAt',
      'fileName',
      'id',
      'isDeleted',
      'sizeInBytes',
      'transactionId',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'isDeleted',
      'sizeInBytes',
      'transactionId',
      'updatedAt',
    ],
  );
  return AttachmentOutput(
    contentType: !json.containsKey('contentType')
        ? null
        : AttachmentOutput._read_contentType(json['contentType']),
    createdAt: AttachmentOutput._read_createdAt(json['createdAt']),
    fileName: !json.containsKey('fileName')
        ? null
        : AttachmentOutput._read_fileName(json['fileName']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    sizeInBytes: AttachmentOutput._read_sizeInBytes(json['sizeInBytes']),
    transactionId: json['transactionId'] as String?,
    updatedAt: AttachmentOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$AttachmentOutputToJson(AttachmentOutput instance) =>
    <String, dynamic>{
      if (instance.contentType case final $value?)
        'contentType': AttachmentOutput._write_contentType($value),
      'createdAt': ?AttachmentOutput._write_createdAt(instance.createdAt),
      if (instance.fileName case final $value?)
        'fileName': AttachmentOutput._write_fileName($value),
      'id': ?instance.id,
      'isDeleted': ?instance.isDeleted,
      'sizeInBytes': ?AttachmentOutput._write_sizeInBytes(instance.sizeInBytes),
      'transactionId': ?instance.transactionId,
      'updatedAt': ?AttachmentOutput._write_updatedAt(instance.updatedAt),
    };

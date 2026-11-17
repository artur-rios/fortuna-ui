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
    contentType: json['contentType'] as String?,
    createdAt: AttachmentOutput._read_createdAt(json['createdAt']),
    fileName: json['fileName'] as String?,
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    sizeInBytes: AttachmentOutput._read_sizeInBytes(json['sizeInBytes']),
    transactionId: json['transactionId'] as String?,
    updatedAt: AttachmentOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$AttachmentOutputToJson(AttachmentOutput instance) =>
    <String, dynamic>{
      'contentType': ?instance.contentType,
      'createdAt': ?AttachmentOutput._write_createdAt(instance.createdAt),
      'fileName': ?instance.fileName,
      'id': ?instance.id,
      'isDeleted': ?instance.isDeleted,
      'sizeInBytes': ?AttachmentOutput._write_sizeInBytes(instance.sizeInBytes),
      'transactionId': ?instance.transactionId,
      'updatedAt': ?AttachmentOutput._write_updatedAt(instance.updatedAt),
    };

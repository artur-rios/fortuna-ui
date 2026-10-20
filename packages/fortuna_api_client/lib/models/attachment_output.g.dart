// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentOutput _$AttachmentOutputFromJson(Map<String, dynamic> json) =>
    AttachmentOutput(
      contentType: json['contentType'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      fileName: json['fileName'] as String?,
      id: json['id'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      sizeInBytes: (json['sizeInBytes'] as num?)?.toInt(),
      transactionId: json['transactionId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AttachmentOutputToJson(AttachmentOutput instance) =>
    <String, dynamic>{
      'contentType': instance.contentType,
      'createdAt': instance.createdAt?.toIso8601String(),
      'fileName': instance.fileName,
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'sizeInBytes': instance.sizeInBytes,
      'transactionId': instance.transactionId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

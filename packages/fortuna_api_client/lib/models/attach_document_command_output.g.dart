// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_document_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachDocumentCommandOutput _$AttachDocumentCommandOutputFromJson(
  Map<String, dynamic> json,
) => AttachDocumentCommandOutput(
  contentType: json['contentType'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  fileName: json['fileName'] as String?,
  id: json['id'] as String?,
  sizeInBytes: (json['sizeInBytes'] as num?)?.toInt(),
  transactionId: json['transactionId'] as String?,
);

Map<String, dynamic> _$AttachDocumentCommandOutputToJson(
  AttachDocumentCommandOutput instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'createdAt': instance.createdAt?.toIso8601String(),
  'fileName': instance.fileName,
  'id': instance.id,
  'sizeInBytes': instance.sizeInBytes,
  'transactionId': instance.transactionId,
};

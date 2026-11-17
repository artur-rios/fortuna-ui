// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_document_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachDocumentCommandOutput _$AttachDocumentCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'contentType',
      'createdAt',
      'fileName',
      'id',
      'sizeInBytes',
      'transactionId',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'sizeInBytes',
      'transactionId',
    ],
  );
  return AttachDocumentCommandOutput(
    contentType: json['contentType'] as String?,
    createdAt: AttachDocumentCommandOutput._read_createdAt(json['createdAt']),
    fileName: json['fileName'] as String?,
    id: json['id'] as String?,
    sizeInBytes: AttachDocumentCommandOutput._read_sizeInBytes(
      json['sizeInBytes'],
    ),
    transactionId: json['transactionId'] as String?,
  );
}

Map<String, dynamic> _$AttachDocumentCommandOutputToJson(
  AttachDocumentCommandOutput instance,
) => <String, dynamic>{
  'contentType': ?instance.contentType,
  'createdAt': ?AttachDocumentCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'fileName': ?instance.fileName,
  'id': ?instance.id,
  'sizeInBytes': ?AttachDocumentCommandOutput._write_sizeInBytes(
    instance.sizeInBytes,
  ),
  'transactionId': ?instance.transactionId,
};

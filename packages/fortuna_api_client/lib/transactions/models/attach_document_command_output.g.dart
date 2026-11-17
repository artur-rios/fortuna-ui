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
    contentType: !json.containsKey('contentType')
        ? null
        : AttachDocumentCommandOutput._read_contentType(json['contentType']),
    createdAt: AttachDocumentCommandOutput._read_createdAt(json['createdAt']),
    fileName: !json.containsKey('fileName')
        ? null
        : AttachDocumentCommandOutput._read_fileName(json['fileName']),
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
  if (instance.contentType case final $value?)
    'contentType': AttachDocumentCommandOutput._write_contentType($value),
  'createdAt': ?AttachDocumentCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.fileName case final $value?)
    'fileName': AttachDocumentCommandOutput._write_fileName($value),
  'id': ?instance.id,
  'sizeInBytes': ?AttachDocumentCommandOutput._write_sizeInBytes(
    instance.sizeInBytes,
  ),
  'transactionId': ?instance.transactionId,
};

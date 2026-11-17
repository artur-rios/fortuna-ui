// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_document_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachDocumentCommandOutputDataOutput$Request
_$AttachDocumentCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return AttachDocumentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : AttachDocumentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: AttachDocumentCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$AttachDocumentCommandOutputDataOutput$RequestToJson(
  AttachDocumentCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?AttachDocumentCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

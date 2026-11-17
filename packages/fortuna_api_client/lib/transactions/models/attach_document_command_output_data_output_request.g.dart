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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return AttachDocumentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : AttachDocumentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : AttachDocumentCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : AttachDocumentCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: AttachDocumentCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$AttachDocumentCommandOutputDataOutput$RequestToJson(
  AttachDocumentCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': AttachDocumentCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': AttachDocumentCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?AttachDocumentCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

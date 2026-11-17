// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentLifecycleCommandOutputDataOutput$Request
_$AttachmentLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return AttachmentLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : AttachmentLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : AttachmentLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : AttachmentLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        AttachmentLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$AttachmentLifecycleCommandOutputDataOutput$RequestToJson(
  AttachmentLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': AttachmentLifecycleCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        AttachmentLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?AttachmentLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagCommandOutputDataOutput$Response
_$TagCommandOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return TagCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TagCommandOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TagCommandOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TagCommandOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: TagCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TagCommandOutputDataOutput$ResponseToJson(
  TagCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TagCommandOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TagCommandOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?TagCommandOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutputDataOutput$Response _$TagListOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return TagListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TagListOutput$Response.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TagListOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TagListOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: TagListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TagListOutputDataOutput$ResponseToJson(
  TagListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TagListOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TagListOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?TagListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

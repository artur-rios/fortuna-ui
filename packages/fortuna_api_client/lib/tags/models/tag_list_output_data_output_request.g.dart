// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutputDataOutput$Request _$TagListOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TagListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TagListOutput$Request.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TagListOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TagListOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: TagListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TagListOutputDataOutput$RequestToJson(
  TagListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TagListOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TagListOutputDataOutput$Request._write_messages($value),
  'timestamp': ?TagListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagCommandOutputDataOutput$Request _$TagCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TagCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TagCommandOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TagCommandOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TagCommandOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: TagCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TagCommandOutputDataOutput$RequestToJson(
  TagCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TagCommandOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TagCommandOutputDataOutput$Request._write_messages($value),
  'timestamp': ?TagCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectDataOutput$Request _$ObjectDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ObjectDataOutput$Request(
    data: !json.containsKey('data')
        ? null
        : ObjectDataOutput$Request._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : ObjectDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : ObjectDataOutput$Request._read_messages(json['messages']),
    timestamp: ObjectDataOutput$Request._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$ObjectDataOutput$RequestToJson(
  ObjectDataOutput$Request instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': ObjectDataOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': ObjectDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ObjectDataOutput$Request._write_messages($value),
  'timestamp': ?ObjectDataOutput$Request._write_timestamp(instance.timestamp),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectDataOutput$Response _$ObjectDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ObjectDataOutput$Response(
    data: !json.containsKey('data')
        ? null
        : ObjectDataOutput$Response._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : ObjectDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : ObjectDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: ObjectDataOutput$Response._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$ObjectDataOutput$ResponseToJson(
  ObjectDataOutput$Response instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': ObjectDataOutput$Response._write_data($value),
  if (instance.errors case final $value?)
    'errors': ObjectDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ObjectDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?ObjectDataOutput$Response._write_timestamp(instance.timestamp),
};

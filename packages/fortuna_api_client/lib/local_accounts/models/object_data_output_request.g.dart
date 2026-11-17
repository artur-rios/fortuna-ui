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
    data: json['data'],
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: ObjectDataOutput$Request._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$ObjectDataOutput$RequestToJson(
  ObjectDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data,
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?ObjectDataOutput$Request._write_timestamp(instance.timestamp),
};

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
    data: json['data'],
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: ObjectDataOutput$Response._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$ObjectDataOutput$ResponseToJson(
  ObjectDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data,
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?ObjectDataOutput$Response._write_timestamp(instance.timestamp),
};

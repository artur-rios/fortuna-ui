// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessOutput$Response _$ProcessOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ProcessOutput$Response(
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: ProcessOutput$Response._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$ProcessOutput$ResponseToJson(
  ProcessOutput$Response instance,
) => <String, dynamic>{
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?ProcessOutput$Response._write_timestamp(instance.timestamp),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionOutputDataOutput$Response
_$ConnectionOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ConnectionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ConnectionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: ConnectionOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ConnectionOutputDataOutput$ResponseToJson(
  ConnectionOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?ConnectionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

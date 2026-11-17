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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ConnectionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ConnectionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : ConnectionOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : ConnectionOutputDataOutput$Response._read_messages(json['messages']),
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
  if (instance.errors case final $value?)
    'errors': ConnectionOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ConnectionOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?ConnectionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_position_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetPositionOutputDataOutput$Response
_$NetPositionOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return NetPositionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : NetPositionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : NetPositionOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : NetPositionOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: NetPositionOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$NetPositionOutputDataOutput$ResponseToJson(
  NetPositionOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': NetPositionOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': NetPositionOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?NetPositionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

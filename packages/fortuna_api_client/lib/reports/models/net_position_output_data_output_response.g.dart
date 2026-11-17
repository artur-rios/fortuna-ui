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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return NetPositionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : NetPositionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?NetPositionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

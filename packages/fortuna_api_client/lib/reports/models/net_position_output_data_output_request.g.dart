// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_position_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetPositionOutputDataOutput$Request
_$NetPositionOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return NetPositionOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : NetPositionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: NetPositionOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$NetPositionOutputDataOutput$RequestToJson(
  NetPositionOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?NetPositionOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

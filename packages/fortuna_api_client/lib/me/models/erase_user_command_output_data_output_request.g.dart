// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'erase_user_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EraseUserCommandOutputDataOutput$Request
_$EraseUserCommandOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return EraseUserCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : EraseUserCommandOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: EraseUserCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$EraseUserCommandOutputDataOutput$RequestToJson(
  EraseUserCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?EraseUserCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

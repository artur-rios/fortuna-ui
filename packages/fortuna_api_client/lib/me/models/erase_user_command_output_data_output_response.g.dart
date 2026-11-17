// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'erase_user_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EraseUserCommandOutputDataOutput$Response
_$EraseUserCommandOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return EraseUserCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : EraseUserCommandOutput$Response.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : EraseUserCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : EraseUserCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: EraseUserCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$EraseUserCommandOutputDataOutput$ResponseToJson(
  EraseUserCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': EraseUserCommandOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': EraseUserCommandOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?EraseUserCommandOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileOutputDataOutput$Response
_$UserProfileOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return UserProfileOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : UserProfileOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : UserProfileOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : UserProfileOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: UserProfileOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UserProfileOutputDataOutput$ResponseToJson(
  UserProfileOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UserProfileOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': UserProfileOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?UserProfileOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

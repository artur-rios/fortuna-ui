// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileOutputDataOutput$Request
_$UserProfileOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return UserProfileOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UserProfileOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : UserProfileOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : UserProfileOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: UserProfileOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UserProfileOutputDataOutput$RequestToJson(
  UserProfileOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UserProfileOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': UserProfileOutputDataOutput$Request._write_messages($value),
  'timestamp': ?UserProfileOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

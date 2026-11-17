// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordThroughApiCommandOutputDataOutput$Request
_$ResetPasswordThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ResetPasswordThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ResetPasswordThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        ResetPasswordThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ResetPasswordThroughApiCommandOutputDataOutput$RequestToJson(
  ResetPasswordThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ResetPasswordThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

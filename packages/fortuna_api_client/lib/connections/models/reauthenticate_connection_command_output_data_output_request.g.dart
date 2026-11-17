// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauthenticate_connection_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReauthenticateConnectionCommandOutputDataOutput$Request
_$ReauthenticateConnectionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ReauthenticateConnectionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ReauthenticateConnectionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        ReauthenticateConnectionCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ReauthenticateConnectionCommandOutputDataOutput$RequestToJson(
  ReauthenticateConnectionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ReauthenticateConnectionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauthenticate_connection_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReauthenticateConnectionCommandOutputDataOutput$Response
_$ReauthenticateConnectionCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ReauthenticateConnectionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ReauthenticateConnectionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ReauthenticateConnectionCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ReauthenticateConnectionCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        ReauthenticateConnectionCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ReauthenticateConnectionCommandOutputDataOutput$ResponseToJson(
  ReauthenticateConnectionCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        ReauthenticateConnectionCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ReauthenticateConnectionCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?ReauthenticateConnectionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

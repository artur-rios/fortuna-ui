// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordThroughApiCommandOutputDataOutput$Response
_$ResetPasswordThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ResetPasswordThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ResetPasswordThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ResetPasswordThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ResetPasswordThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        ResetPasswordThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ResetPasswordThroughApiCommandOutputDataOutput$ResponseToJson(
  ResetPasswordThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        ResetPasswordThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ResetPasswordThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?ResetPasswordThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

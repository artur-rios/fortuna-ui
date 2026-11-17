// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_password_recovery_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response
_$RequestPasswordRecoveryThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RequestPasswordRecoveryThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RequestPasswordRecoveryThroughApiCommandOutputDataOutput$ResponseToJson(
  RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

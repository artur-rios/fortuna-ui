// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_password_recovery_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request
_$RequestPasswordRecoveryThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RequestPasswordRecoveryThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RequestPasswordRecoveryThroughApiCommandOutputDataOutput$RequestToJson(
  RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

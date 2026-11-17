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
    disallowNullValues: const ['timestamp'],
  );
  return RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RequestPasswordRecoveryThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RequestPasswordRecoveryThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

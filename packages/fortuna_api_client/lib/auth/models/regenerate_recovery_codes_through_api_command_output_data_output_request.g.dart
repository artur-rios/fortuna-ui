// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_recovery_codes_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request
_$RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$RequestToJson(
  RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

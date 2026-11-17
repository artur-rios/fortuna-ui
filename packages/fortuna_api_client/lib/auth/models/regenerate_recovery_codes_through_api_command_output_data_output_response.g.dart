// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_recovery_codes_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response
_$RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$ResponseToJson(
  RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

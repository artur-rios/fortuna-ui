// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grant_processing_consent_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrantProcessingConsentCommandOutputDataOutput$Response
_$GrantProcessingConsentCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return GrantProcessingConsentCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GrantProcessingConsentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GrantProcessingConsentCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : GrantProcessingConsentCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        GrantProcessingConsentCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GrantProcessingConsentCommandOutputDataOutput$ResponseToJson(
  GrantProcessingConsentCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        GrantProcessingConsentCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        GrantProcessingConsentCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?GrantProcessingConsentCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

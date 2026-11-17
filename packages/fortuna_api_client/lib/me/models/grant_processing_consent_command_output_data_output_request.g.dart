// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grant_processing_consent_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrantProcessingConsentCommandOutputDataOutput$Request
_$GrantProcessingConsentCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return GrantProcessingConsentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GrantProcessingConsentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GrantProcessingConsentCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : GrantProcessingConsentCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        GrantProcessingConsentCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GrantProcessingConsentCommandOutputDataOutput$RequestToJson(
  GrantProcessingConsentCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        GrantProcessingConsentCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        GrantProcessingConsentCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?GrantProcessingConsentCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

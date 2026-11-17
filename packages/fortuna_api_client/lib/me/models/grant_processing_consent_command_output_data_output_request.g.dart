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
    disallowNullValues: const ['timestamp'],
  );
  return GrantProcessingConsentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GrantProcessingConsentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?GrantProcessingConsentCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

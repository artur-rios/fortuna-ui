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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return GrantProcessingConsentCommandOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?GrantProcessingConsentCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

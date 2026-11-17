// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_consent_query_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessingConsentQueryOutputDataOutput$Response
_$ProcessingConsentQueryOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ProcessingConsentQueryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ProcessingConsentQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ProcessingConsentQueryOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ProcessingConsentQueryOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: ProcessingConsentQueryOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ProcessingConsentQueryOutputDataOutput$ResponseToJson(
  ProcessingConsentQueryOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ProcessingConsentQueryOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': ProcessingConsentQueryOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp':
      ?ProcessingConsentQueryOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

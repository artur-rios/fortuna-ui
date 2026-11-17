// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_consent_query_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessingConsentQueryOutputDataOutput$Request
_$ProcessingConsentQueryOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ProcessingConsentQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ProcessingConsentQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ProcessingConsentQueryOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ProcessingConsentQueryOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: ProcessingConsentQueryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ProcessingConsentQueryOutputDataOutput$RequestToJson(
  ProcessingConsentQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ProcessingConsentQueryOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': ProcessingConsentQueryOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?ProcessingConsentQueryOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

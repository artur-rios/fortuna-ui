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
    disallowNullValues: const ['timestamp'],
  );
  return ProcessingConsentQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ProcessingConsentQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: ProcessingConsentQueryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ProcessingConsentQueryOutputDataOutput$RequestToJson(
  ProcessingConsentQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?ProcessingConsentQueryOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

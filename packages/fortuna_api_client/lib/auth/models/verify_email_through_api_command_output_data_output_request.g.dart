// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailThroughApiCommandOutputDataOutput$Request
_$VerifyEmailThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return VerifyEmailThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : VerifyEmailThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        VerifyEmailThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$VerifyEmailThroughApiCommandOutputDataOutput$RequestToJson(
  VerifyEmailThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?VerifyEmailThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

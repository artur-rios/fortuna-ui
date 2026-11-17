// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_verification_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResendVerificationThroughApiCommandOutputDataOutput$Request
_$ResendVerificationThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ResendVerificationThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ResendVerificationThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        ResendVerificationThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ResendVerificationThroughApiCommandOutputDataOutput$RequestToJson(
  ResendVerificationThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ResendVerificationThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

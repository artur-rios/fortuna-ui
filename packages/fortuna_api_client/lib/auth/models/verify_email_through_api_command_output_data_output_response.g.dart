// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailThroughApiCommandOutputDataOutput$Response
_$VerifyEmailThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return VerifyEmailThroughApiCommandOutputDataOutput$Response(
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
    success: json['success'] as bool?,
    timestamp:
        VerifyEmailThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$VerifyEmailThroughApiCommandOutputDataOutput$ResponseToJson(
  VerifyEmailThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?VerifyEmailThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

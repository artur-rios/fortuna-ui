// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordThroughApiCommandOutputDataOutput$Response
_$ResetPasswordThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ResetPasswordThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ResetPasswordThroughApiCommandOutput.fromJson(
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
        ResetPasswordThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ResetPasswordThroughApiCommandOutputDataOutput$ResponseToJson(
  ResetPasswordThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?ResetPasswordThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

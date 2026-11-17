// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disable_two_factor_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisableTwoFactorThroughApiCommandOutputDataOutput$Response
_$DisableTwoFactorThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return DisableTwoFactorThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : DisableTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : DisableTwoFactorThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : DisableTwoFactorThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        DisableTwoFactorThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$DisableTwoFactorThroughApiCommandOutputDataOutput$ResponseToJson(
  DisableTwoFactorThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        DisableTwoFactorThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        DisableTwoFactorThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?DisableTwoFactorThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

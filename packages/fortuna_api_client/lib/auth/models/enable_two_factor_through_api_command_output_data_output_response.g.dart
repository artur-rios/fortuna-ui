// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_two_factor_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableTwoFactorThroughApiCommandOutputDataOutput$Response
_$EnableTwoFactorThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return EnableTwoFactorThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : EnableTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : EnableTwoFactorThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : EnableTwoFactorThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        EnableTwoFactorThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$EnableTwoFactorThroughApiCommandOutputDataOutput$ResponseToJson(
  EnableTwoFactorThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        EnableTwoFactorThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        EnableTwoFactorThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?EnableTwoFactorThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_two_factor_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTwoFactorThroughApiCommandOutputDataOutput$Response
_$VerifyTwoFactorThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return VerifyTwoFactorThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : VerifyTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : VerifyTwoFactorThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : VerifyTwoFactorThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        VerifyTwoFactorThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$VerifyTwoFactorThroughApiCommandOutputDataOutput$ResponseToJson(
  VerifyTwoFactorThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        VerifyTwoFactorThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        VerifyTwoFactorThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?VerifyTwoFactorThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

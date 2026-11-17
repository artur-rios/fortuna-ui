// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_two_factor_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response
_$ConfirmTwoFactorThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ConfirmTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ConfirmTwoFactorThroughApiCommandOutputDataOutput$ResponseToJson(
  ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?ConfirmTwoFactorThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

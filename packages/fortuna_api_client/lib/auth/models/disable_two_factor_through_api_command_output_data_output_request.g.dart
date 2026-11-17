// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disable_two_factor_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisableTwoFactorThroughApiCommandOutputDataOutput$Request
_$DisableTwoFactorThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return DisableTwoFactorThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : DisableTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : DisableTwoFactorThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : DisableTwoFactorThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        DisableTwoFactorThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$DisableTwoFactorThroughApiCommandOutputDataOutput$RequestToJson(
  DisableTwoFactorThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        DisableTwoFactorThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        DisableTwoFactorThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?DisableTwoFactorThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

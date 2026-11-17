// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_two_factor_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableTwoFactorThroughApiCommandOutputDataOutput$Request
_$EnableTwoFactorThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return EnableTwoFactorThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : EnableTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : EnableTwoFactorThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : EnableTwoFactorThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        EnableTwoFactorThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$EnableTwoFactorThroughApiCommandOutputDataOutput$RequestToJson(
  EnableTwoFactorThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        EnableTwoFactorThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        EnableTwoFactorThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?EnableTwoFactorThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_two_factor_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTwoFactorThroughApiCommandOutputDataOutput$Request
_$VerifyTwoFactorThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return VerifyTwoFactorThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : VerifyTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : VerifyTwoFactorThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : VerifyTwoFactorThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        VerifyTwoFactorThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$VerifyTwoFactorThroughApiCommandOutputDataOutput$RequestToJson(
  VerifyTwoFactorThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        VerifyTwoFactorThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        VerifyTwoFactorThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?VerifyTwoFactorThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

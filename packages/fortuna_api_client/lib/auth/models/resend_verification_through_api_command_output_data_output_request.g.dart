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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ResendVerificationThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ResendVerificationThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ResendVerificationThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ResendVerificationThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        ResendVerificationThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ResendVerificationThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?ResendVerificationThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

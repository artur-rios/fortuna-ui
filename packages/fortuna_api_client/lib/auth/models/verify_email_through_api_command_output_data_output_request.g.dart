// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailThroughApiCommandOutputDataOutput$Request
_$VerifyEmailThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return VerifyEmailThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : VerifyEmailThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : VerifyEmailThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : VerifyEmailThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        VerifyEmailThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$VerifyEmailThroughApiCommandOutputDataOutput$RequestToJson(
  VerifyEmailThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        VerifyEmailThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        VerifyEmailThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?VerifyEmailThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

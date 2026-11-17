// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInThroughApiCommandOutputDataOutput$Request
_$GoogleSignInThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return GoogleSignInThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoogleSignInThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GoogleSignInThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : GoogleSignInThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        GoogleSignInThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GoogleSignInThroughApiCommandOutputDataOutput$RequestToJson(
  GoogleSignInThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        GoogleSignInThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        GoogleSignInThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?GoogleSignInThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

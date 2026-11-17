// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_out_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignOutThroughApiCommandOutputDataOutput$Request
_$GoogleSignOutThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return GoogleSignOutThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoogleSignOutThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GoogleSignOutThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : GoogleSignOutThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        GoogleSignOutThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GoogleSignOutThroughApiCommandOutputDataOutput$RequestToJson(
  GoogleSignOutThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        GoogleSignOutThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        GoogleSignOutThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?GoogleSignOutThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

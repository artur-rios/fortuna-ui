// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoke_connection_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevokeConnectionCommandOutputDataOutput$Request
_$RevokeConnectionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RevokeConnectionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RevokeConnectionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RevokeConnectionCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RevokeConnectionCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: RevokeConnectionCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RevokeConnectionCommandOutputDataOutput$RequestToJson(
  RevokeConnectionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RevokeConnectionCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': RevokeConnectionCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?RevokeConnectionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

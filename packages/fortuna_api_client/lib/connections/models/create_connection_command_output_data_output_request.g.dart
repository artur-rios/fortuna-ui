// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_connection_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConnectionCommandOutputDataOutput$Request
_$CreateConnectionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreateConnectionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateConnectionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateConnectionCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateConnectionCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CreateConnectionCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateConnectionCommandOutputDataOutput$RequestToJson(
  CreateConnectionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreateConnectionCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': CreateConnectionCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?CreateConnectionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

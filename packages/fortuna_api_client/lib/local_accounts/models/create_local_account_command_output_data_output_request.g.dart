// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_local_account_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLocalAccountCommandOutputDataOutput$Request
_$CreateLocalAccountCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreateLocalAccountCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateLocalAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateLocalAccountCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateLocalAccountCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        CreateLocalAccountCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$CreateLocalAccountCommandOutputDataOutput$RequestToJson(
  CreateLocalAccountCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreateLocalAccountCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        CreateLocalAccountCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?CreateLocalAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

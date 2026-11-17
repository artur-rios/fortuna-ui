// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommandOutputDataOutput$Request
_$RecoverLocalAccountCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecoverLocalAccountCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecoverLocalAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecoverLocalAccountCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecoverLocalAccountCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RecoverLocalAccountCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$RecoverLocalAccountCommandOutputDataOutput$RequestToJson(
  RecoverLocalAccountCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RecoverLocalAccountCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RecoverLocalAccountCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RecoverLocalAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

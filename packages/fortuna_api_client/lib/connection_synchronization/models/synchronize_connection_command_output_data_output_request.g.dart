// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_connection_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeConnectionCommandOutputDataOutput$Request
_$SynchronizeConnectionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return SynchronizeConnectionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : SynchronizeConnectionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : SynchronizeConnectionCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : SynchronizeConnectionCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        SynchronizeConnectionCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$SynchronizeConnectionCommandOutputDataOutput$RequestToJson(
  SynchronizeConnectionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        SynchronizeConnectionCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        SynchronizeConnectionCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?SynchronizeConnectionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

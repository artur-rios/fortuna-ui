// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transfer_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransferCommandOutputDataOutput$Request
_$RecordTransferCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecordTransferCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordTransferCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordTransferCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordTransferCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: RecordTransferCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RecordTransferCommandOutputDataOutput$RequestToJson(
  RecordTransferCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RecordTransferCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': RecordTransferCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?RecordTransferCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transaction_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransactionCommandOutputDataOutput$Request
_$RecordTransactionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecordTransactionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordTransactionCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordTransactionCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: RecordTransactionCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RecordTransactionCommandOutputDataOutput$RequestToJson(
  RecordTransactionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RecordTransactionCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RecordTransactionCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RecordTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

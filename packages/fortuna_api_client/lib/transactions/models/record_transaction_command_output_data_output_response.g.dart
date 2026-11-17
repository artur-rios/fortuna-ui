// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transaction_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransactionCommandOutputDataOutput$Response
_$RecordTransactionCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RecordTransactionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RecordTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordTransactionCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordTransactionCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RecordTransactionCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$RecordTransactionCommandOutputDataOutput$ResponseToJson(
  RecordTransactionCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RecordTransactionCommandOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RecordTransactionCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RecordTransactionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

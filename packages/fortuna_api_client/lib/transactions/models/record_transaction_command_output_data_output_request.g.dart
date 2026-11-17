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
    disallowNullValues: const ['timestamp'],
  );
  return RecordTransactionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: RecordTransactionCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RecordTransactionCommandOutputDataOutput$RequestToJson(
  RecordTransactionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RecordTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

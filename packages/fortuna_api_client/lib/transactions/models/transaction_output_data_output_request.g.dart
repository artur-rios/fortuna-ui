// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionOutputDataOutput$Request
_$TransactionOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransactionOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TransactionOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TransactionOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: TransactionOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionOutputDataOutput$RequestToJson(
  TransactionOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TransactionOutputDataOutput$Request._write_messages($value),
  'timestamp': ?TransactionOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

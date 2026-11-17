// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionOutputDataOutput$Response
_$TransactionOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return TransactionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TransactionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TransactionOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TransactionOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: TransactionOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionOutputDataOutput$ResponseToJson(
  TransactionOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TransactionOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?TransactionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

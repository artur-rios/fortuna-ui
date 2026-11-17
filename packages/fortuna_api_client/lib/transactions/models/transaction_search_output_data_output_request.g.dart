// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_search_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSearchOutputDataOutput$Request
_$TransactionSearchOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransactionSearchOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionSearchOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransactionSearchOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransactionSearchOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: TransactionSearchOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionSearchOutputDataOutput$RequestToJson(
  TransactionSearchOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionSearchOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TransactionSearchOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?TransactionSearchOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

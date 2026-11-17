// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_search_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSearchOutputDataOutput$Response
_$TransactionSearchOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return TransactionSearchOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TransactionSearchOutput$Response.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransactionSearchOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransactionSearchOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: TransactionSearchOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionSearchOutputDataOutput$ResponseToJson(
  TransactionSearchOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionSearchOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TransactionSearchOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?TransactionSearchOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

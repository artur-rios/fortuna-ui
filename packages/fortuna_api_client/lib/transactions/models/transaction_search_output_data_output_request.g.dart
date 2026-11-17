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
    disallowNullValues: const ['timestamp'],
  );
  return TransactionSearchOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionSearchOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: TransactionSearchOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionSearchOutputDataOutput$RequestToJson(
  TransactionSearchOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?TransactionSearchOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

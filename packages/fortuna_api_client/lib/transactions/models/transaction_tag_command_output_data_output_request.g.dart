// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tag_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTagCommandOutputDataOutput$Request
_$TransactionTagCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return TransactionTagCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionTagCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: TransactionTagCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionTagCommandOutputDataOutput$RequestToJson(
  TransactionTagCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?TransactionTagCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

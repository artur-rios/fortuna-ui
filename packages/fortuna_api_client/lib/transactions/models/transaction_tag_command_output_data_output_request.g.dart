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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransactionTagCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionTagCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransactionTagCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransactionTagCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: TransactionTagCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionTagCommandOutputDataOutput$RequestToJson(
  TransactionTagCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionTagCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': TransactionTagCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?TransactionTagCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

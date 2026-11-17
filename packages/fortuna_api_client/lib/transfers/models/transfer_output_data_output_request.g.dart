// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferOutputDataOutput$Request _$TransferOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransferOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransferOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TransferOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TransferOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: TransferOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransferOutputDataOutput$RequestToJson(
  TransferOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransferOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TransferOutputDataOutput$Request._write_messages($value),
  'timestamp': ?TransferOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

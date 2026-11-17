// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionOutputDataOutput$Request _$ConnectionOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ConnectionOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ConnectionOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : ConnectionOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : ConnectionOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: ConnectionOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ConnectionOutputDataOutput$RequestToJson(
  ConnectionOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ConnectionOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ConnectionOutputDataOutput$Request._write_messages($value),
  'timestamp': ?ConnectionOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

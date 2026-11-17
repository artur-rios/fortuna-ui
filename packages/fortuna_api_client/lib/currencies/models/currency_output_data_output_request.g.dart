// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyOutputDataOutput$Request _$CurrencyOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CurrencyOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CurrencyOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CurrencyOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CurrencyOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: CurrencyOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CurrencyOutputDataOutput$RequestToJson(
  CurrencyOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CurrencyOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CurrencyOutputDataOutput$Request._write_messages($value),
  'timestamp': ?CurrencyOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

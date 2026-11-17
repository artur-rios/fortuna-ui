// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutputDataOutput$Request _$CreditCardOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreditCardOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreditCardOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CreditCardOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: CreditCardOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreditCardOutputDataOutput$RequestToJson(
  CreditCardOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreditCardOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CreditCardOutputDataOutput$Request._write_messages($value),
  'timestamp': ?CreditCardOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

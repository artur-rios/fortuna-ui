// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutputDataOutput$Response
_$CreditCardOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CreditCardOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreditCardOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CreditCardOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: CreditCardOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreditCardOutputDataOutput$ResponseToJson(
  CreditCardOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreditCardOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CreditCardOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?CreditCardOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

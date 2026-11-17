// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutputDataOutput$Request
_$CreditCardStatementOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreditCardStatementOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreditCardStatementOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardStatementOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreditCardStatementOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CreditCardStatementOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreditCardStatementOutputDataOutput$RequestToJson(
  CreditCardStatementOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreditCardStatementOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CreditCardStatementOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?CreditCardStatementOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

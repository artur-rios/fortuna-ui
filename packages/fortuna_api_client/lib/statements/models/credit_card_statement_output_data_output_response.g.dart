// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutputDataOutput$Response
_$CreditCardStatementOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CreditCardStatementOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreditCardStatementOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardStatementOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreditCardStatementOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: CreditCardStatementOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreditCardStatementOutputDataOutput$ResponseToJson(
  CreditCardStatementOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreditCardStatementOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': CreditCardStatementOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?CreditCardStatementOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

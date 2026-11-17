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
    disallowNullValues: const ['timestamp'],
  );
  return CreditCardStatementOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreditCardStatementOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CreditCardStatementOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreditCardStatementOutputDataOutput$RequestToJson(
  CreditCardStatementOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?CreditCardStatementOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

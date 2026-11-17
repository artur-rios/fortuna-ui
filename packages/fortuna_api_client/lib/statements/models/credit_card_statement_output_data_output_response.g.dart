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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CreditCardStatementOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?CreditCardStatementOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

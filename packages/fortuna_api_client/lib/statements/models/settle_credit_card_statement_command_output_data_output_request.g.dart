// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settle_credit_card_statement_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettleCreditCardStatementCommandOutputDataOutput$Request
_$SettleCreditCardStatementCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return SettleCreditCardStatementCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : SettleCreditCardStatementCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        SettleCreditCardStatementCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$SettleCreditCardStatementCommandOutputDataOutput$RequestToJson(
  SettleCreditCardStatementCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?SettleCreditCardStatementCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

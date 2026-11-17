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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return SettleCreditCardStatementCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : SettleCreditCardStatementCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : SettleCreditCardStatementCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : SettleCreditCardStatementCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        SettleCreditCardStatementCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        SettleCreditCardStatementCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?SettleCreditCardStatementCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

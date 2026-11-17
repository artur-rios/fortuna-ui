// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settle_credit_card_statement_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettleCreditCardStatementCommandOutputDataOutput$Response
_$SettleCreditCardStatementCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return SettleCreditCardStatementCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : SettleCreditCardStatementCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : SettleCreditCardStatementCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : SettleCreditCardStatementCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        SettleCreditCardStatementCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$SettleCreditCardStatementCommandOutputDataOutput$ResponseToJson(
  SettleCreditCardStatementCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        SettleCreditCardStatementCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        SettleCreditCardStatementCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?SettleCreditCardStatementCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

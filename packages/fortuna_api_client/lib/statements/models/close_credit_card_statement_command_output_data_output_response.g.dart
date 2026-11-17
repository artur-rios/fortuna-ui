// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_credit_card_statement_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloseCreditCardStatementCommandOutputDataOutput$Response
_$CloseCreditCardStatementCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CloseCreditCardStatementCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CloseCreditCardStatementCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CloseCreditCardStatementCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CloseCreditCardStatementCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        CloseCreditCardStatementCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$CloseCreditCardStatementCommandOutputDataOutput$ResponseToJson(
  CloseCreditCardStatementCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        CloseCreditCardStatementCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        CloseCreditCardStatementCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?CloseCreditCardStatementCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

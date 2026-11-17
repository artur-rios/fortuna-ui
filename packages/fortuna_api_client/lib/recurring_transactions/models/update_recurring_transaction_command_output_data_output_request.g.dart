// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_recurring_transaction_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRecurringTransactionCommandOutputDataOutput$Request
_$UpdateRecurringTransactionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return UpdateRecurringTransactionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateRecurringTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateRecurringTransactionCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateRecurringTransactionCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        UpdateRecurringTransactionCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$UpdateRecurringTransactionCommandOutputDataOutput$RequestToJson(
  UpdateRecurringTransactionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        UpdateRecurringTransactionCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        UpdateRecurringTransactionCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?UpdateRecurringTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

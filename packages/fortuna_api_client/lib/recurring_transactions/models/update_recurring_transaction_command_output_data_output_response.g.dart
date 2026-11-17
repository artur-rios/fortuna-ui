// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_recurring_transaction_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRecurringTransactionCommandOutputDataOutput$Response
_$UpdateRecurringTransactionCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return UpdateRecurringTransactionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : UpdateRecurringTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateRecurringTransactionCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateRecurringTransactionCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        UpdateRecurringTransactionCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$UpdateRecurringTransactionCommandOutputDataOutput$ResponseToJson(
  UpdateRecurringTransactionCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        UpdateRecurringTransactionCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        UpdateRecurringTransactionCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?UpdateRecurringTransactionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

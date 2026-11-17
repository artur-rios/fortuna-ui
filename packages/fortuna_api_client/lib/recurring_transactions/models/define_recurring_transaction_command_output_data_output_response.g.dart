// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'define_recurring_transaction_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefineRecurringTransactionCommandOutputDataOutput$Response
_$DefineRecurringTransactionCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return DefineRecurringTransactionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : DefineRecurringTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : DefineRecurringTransactionCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : DefineRecurringTransactionCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        DefineRecurringTransactionCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$DefineRecurringTransactionCommandOutputDataOutput$ResponseToJson(
  DefineRecurringTransactionCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        DefineRecurringTransactionCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        DefineRecurringTransactionCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?DefineRecurringTransactionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

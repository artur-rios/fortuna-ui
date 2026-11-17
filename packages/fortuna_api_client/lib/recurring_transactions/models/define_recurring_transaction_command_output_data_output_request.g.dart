// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'define_recurring_transaction_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefineRecurringTransactionCommandOutputDataOutput$Request
_$DefineRecurringTransactionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return DefineRecurringTransactionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : DefineRecurringTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : DefineRecurringTransactionCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : DefineRecurringTransactionCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        DefineRecurringTransactionCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$DefineRecurringTransactionCommandOutputDataOutput$RequestToJson(
  DefineRecurringTransactionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        DefineRecurringTransactionCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        DefineRecurringTransactionCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?DefineRecurringTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

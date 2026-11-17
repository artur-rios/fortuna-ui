// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialize_recurring_transactions_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterializeRecurringTransactionsCommandOutputDataOutput$Request
_$MaterializeRecurringTransactionsCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return MaterializeRecurringTransactionsCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : MaterializeRecurringTransactionsCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : MaterializeRecurringTransactionsCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : MaterializeRecurringTransactionsCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        MaterializeRecurringTransactionsCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$MaterializeRecurringTransactionsCommandOutputDataOutput$RequestToJson(
  MaterializeRecurringTransactionsCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        MaterializeRecurringTransactionsCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        MaterializeRecurringTransactionsCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?MaterializeRecurringTransactionsCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

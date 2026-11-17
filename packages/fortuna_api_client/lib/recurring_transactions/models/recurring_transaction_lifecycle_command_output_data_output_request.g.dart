// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionLifecycleCommandOutputDataOutput$Request
_$RecurringTransactionLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecurringTransactionLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecurringTransactionLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecurringTransactionLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecurringTransactionLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RecurringTransactionLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecurringTransactionLifecycleCommandOutputDataOutput$RequestToJson(
  RecurringTransactionLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecurringTransactionLifecycleCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecurringTransactionLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RecurringTransactionLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

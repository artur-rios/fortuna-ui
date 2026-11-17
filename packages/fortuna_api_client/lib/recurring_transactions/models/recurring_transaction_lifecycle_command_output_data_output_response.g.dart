// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_lifecycle_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionLifecycleCommandOutputDataOutput$Response
_$RecurringTransactionLifecycleCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RecurringTransactionLifecycleCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RecurringTransactionLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecurringTransactionLifecycleCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecurringTransactionLifecycleCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RecurringTransactionLifecycleCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecurringTransactionLifecycleCommandOutputDataOutput$ResponseToJson(
  RecurringTransactionLifecycleCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecurringTransactionLifecycleCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecurringTransactionLifecycleCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RecurringTransactionLifecycleCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

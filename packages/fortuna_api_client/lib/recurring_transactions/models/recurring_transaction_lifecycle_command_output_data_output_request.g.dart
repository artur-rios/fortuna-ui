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
    disallowNullValues: const ['timestamp'],
  );
  return RecurringTransactionLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecurringTransactionLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RecurringTransactionLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

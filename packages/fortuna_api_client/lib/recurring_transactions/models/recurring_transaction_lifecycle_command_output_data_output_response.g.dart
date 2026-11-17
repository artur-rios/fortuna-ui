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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RecurringTransactionLifecycleCommandOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RecurringTransactionLifecycleCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return UpdateRecurringTransactionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : UpdateRecurringTransactionCommandOutput.fromJson(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?UpdateRecurringTransactionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

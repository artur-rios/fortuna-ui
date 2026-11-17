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
    disallowNullValues: const ['timestamp'],
  );
  return UpdateRecurringTransactionCommandOutputDataOutput$Request(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?UpdateRecurringTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

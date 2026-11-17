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
    disallowNullValues: const ['timestamp'],
  );
  return DefineRecurringTransactionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : DefineRecurringTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?DefineRecurringTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

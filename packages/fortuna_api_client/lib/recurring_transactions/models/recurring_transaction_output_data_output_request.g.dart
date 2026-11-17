// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionOutputDataOutput$Request
_$RecurringTransactionOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return RecurringTransactionOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecurringTransactionOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: RecurringTransactionOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RecurringTransactionOutputDataOutput$RequestToJson(
  RecurringTransactionOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?RecurringTransactionOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

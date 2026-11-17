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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecurringTransactionOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecurringTransactionOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecurringTransactionOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecurringTransactionOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: RecurringTransactionOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RecurringTransactionOutputDataOutput$RequestToJson(
  RecurringTransactionOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RecurringTransactionOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': RecurringTransactionOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?RecurringTransactionOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

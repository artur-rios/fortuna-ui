// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialize_recurring_transactions_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterializeRecurringTransactionsCommandOutputDataOutput$Response
_$MaterializeRecurringTransactionsCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return MaterializeRecurringTransactionsCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : MaterializeRecurringTransactionsCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : MaterializeRecurringTransactionsCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : MaterializeRecurringTransactionsCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        MaterializeRecurringTransactionsCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$MaterializeRecurringTransactionsCommandOutputDataOutput$ResponseToJson(
  MaterializeRecurringTransactionsCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        MaterializeRecurringTransactionsCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        MaterializeRecurringTransactionsCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?MaterializeRecurringTransactionsCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

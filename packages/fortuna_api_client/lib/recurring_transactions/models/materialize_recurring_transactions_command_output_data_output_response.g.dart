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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return MaterializeRecurringTransactionsCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : MaterializeRecurringTransactionsCommandOutput.fromJson(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?MaterializeRecurringTransactionsCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

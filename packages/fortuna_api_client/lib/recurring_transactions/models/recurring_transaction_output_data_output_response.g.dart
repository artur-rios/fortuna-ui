// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionOutputDataOutput$Response
_$RecurringTransactionOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RecurringTransactionOutputDataOutput$Response(
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
    success: json['success'] as bool?,
    timestamp: RecurringTransactionOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RecurringTransactionOutputDataOutput$ResponseToJson(
  RecurringTransactionOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?RecurringTransactionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

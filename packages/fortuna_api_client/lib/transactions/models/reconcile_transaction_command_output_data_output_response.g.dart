// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconcile_transaction_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconcileTransactionCommandOutputDataOutput$Response
_$ReconcileTransactionCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ReconcileTransactionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ReconcileTransactionCommandOutput.fromJson(
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
        ReconcileTransactionCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ReconcileTransactionCommandOutputDataOutput$ResponseToJson(
  ReconcileTransactionCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?ReconcileTransactionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

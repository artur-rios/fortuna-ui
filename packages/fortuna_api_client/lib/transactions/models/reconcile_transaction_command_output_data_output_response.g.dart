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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ReconcileTransactionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ReconcileTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ReconcileTransactionCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ReconcileTransactionCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        ReconcileTransactionCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ReconcileTransactionCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?ReconcileTransactionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

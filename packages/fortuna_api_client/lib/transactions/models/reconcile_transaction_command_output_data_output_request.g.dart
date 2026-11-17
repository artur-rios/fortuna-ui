// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconcile_transaction_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconcileTransactionCommandOutputDataOutput$Request
_$ReconcileTransactionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ReconcileTransactionCommandOutputDataOutput$Request(
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
    timestamp:
        ReconcileTransactionCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ReconcileTransactionCommandOutputDataOutput$RequestToJson(
  ReconcileTransactionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ReconcileTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

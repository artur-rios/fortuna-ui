// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_lifecycle_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionLifecycleCommandOutputDataOutput$Response
_$TransactionLifecycleCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return TransactionLifecycleCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TransactionLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransactionLifecycleCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransactionLifecycleCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        TransactionLifecycleCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$TransactionLifecycleCommandOutputDataOutput$ResponseToJson(
  TransactionLifecycleCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        TransactionLifecycleCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        TransactionLifecycleCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?TransactionLifecycleCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};

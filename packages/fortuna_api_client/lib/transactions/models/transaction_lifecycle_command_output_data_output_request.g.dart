// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionLifecycleCommandOutputDataOutput$Request
_$TransactionLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransactionLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransactionLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransactionLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        TransactionLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$TransactionLifecycleCommandOutputDataOutput$RequestToJson(
  TransactionLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionLifecycleCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        TransactionLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?TransactionLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

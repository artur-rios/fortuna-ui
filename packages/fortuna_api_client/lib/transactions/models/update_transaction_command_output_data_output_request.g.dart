// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionCommandOutputDataOutput$Request
_$UpdateTransactionCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return UpdateTransactionCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateTransactionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateTransactionCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateTransactionCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: UpdateTransactionCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateTransactionCommandOutputDataOutput$RequestToJson(
  UpdateTransactionCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UpdateTransactionCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        UpdateTransactionCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?UpdateTransactionCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

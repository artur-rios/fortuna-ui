// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferLifecycleCommandOutputDataOutput$Request
_$TransferLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransferLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransferLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransferLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransferLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: TransferLifecycleCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransferLifecycleCommandOutputDataOutput$RequestToJson(
  TransferLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransferLifecycleCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        TransferLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?TransferLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

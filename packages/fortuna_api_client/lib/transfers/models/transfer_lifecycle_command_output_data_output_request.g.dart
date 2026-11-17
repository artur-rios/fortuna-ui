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
    disallowNullValues: const ['timestamp'],
  );
  return TransferLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransferLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: TransferLifecycleCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransferLifecycleCommandOutputDataOutput$RequestToJson(
  TransferLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?TransferLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

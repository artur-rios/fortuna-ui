// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transfer_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransferCommandOutputDataOutput$Request
_$RecordTransferCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return RecordTransferCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordTransferCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: RecordTransferCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RecordTransferCommandOutputDataOutput$RequestToJson(
  RecordTransferCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?RecordTransferCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

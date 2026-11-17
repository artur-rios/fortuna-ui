// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry_import_job_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetryImportJobCommandOutputDataOutput$Request
_$RetryImportJobCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return RetryImportJobCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RetryImportJobCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: RetryImportJobCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RetryImportJobCommandOutputDataOutput$RequestToJson(
  RetryImportJobCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?RetryImportJobCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

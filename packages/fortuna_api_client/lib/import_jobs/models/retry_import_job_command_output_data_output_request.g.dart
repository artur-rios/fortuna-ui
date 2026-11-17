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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RetryImportJobCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RetryImportJobCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RetryImportJobCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RetryImportJobCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: RetryImportJobCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RetryImportJobCommandOutputDataOutput$RequestToJson(
  RetryImportJobCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RetryImportJobCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': RetryImportJobCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?RetryImportJobCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

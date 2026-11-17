// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_job_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportJobOutputDataOutput$Request _$ImportJobOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ImportJobOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ImportJobOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : ImportJobOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : ImportJobOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: ImportJobOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ImportJobOutputDataOutput$RequestToJson(
  ImportJobOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ImportJobOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ImportJobOutputDataOutput$Request._write_messages($value),
  'timestamp': ?ImportJobOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

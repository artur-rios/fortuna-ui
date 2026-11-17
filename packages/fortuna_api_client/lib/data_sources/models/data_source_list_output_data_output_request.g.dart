// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_list_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceListOutputDataOutput$Request
_$DataSourceListOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return DataSourceListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : DataSourceListOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : DataSourceListOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : DataSourceListOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: DataSourceListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$DataSourceListOutputDataOutput$RequestToJson(
  DataSourceListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': DataSourceListOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': DataSourceListOutputDataOutput$Request._write_messages($value),
  'timestamp': ?DataSourceListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

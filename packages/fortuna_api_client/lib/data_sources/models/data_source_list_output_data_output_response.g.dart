// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceListOutputDataOutput$Response
_$DataSourceListOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return DataSourceListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : DataSourceListOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : DataSourceListOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : DataSourceListOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: DataSourceListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$DataSourceListOutputDataOutput$ResponseToJson(
  DataSourceListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': DataSourceListOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': DataSourceListOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?DataSourceListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

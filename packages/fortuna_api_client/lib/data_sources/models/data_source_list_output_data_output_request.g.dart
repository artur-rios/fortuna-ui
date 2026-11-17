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
    disallowNullValues: const ['timestamp'],
  );
  return DataSourceListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : DataSourceListOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: DataSourceListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$DataSourceListOutputDataOutput$RequestToJson(
  DataSourceListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?DataSourceListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

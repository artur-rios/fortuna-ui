// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutputDataOutput$Request _$TagListOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return TagListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TagListOutput$Request.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: TagListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TagListOutputDataOutput$RequestToJson(
  TagListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?TagListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

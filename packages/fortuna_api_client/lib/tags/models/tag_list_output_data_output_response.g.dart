// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutputDataOutput$Response _$TagListOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return TagListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TagListOutput$Response.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: TagListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TagListOutputDataOutput$ResponseToJson(
  TagListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?TagListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryTreeOutputDataOutput$Request
_$CategoryTreeOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return CategoryTreeOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CategoryTreeOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CategoryTreeOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CategoryTreeOutputDataOutput$RequestToJson(
  CategoryTreeOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?CategoryTreeOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

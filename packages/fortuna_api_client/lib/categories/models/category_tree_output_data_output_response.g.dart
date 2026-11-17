// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryTreeOutputDataOutput$Response
_$CategoryTreeOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CategoryTreeOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CategoryTreeOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: CategoryTreeOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CategoryTreeOutputDataOutput$ResponseToJson(
  CategoryTreeOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?CategoryTreeOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

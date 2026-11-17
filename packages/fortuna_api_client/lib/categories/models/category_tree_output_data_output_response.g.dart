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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CategoryTreeOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CategoryTreeOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CategoryTreeOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CategoryTreeOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors': CategoryTreeOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CategoryTreeOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?CategoryTreeOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

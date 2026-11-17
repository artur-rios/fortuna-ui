// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryOutputDataOutput$Response _$CategoryOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CategoryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CategoryOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CategoryOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CategoryOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: CategoryOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CategoryOutputDataOutput$ResponseToJson(
  CategoryOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CategoryOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CategoryOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?CategoryOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

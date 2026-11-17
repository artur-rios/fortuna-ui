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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CategoryTreeOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CategoryTreeOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CategoryTreeOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CategoryTreeOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: CategoryTreeOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CategoryTreeOutputDataOutput$RequestToJson(
  CategoryTreeOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CategoryTreeOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CategoryTreeOutputDataOutput$Request._write_messages($value),
  'timestamp': ?CategoryTreeOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

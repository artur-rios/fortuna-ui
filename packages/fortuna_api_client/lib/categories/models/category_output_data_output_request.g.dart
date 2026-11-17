// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryOutputDataOutput$Request _$CategoryOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CategoryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CategoryOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CategoryOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CategoryOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: CategoryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CategoryOutputDataOutput$RequestToJson(
  CategoryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CategoryOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CategoryOutputDataOutput$Request._write_messages($value),
  'timestamp': ?CategoryOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryCommandOutputDataOutput$Request
_$CreateCategoryCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreateCategoryCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateCategoryCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateCategoryCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateCategoryCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CreateCategoryCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateCategoryCommandOutputDataOutput$RequestToJson(
  CreateCategoryCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreateCategoryCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': CreateCategoryCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?CreateCategoryCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

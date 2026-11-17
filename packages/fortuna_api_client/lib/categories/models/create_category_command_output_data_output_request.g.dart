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
    disallowNullValues: const ['timestamp'],
  );
  return CreateCategoryCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateCategoryCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CreateCategoryCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateCategoryCommandOutputDataOutput$RequestToJson(
  CreateCategoryCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?CreateCategoryCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryCommandOutputDataOutput$Response
_$CreateCategoryCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CreateCategoryCommandOutputDataOutput$Response(
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
    success: json['success'] as bool?,
    timestamp: CreateCategoryCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateCategoryCommandOutputDataOutput$ResponseToJson(
  CreateCategoryCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?CreateCategoryCommandOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

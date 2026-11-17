// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryCommandOutputDataOutput$Response
_$UpdateCategoryCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return UpdateCategoryCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : UpdateCategoryCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateCategoryCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateCategoryCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: UpdateCategoryCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateCategoryCommandOutputDataOutput$ResponseToJson(
  UpdateCategoryCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UpdateCategoryCommandOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': UpdateCategoryCommandOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?UpdateCategoryCommandOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

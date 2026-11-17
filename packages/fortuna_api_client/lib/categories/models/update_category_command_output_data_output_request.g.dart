// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryCommandOutputDataOutput$Request
_$UpdateCategoryCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return UpdateCategoryCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateCategoryCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateCategoryCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateCategoryCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: UpdateCategoryCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateCategoryCommandOutputDataOutput$RequestToJson(
  UpdateCategoryCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UpdateCategoryCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': UpdateCategoryCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?UpdateCategoryCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLifecycleCommandOutputDataOutput$Request
_$CategoryLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CategoryLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CategoryLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CategoryLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CategoryLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CategoryLifecycleCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CategoryLifecycleCommandOutputDataOutput$RequestToJson(
  CategoryLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CategoryLifecycleCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        CategoryLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?CategoryLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

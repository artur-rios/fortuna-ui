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
    disallowNullValues: const ['timestamp'],
  );
  return CategoryLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CategoryLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CategoryLifecycleCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CategoryLifecycleCommandOutputDataOutput$RequestToJson(
  CategoryLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?CategoryLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};

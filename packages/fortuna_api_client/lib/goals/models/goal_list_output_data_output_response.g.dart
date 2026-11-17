// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalListOutputDataOutput$Response _$GoalListOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return GoalListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoalListOutput$Response.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: GoalListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$GoalListOutputDataOutput$ResponseToJson(
  GoalListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?GoalListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};

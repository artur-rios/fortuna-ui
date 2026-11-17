// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalOutputDataOutput$Request _$GoalOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return GoalOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoalOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: GoalOutputDataOutput$Request._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$GoalOutputDataOutput$RequestToJson(
  GoalOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?GoalOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};

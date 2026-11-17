// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_resource_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalResourceCommandOutput _$GoalResourceCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'name'],
    disallowNullValues: const ['id'],
  );
  return GoalResourceCommandOutput(
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : GoalResourceCommandOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$GoalResourceCommandOutputToJson(
  GoalResourceCommandOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': GoalResourceCommandOutput._write_name($value),
};

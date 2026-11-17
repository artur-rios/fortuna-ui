// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_tag_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTagCommand _$CreateTagCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['name']);
  return CreateTagCommand(
    name: !json.containsKey('name')
        ? null
        : CreateTagCommand._read_name(json['name']),
  );
}

Map<String, dynamic> _$CreateTagCommandToJson(CreateTagCommand instance) =>
    <String, dynamic>{
      if (instance.name case final $value?)
        'name': CreateTagCommand._write_name($value),
    };

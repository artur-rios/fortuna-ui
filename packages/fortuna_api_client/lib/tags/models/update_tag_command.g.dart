// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_tag_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTagCommand _$UpdateTagCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['name']);
  return UpdateTagCommand(
    name: !json.containsKey('name')
        ? null
        : UpdateTagCommand._read_name(json['name']),
  );
}

Map<String, dynamic> _$UpdateTagCommandToJson(UpdateTagCommand instance) =>
    <String, dynamic>{
      if (instance.name case final $value?)
        'name': UpdateTagCommand._write_name($value),
    };

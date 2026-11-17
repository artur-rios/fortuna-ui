// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'erase_user_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EraseUserCommand _$EraseUserCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['confirmation']);
  return EraseUserCommand(
    confirmation: !json.containsKey('confirmation')
        ? null
        : EraseUserCommand._read_confirmation(json['confirmation']),
  );
}

Map<String, dynamic> _$EraseUserCommandToJson(EraseUserCommand instance) =>
    <String, dynamic>{
      if (instance.confirmation case final $value?)
        'confirmation': EraseUserCommand._write_confirmation($value),
    };

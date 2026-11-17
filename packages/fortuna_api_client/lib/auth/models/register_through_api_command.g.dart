// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterThroughApiCommand _$RegisterThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['email', 'name', 'password']);
  return RegisterThroughApiCommand(
    email: !json.containsKey('email')
        ? null
        : RegisterThroughApiCommand._read_email(json['email']),
    name: !json.containsKey('name')
        ? null
        : RegisterThroughApiCommand._read_name(json['name']),
    password: !json.containsKey('password')
        ? null
        : RegisterThroughApiCommand._read_password(json['password']),
  );
}

Map<String, dynamic> _$RegisterThroughApiCommandToJson(
  RegisterThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.email case final $value?)
    'email': RegisterThroughApiCommand._write_email($value),
  if (instance.name case final $value?)
    'name': RegisterThroughApiCommand._write_name($value),
  if (instance.password case final $value?)
    'password': RegisterThroughApiCommand._write_password($value),
};

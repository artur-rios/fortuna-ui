// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginThroughApiCommand _$LoginThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['email', 'password']);
  return LoginThroughApiCommand(
    email: !json.containsKey('email')
        ? null
        : LoginThroughApiCommand._read_email(json['email']),
    password: !json.containsKey('password')
        ? null
        : LoginThroughApiCommand._read_password(json['password']),
  );
}

Map<String, dynamic> _$LoginThroughApiCommandToJson(
  LoginThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.email case final $value?)
    'email': LoginThroughApiCommand._write_email($value),
  if (instance.password case final $value?)
    'password': LoginThroughApiCommand._write_password($value),
};

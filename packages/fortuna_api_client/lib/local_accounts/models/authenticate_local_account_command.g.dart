// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_local_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateLocalAccountCommand _$AuthenticateLocalAccountCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['name', 'secret']);
  return AuthenticateLocalAccountCommand(
    name: !json.containsKey('name')
        ? null
        : AuthenticateLocalAccountCommand._read_name(json['name']),
    secret: !json.containsKey('secret')
        ? null
        : AuthenticateLocalAccountCommand._read_secret(json['secret']),
  );
}

Map<String, dynamic> _$AuthenticateLocalAccountCommandToJson(
  AuthenticateLocalAccountCommand instance,
) => <String, dynamic>{
  if (instance.name case final $value?)
    'name': AuthenticateLocalAccountCommand._write_name($value),
  if (instance.secret case final $value?)
    'secret': AuthenticateLocalAccountCommand._write_secret($value),
};

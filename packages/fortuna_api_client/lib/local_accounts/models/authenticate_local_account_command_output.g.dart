// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_local_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateLocalAccountCommandOutput
_$AuthenticateLocalAccountCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['expiresAt', 'token'],
    disallowNullValues: const ['expiresAt'],
  );
  return AuthenticateLocalAccountCommandOutput(
    expiresAt: AuthenticateLocalAccountCommandOutput._read_expiresAt(
      json['expiresAt'],
    ),
    token: !json.containsKey('token')
        ? null
        : AuthenticateLocalAccountCommandOutput._read_token(json['token']),
  );
}

Map<String, dynamic> _$AuthenticateLocalAccountCommandOutputToJson(
  AuthenticateLocalAccountCommandOutput instance,
) => <String, dynamic>{
  'expiresAt': ?AuthenticateLocalAccountCommandOutput._write_expiresAt(
    instance.expiresAt,
  ),
  if (instance.token case final $value?)
    'token': AuthenticateLocalAccountCommandOutput._write_token($value),
};

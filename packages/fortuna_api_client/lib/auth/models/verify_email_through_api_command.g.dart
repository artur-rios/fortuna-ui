// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailThroughApiCommand _$VerifyEmailThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['password', 'token']);
  return VerifyEmailThroughApiCommand(
    password: !json.containsKey('password')
        ? null
        : VerifyEmailThroughApiCommand._read_password(json['password']),
    token: !json.containsKey('token')
        ? null
        : VerifyEmailThroughApiCommand._read_token(json['token']),
  );
}

Map<String, dynamic> _$VerifyEmailThroughApiCommandToJson(
  VerifyEmailThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.password case final $value?)
    'password': VerifyEmailThroughApiCommand._write_password($value),
  if (instance.token case final $value?)
    'token': VerifyEmailThroughApiCommand._write_token($value),
};

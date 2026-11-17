// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordThroughApiCommand _$ResetPasswordThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['newPassword', 'token']);
  return ResetPasswordThroughApiCommand(
    newPassword: !json.containsKey('newPassword')
        ? null
        : ResetPasswordThroughApiCommand._read_newPassword(json['newPassword']),
    token: !json.containsKey('token')
        ? null
        : ResetPasswordThroughApiCommand._read_token(json['token']),
  );
}

Map<String, dynamic> _$ResetPasswordThroughApiCommandToJson(
  ResetPasswordThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.newPassword case final $value?)
    'newPassword': ResetPasswordThroughApiCommand._write_newPassword($value),
  if (instance.token case final $value?)
    'token': ResetPasswordThroughApiCommand._write_token($value),
};

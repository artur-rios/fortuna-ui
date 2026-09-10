// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordThroughApiCommand _$ResetPasswordThroughApiCommandFromJson(
  Map<String, dynamic> json,
) => ResetPasswordThroughApiCommand(
  newPassword: json['newPassword'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$ResetPasswordThroughApiCommandToJson(
  ResetPasswordThroughApiCommand instance,
) => <String, dynamic>{
  'newPassword': instance.newPassword,
  'token': instance.token,
};

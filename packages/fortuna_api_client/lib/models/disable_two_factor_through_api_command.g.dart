// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disable_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisableTwoFactorThroughApiCommand _$DisableTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) => DisableTwoFactorThroughApiCommand(
  code: json['code'] as String?,
  password: json['password'] as String?,
  recoveryCode: json['recoveryCode'] as String?,
);

Map<String, dynamic> _$DisableTwoFactorThroughApiCommandToJson(
  DisableTwoFactorThroughApiCommand instance,
) => <String, dynamic>{
  'code': instance.code,
  'password': instance.password,
  'recoveryCode': instance.recoveryCode,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disable_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisableTwoFactorThroughApiCommand _$DisableTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['code', 'password', 'recoveryCode']);
  return DisableTwoFactorThroughApiCommand(
    code: !json.containsKey('code')
        ? null
        : DisableTwoFactorThroughApiCommand._read_code(json['code']),
    password: !json.containsKey('password')
        ? null
        : DisableTwoFactorThroughApiCommand._read_password(json['password']),
    recoveryCode: !json.containsKey('recoveryCode')
        ? null
        : DisableTwoFactorThroughApiCommand._read_recoveryCode(
            json['recoveryCode'],
          ),
  );
}

Map<String, dynamic> _$DisableTwoFactorThroughApiCommandToJson(
  DisableTwoFactorThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.code case final $value?)
    'code': DisableTwoFactorThroughApiCommand._write_code($value),
  if (instance.password case final $value?)
    'password': DisableTwoFactorThroughApiCommand._write_password($value),
  if (instance.recoveryCode case final $value?)
    'recoveryCode': DisableTwoFactorThroughApiCommand._write_recoveryCode(
      $value,
    ),
};

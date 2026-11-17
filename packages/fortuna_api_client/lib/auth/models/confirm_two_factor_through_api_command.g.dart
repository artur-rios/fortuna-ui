// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmTwoFactorThroughApiCommand _$ConfirmTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['appCode', 'emailCode']);
  return ConfirmTwoFactorThroughApiCommand(
    appCode: !json.containsKey('appCode')
        ? null
        : ConfirmTwoFactorThroughApiCommand._read_appCode(json['appCode']),
    emailCode: !json.containsKey('emailCode')
        ? null
        : ConfirmTwoFactorThroughApiCommand._read_emailCode(json['emailCode']),
  );
}

Map<String, dynamic> _$ConfirmTwoFactorThroughApiCommandToJson(
  ConfirmTwoFactorThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.appCode case final $value?)
    'appCode': ConfirmTwoFactorThroughApiCommand._write_appCode($value),
  if (instance.emailCode case final $value?)
    'emailCode': ConfirmTwoFactorThroughApiCommand._write_emailCode($value),
};

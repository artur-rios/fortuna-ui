// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTwoFactorThroughApiCommand _$VerifyTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['challengeToken', 'code', 'recoveryCode'],
  );
  return VerifyTwoFactorThroughApiCommand(
    challengeToken: !json.containsKey('challengeToken')
        ? null
        : VerifyTwoFactorThroughApiCommand._read_challengeToken(
            json['challengeToken'],
          ),
    code: !json.containsKey('code')
        ? null
        : VerifyTwoFactorThroughApiCommand._read_code(json['code']),
    recoveryCode: !json.containsKey('recoveryCode')
        ? null
        : VerifyTwoFactorThroughApiCommand._read_recoveryCode(
            json['recoveryCode'],
          ),
  );
}

Map<String, dynamic> _$VerifyTwoFactorThroughApiCommandToJson(
  VerifyTwoFactorThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.challengeToken case final $value?)
    'challengeToken': VerifyTwoFactorThroughApiCommand._write_challengeToken(
      $value,
    ),
  if (instance.code case final $value?)
    'code': VerifyTwoFactorThroughApiCommand._write_code($value),
  if (instance.recoveryCode case final $value?)
    'recoveryCode': VerifyTwoFactorThroughApiCommand._write_recoveryCode(
      $value,
    ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_two_factor_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTwoFactorThroughApiCommandOutput
_$VerifyTwoFactorThroughApiCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['emailVerified', 'expiresAt', 'token'],
    disallowNullValues: const ['emailVerified', 'expiresAt'],
  );
  return VerifyTwoFactorThroughApiCommandOutput(
    emailVerified: json['emailVerified'] as bool?,
    expiresAt: VerifyTwoFactorThroughApiCommandOutput._read_expiresAt(
      json['expiresAt'],
    ),
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$VerifyTwoFactorThroughApiCommandOutputToJson(
  VerifyTwoFactorThroughApiCommandOutput instance,
) => <String, dynamic>{
  'emailVerified': ?instance.emailVerified,
  'expiresAt': ?VerifyTwoFactorThroughApiCommandOutput._write_expiresAt(
    instance.expiresAt,
  ),
  'token': ?instance.token,
};

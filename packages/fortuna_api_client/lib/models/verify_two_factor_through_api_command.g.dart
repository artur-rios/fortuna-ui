// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTwoFactorThroughApiCommand _$VerifyTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) => VerifyTwoFactorThroughApiCommand(
  challengeToken: json['challengeToken'] as String?,
  code: json['code'] as String?,
  recoveryCode: json['recoveryCode'] as String?,
);

Map<String, dynamic> _$VerifyTwoFactorThroughApiCommandToJson(
  VerifyTwoFactorThroughApiCommand instance,
) => <String, dynamic>{
  'challengeToken': instance.challengeToken,
  'code': instance.code,
  'recoveryCode': instance.recoveryCode,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_two_factor_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTwoFactorThroughApiCommandOutput
_$VerifyTwoFactorThroughApiCommandOutputFromJson(Map<String, dynamic> json) =>
    VerifyTwoFactorThroughApiCommandOutput(
      emailVerified: json['emailVerified'] as bool?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$VerifyTwoFactorThroughApiCommandOutputToJson(
  VerifyTwoFactorThroughApiCommandOutput instance,
) => <String, dynamic>{
  'emailVerified': instance.emailVerified,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'token': instance.token,
};

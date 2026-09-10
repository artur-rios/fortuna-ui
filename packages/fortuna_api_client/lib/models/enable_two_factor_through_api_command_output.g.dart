// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_two_factor_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableTwoFactorThroughApiCommandOutput
_$EnableTwoFactorThroughApiCommandOutputFromJson(Map<String, dynamic> json) =>
    EnableTwoFactorThroughApiCommandOutput(
      emailCodeSent: json['emailCodeSent'] as bool?,
      otpAuthUri: json['otpAuthUri'] as String?,
    );

Map<String, dynamic> _$EnableTwoFactorThroughApiCommandOutputToJson(
  EnableTwoFactorThroughApiCommandOutput instance,
) => <String, dynamic>{
  'emailCodeSent': instance.emailCodeSent,
  'otpAuthUri': instance.otpAuthUri,
};

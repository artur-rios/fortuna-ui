// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_two_factor_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableTwoFactorThroughApiCommandOutput
_$EnableTwoFactorThroughApiCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['emailCodeSent', 'otpAuthUri']);
  return EnableTwoFactorThroughApiCommandOutput(
    emailCodeSent: !json.containsKey('emailCodeSent')
        ? null
        : EnableTwoFactorThroughApiCommandOutput._read_emailCodeSent(
            json['emailCodeSent'],
          ),
    otpAuthUri: !json.containsKey('otpAuthUri')
        ? null
        : EnableTwoFactorThroughApiCommandOutput._read_otpAuthUri(
            json['otpAuthUri'],
          ),
  );
}

Map<String, dynamic> _$EnableTwoFactorThroughApiCommandOutputToJson(
  EnableTwoFactorThroughApiCommandOutput instance,
) => <String, dynamic>{
  if (instance.emailCodeSent case final $value?)
    'emailCodeSent':
        EnableTwoFactorThroughApiCommandOutput._write_emailCodeSent($value),
  if (instance.otpAuthUri case final $value?)
    'otpAuthUri': EnableTwoFactorThroughApiCommandOutput._write_otpAuthUri(
      $value,
    ),
};

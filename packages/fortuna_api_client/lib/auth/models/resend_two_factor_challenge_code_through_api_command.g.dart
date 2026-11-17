// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_two_factor_challenge_code_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResendTwoFactorChallengeCodeThroughApiCommand
_$ResendTwoFactorChallengeCodeThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['challengeToken']);
  return ResendTwoFactorChallengeCodeThroughApiCommand(
    challengeToken: !json.containsKey('challengeToken')
        ? null
        : ResendTwoFactorChallengeCodeThroughApiCommand._read_challengeToken(
            json['challengeToken'],
          ),
  );
}

Map<String, dynamic> _$ResendTwoFactorChallengeCodeThroughApiCommandToJson(
  ResendTwoFactorChallengeCodeThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.challengeToken case final $value?)
    'challengeToken':
        ResendTwoFactorChallengeCodeThroughApiCommand._write_challengeToken(
          $value,
        ),
};

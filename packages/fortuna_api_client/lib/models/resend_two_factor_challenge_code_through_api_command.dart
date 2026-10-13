// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'resend_two_factor_challenge_code_through_api_command.g.dart';

@JsonSerializable()
class ResendTwoFactorChallengeCodeThroughApiCommand {
  const ResendTwoFactorChallengeCodeThroughApiCommand({this.challengeToken});

  factory ResendTwoFactorChallengeCodeThroughApiCommand.fromJson(
    Map<String, Object?> json,
  ) => _$ResendTwoFactorChallengeCodeThroughApiCommandFromJson(json);

  final String? challengeToken;

  Map<String, Object?> toJson() =>
      _$ResendTwoFactorChallengeCodeThroughApiCommandToJson(this);
}

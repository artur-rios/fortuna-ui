// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'verify_two_factor_through_api_command.g.dart';

@JsonSerializable()
class VerifyTwoFactorThroughApiCommand {
  const VerifyTwoFactorThroughApiCommand({
    this.challengeToken,
    this.code,
    this.recoveryCode,
  });

  factory VerifyTwoFactorThroughApiCommand.fromJson(
    Map<String, Object?> json,
  ) => _$VerifyTwoFactorThroughApiCommandFromJson(json);

  final String? challengeToken;
  final String? code;
  final String? recoveryCode;

  Map<String, Object?> toJson() =>
      _$VerifyTwoFactorThroughApiCommandToJson(this);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'verify_two_factor_through_api_command_output.g.dart';

@JsonSerializable()
class VerifyTwoFactorThroughApiCommandOutput {
  const VerifyTwoFactorThroughApiCommandOutput({
    this.emailVerified,
    this.expiresAt,
    this.token,
  });

  factory VerifyTwoFactorThroughApiCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$VerifyTwoFactorThroughApiCommandOutputFromJson(json);

  final bool? emailVerified;
  final DateTime? expiresAt;
  final String? token;

  Map<String, Object?> toJson() =>
      _$VerifyTwoFactorThroughApiCommandOutputToJson(this);
}

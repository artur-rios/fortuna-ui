// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'login_through_api_command_output.g.dart';

@JsonSerializable()
class LoginThroughApiCommandOutput {
  const LoginThroughApiCommandOutput({
    this.availableMethods,
    this.challengeToken,
    this.emailVerified,
    this.expiresAt,
    this.requiresTwoFactor,
    this.token,
  });

  factory LoginThroughApiCommandOutput.fromJson(Map<String, Object?> json) =>
      _$LoginThroughApiCommandOutputFromJson(json);

  final List<String>? availableMethods;
  final String? challengeToken;
  final bool? emailVerified;
  final DateTime? expiresAt;
  final bool? requiresTwoFactor;
  final String? token;

  Map<String, Object?> toJson() => _$LoginThroughApiCommandOutputToJson(this);
}

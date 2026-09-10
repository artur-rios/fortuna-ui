// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'disable_two_factor_through_api_command.g.dart';

@JsonSerializable()
class DisableTwoFactorThroughApiCommand {
  const DisableTwoFactorThroughApiCommand({
    this.code,
    this.password,
    this.recoveryCode,
  });

  factory DisableTwoFactorThroughApiCommand.fromJson(
    Map<String, Object?> json,
  ) => _$DisableTwoFactorThroughApiCommandFromJson(json);

  final String? code;
  final String? password;
  final String? recoveryCode;

  Map<String, Object?> toJson() =>
      _$DisableTwoFactorThroughApiCommandToJson(this);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'confirm_two_factor_through_api_command_output.g.dart';

@JsonSerializable()
class ConfirmTwoFactorThroughApiCommandOutput {
  const ConfirmTwoFactorThroughApiCommandOutput({
    this.enabled,
    this.recoveryCodes,
  });

  factory ConfirmTwoFactorThroughApiCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ConfirmTwoFactorThroughApiCommandOutputFromJson(json);

  final bool? enabled;
  final List<String>? recoveryCodes;

  Map<String, Object?> toJson() =>
      _$ConfirmTwoFactorThroughApiCommandOutputToJson(this);
}

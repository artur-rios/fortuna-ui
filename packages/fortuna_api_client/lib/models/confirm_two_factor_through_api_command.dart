// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'confirm_two_factor_through_api_command.g.dart';

@JsonSerializable()
class ConfirmTwoFactorThroughApiCommand {
  const ConfirmTwoFactorThroughApiCommand({this.appCode, this.emailCode});

  factory ConfirmTwoFactorThroughApiCommand.fromJson(
    Map<String, Object?> json,
  ) => _$ConfirmTwoFactorThroughApiCommandFromJson(json);

  final String? appCode;
  final String? emailCode;

  Map<String, Object?> toJson() =>
      _$ConfirmTwoFactorThroughApiCommandToJson(this);
}

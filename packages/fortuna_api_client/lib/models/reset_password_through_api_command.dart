// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reset_password_through_api_command.g.dart';

@JsonSerializable()
class ResetPasswordThroughApiCommand {
  const ResetPasswordThroughApiCommand({this.newPassword, this.token});

  factory ResetPasswordThroughApiCommand.fromJson(Map<String, Object?> json) =>
      _$ResetPasswordThroughApiCommandFromJson(json);

  final String? newPassword;
  final String? token;

  Map<String, Object?> toJson() => _$ResetPasswordThroughApiCommandToJson(this);
}

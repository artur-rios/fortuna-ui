// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'verify_email_through_api_command.g.dart';

@JsonSerializable()
class VerifyEmailThroughApiCommand {
  const VerifyEmailThroughApiCommand({this.token});

  factory VerifyEmailThroughApiCommand.fromJson(Map<String, Object?> json) =>
      _$VerifyEmailThroughApiCommandFromJson(json);

  final String? token;

  Map<String, Object?> toJson() => _$VerifyEmailThroughApiCommandToJson(this);
}

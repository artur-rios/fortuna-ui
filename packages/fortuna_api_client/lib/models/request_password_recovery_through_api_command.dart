// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'request_password_recovery_through_api_command.g.dart';

@JsonSerializable()
class RequestPasswordRecoveryThroughApiCommand {
  const RequestPasswordRecoveryThroughApiCommand({this.email});

  factory RequestPasswordRecoveryThroughApiCommand.fromJson(
    Map<String, Object?> json,
  ) => _$RequestPasswordRecoveryThroughApiCommandFromJson(json);

  final String? email;

  Map<String, Object?> toJson() =>
      _$RequestPasswordRecoveryThroughApiCommandToJson(this);
}

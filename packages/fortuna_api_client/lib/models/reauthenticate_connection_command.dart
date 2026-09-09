// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reauthenticate_connection_command.g.dart';

@JsonSerializable()
class ReauthenticateConnectionCommand {
  const ReauthenticateConnectionCommand({this.externalReference});

  factory ReauthenticateConnectionCommand.fromJson(Map<String, Object?> json) =>
      _$ReauthenticateConnectionCommandFromJson(json);

  final String? externalReference;

  Map<String, Object?> toJson() =>
      _$ReauthenticateConnectionCommandToJson(this);
}

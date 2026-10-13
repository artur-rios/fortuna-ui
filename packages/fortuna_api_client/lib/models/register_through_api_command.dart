// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'register_through_api_command.g.dart';

@JsonSerializable()
class RegisterThroughApiCommand {
  const RegisterThroughApiCommand({this.email, this.name, this.password});

  factory RegisterThroughApiCommand.fromJson(Map<String, Object?> json) =>
      _$RegisterThroughApiCommandFromJson(json);

  final String? email;
  final String? name;
  final String? password;

  Map<String, Object?> toJson() => _$RegisterThroughApiCommandToJson(this);
}

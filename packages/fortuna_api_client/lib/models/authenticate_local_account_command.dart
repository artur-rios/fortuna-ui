// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'authenticate_local_account_command.g.dart';

@JsonSerializable()
class AuthenticateLocalAccountCommand {
  const AuthenticateLocalAccountCommand({this.name, this.secret});

  factory AuthenticateLocalAccountCommand.fromJson(Map<String, Object?> json) =>
      _$AuthenticateLocalAccountCommandFromJson(json);

  final String? name;
  final String? secret;

  Map<String, Object?> toJson() =>
      _$AuthenticateLocalAccountCommandToJson(this);
}

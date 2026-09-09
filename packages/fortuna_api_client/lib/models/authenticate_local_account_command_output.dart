// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'authenticate_local_account_command_output.g.dart';

@JsonSerializable()
class AuthenticateLocalAccountCommandOutput {
  const AuthenticateLocalAccountCommandOutput({this.expiresAt, this.token});

  factory AuthenticateLocalAccountCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$AuthenticateLocalAccountCommandOutputFromJson(json);

  final DateTime? expiresAt;
  final String? token;

  Map<String, Object?> toJson() =>
      _$AuthenticateLocalAccountCommandOutputToJson(this);
}

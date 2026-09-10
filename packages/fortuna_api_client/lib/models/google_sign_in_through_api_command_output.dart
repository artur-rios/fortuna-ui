// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'google_sign_in_through_api_command_output.g.dart';

@JsonSerializable()
class GoogleSignInThroughApiCommandOutput {
  const GoogleSignInThroughApiCommandOutput({
    this.emailVerified,
    this.expiresAt,
    this.token,
  });

  factory GoogleSignInThroughApiCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$GoogleSignInThroughApiCommandOutputFromJson(json);

  final bool? emailVerified;
  final DateTime? expiresAt;
  final String? token;

  Map<String, Object?> toJson() =>
      _$GoogleSignInThroughApiCommandOutputToJson(this);
}

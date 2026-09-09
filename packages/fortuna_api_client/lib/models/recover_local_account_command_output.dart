// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'recover_local_account_command_output.g.dart';

@JsonSerializable()
class RecoverLocalAccountCommandOutput {
  const RecoverLocalAccountCommandOutput({
    this.expiresAt,
    this.remainingRecoveryCodes,
    this.token,
  });

  factory RecoverLocalAccountCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecoverLocalAccountCommandOutputFromJson(json);

  final DateTime? expiresAt;
  final int? remainingRecoveryCodes;
  final String? token;

  Map<String, Object?> toJson() =>
      _$RecoverLocalAccountCommandOutputToJson(this);
}

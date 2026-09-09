// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'local_account_storage_mode.dart';

part 'create_local_account_command_output.g.dart';

@JsonSerializable()
class CreateLocalAccountCommandOutput {
  const CreateLocalAccountCommandOutput({
    this.createdAt,
    this.displayName,
    this.id,
    this.recoveryCodes,
    this.recoveryWarning,
    this.storageMode,
    this.userId,
  });

  factory CreateLocalAccountCommandOutput.fromJson(Map<String, Object?> json) =>
      _$CreateLocalAccountCommandOutputFromJson(json);

  final DateTime? createdAt;
  final String? displayName;
  final String? id;
  final List<String>? recoveryCodes;
  final String? recoveryWarning;
  final LocalAccountStorageMode? storageMode;
  final String? userId;

  Map<String, Object?> toJson() =>
      _$CreateLocalAccountCommandOutputToJson(this);
}

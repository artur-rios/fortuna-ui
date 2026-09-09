// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'local_account_storage_mode.dart';

part 'create_local_account_command.g.dart';

@JsonSerializable()
class CreateLocalAccountCommand {
  const CreateLocalAccountCommand({
    this.displayName,
    this.secret,
    this.storageMode,
  });

  factory CreateLocalAccountCommand.fromJson(Map<String, Object?> json) =>
      _$CreateLocalAccountCommandFromJson(json);

  final String? displayName;
  final String? secret;
  final LocalAccountStorageMode? storageMode;

  Map<String, Object?> toJson() => _$CreateLocalAccountCommandToJson(this);
}

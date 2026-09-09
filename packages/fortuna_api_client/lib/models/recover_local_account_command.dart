// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'recover_local_account_command.g.dart';

@JsonSerializable()
class RecoverLocalAccountCommand {
  const RecoverLocalAccountCommand({
    this.name,
    this.newSecret,
    this.recoveryCode,
  });

  factory RecoverLocalAccountCommand.fromJson(Map<String, Object?> json) =>
      _$RecoverLocalAccountCommandFromJson(json);

  final String? name;
  final String? newSecret;
  final String? recoveryCode;

  Map<String, Object?> toJson() => _$RecoverLocalAccountCommandToJson(this);
}

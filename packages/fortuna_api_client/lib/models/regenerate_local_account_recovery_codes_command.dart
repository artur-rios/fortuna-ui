// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'regenerate_local_account_recovery_codes_command.g.dart';

@JsonSerializable()
class RegenerateLocalAccountRecoveryCodesCommand {
  const RegenerateLocalAccountRecoveryCodesCommand({this.secret});

  factory RegenerateLocalAccountRecoveryCodesCommand.fromJson(
    Map<String, Object?> json,
  ) => _$RegenerateLocalAccountRecoveryCodesCommandFromJson(json);

  final String? secret;

  Map<String, Object?> toJson() =>
      _$RegenerateLocalAccountRecoveryCodesCommandToJson(this);
}

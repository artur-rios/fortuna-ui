// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'regenerate_local_account_recovery_codes_command_output.g.dart';

@JsonSerializable()
class RegenerateLocalAccountRecoveryCodesCommandOutput {
  const RegenerateLocalAccountRecoveryCodesCommandOutput({
    this.recoveryCodes,
    this.recoveryWarning,
  });

  factory RegenerateLocalAccountRecoveryCodesCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RegenerateLocalAccountRecoveryCodesCommandOutputFromJson(json);

  final List<String>? recoveryCodes;
  final String? recoveryWarning;

  Map<String, Object?> toJson() =>
      _$RegenerateLocalAccountRecoveryCodesCommandOutputToJson(this);
}

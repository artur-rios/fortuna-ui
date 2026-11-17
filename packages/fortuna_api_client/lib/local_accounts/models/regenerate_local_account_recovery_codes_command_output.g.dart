// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_local_account_recovery_codes_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateLocalAccountRecoveryCodesCommandOutput
_$RegenerateLocalAccountRecoveryCodesCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['recoveryCodes', 'recoveryWarning']);
  return RegenerateLocalAccountRecoveryCodesCommandOutput(
    recoveryCodes: !json.containsKey('recoveryCodes')
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutput._read_recoveryCodes(
            json['recoveryCodes'],
          ),
    recoveryWarning: !json.containsKey('recoveryWarning')
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutput._read_recoveryWarning(
            json['recoveryWarning'],
          ),
  );
}

Map<String, dynamic> _$RegenerateLocalAccountRecoveryCodesCommandOutputToJson(
  RegenerateLocalAccountRecoveryCodesCommandOutput instance,
) => <String, dynamic>{
  if (instance.recoveryCodes case final $value?)
    'recoveryCodes':
        RegenerateLocalAccountRecoveryCodesCommandOutput._write_recoveryCodes(
          $value,
        ),
  if (instance.recoveryWarning case final $value?)
    'recoveryWarning':
        RegenerateLocalAccountRecoveryCodesCommandOutput._write_recoveryWarning(
          $value,
        ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_local_account_recovery_codes_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateLocalAccountRecoveryCodesCommandOutput
_$RegenerateLocalAccountRecoveryCodesCommandOutputFromJson(
  Map<String, dynamic> json,
) => RegenerateLocalAccountRecoveryCodesCommandOutput(
  recoveryCodes: (json['recoveryCodes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  recoveryWarning: json['recoveryWarning'] as String?,
);

Map<String, dynamic> _$RegenerateLocalAccountRecoveryCodesCommandOutputToJson(
  RegenerateLocalAccountRecoveryCodesCommandOutput instance,
) => <String, dynamic>{
  'recoveryCodes': instance.recoveryCodes,
  'recoveryWarning': instance.recoveryWarning,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_recovery_codes_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateRecoveryCodesThroughApiCommand
_$RegenerateRecoveryCodesThroughApiCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['code', 'recoveryCode']);
  return RegenerateRecoveryCodesThroughApiCommand(
    code: !json.containsKey('code')
        ? null
        : RegenerateRecoveryCodesThroughApiCommand._read_code(json['code']),
    recoveryCode: !json.containsKey('recoveryCode')
        ? null
        : RegenerateRecoveryCodesThroughApiCommand._read_recoveryCode(
            json['recoveryCode'],
          ),
  );
}

Map<String, dynamic> _$RegenerateRecoveryCodesThroughApiCommandToJson(
  RegenerateRecoveryCodesThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.code case final $value?)
    'code': RegenerateRecoveryCodesThroughApiCommand._write_code($value),
  if (instance.recoveryCode case final $value?)
    'recoveryCode':
        RegenerateRecoveryCodesThroughApiCommand._write_recoveryCode($value),
};

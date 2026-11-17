// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_recovery_codes_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateRecoveryCodesThroughApiCommandOutput
_$RegenerateRecoveryCodesThroughApiCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['recoveryCodes']);
  return RegenerateRecoveryCodesThroughApiCommandOutput(
    recoveryCodes: !json.containsKey('recoveryCodes')
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutput._read_recoveryCodes(
            json['recoveryCodes'],
          ),
  );
}

Map<String, dynamic> _$RegenerateRecoveryCodesThroughApiCommandOutputToJson(
  RegenerateRecoveryCodesThroughApiCommandOutput instance,
) => <String, dynamic>{
  if (instance.recoveryCodes case final $value?)
    'recoveryCodes':
        RegenerateRecoveryCodesThroughApiCommandOutput._write_recoveryCodes(
          $value,
        ),
};

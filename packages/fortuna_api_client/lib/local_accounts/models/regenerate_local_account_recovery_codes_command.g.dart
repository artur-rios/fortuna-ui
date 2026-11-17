// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_local_account_recovery_codes_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateLocalAccountRecoveryCodesCommand
_$RegenerateLocalAccountRecoveryCodesCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['secret']);
  return RegenerateLocalAccountRecoveryCodesCommand(
    secret: !json.containsKey('secret')
        ? null
        : RegenerateLocalAccountRecoveryCodesCommand._read_secret(
            json['secret'],
          ),
  );
}

Map<String, dynamic> _$RegenerateLocalAccountRecoveryCodesCommandToJson(
  RegenerateLocalAccountRecoveryCodesCommand instance,
) => <String, dynamic>{
  if (instance.secret case final $value?)
    'secret': RegenerateLocalAccountRecoveryCodesCommand._write_secret($value),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommand _$RecoverLocalAccountCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['name', 'newSecret', 'recoveryCode']);
  return RecoverLocalAccountCommand(
    name: !json.containsKey('name')
        ? null
        : RecoverLocalAccountCommand._read_name(json['name']),
    newSecret: !json.containsKey('newSecret')
        ? null
        : RecoverLocalAccountCommand._read_newSecret(json['newSecret']),
    recoveryCode: !json.containsKey('recoveryCode')
        ? null
        : RecoverLocalAccountCommand._read_recoveryCode(json['recoveryCode']),
  );
}

Map<String, dynamic> _$RecoverLocalAccountCommandToJson(
  RecoverLocalAccountCommand instance,
) => <String, dynamic>{
  if (instance.name case final $value?)
    'name': RecoverLocalAccountCommand._write_name($value),
  if (instance.newSecret case final $value?)
    'newSecret': RecoverLocalAccountCommand._write_newSecret($value),
  if (instance.recoveryCode case final $value?)
    'recoveryCode': RecoverLocalAccountCommand._write_recoveryCode($value),
};

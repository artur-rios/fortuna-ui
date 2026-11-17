// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_local_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLocalAccountCommandOutput _$CreateLocalAccountCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'displayName',
      'id',
      'recoveryCodes',
      'recoveryWarning',
      'storageMode',
      'userId',
    ],
    disallowNullValues: const ['createdAt', 'id', 'storageMode', 'userId'],
  );
  return CreateLocalAccountCommandOutput(
    createdAt: CreateLocalAccountCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    displayName: !json.containsKey('displayName')
        ? null
        : CreateLocalAccountCommandOutput._read_displayName(
            json['displayName'],
          ),
    id: json['id'] as String?,
    recoveryCodes: !json.containsKey('recoveryCodes')
        ? null
        : CreateLocalAccountCommandOutput._read_recoveryCodes(
            json['recoveryCodes'],
          ),
    recoveryWarning: !json.containsKey('recoveryWarning')
        ? null
        : CreateLocalAccountCommandOutput._read_recoveryWarning(
            json['recoveryWarning'],
          ),
    storageMode: CreateLocalAccountCommandOutput._read_storageMode(
      json['storageMode'],
    ),
    userId: json['userId'] as String?,
  );
}

Map<String, dynamic> _$CreateLocalAccountCommandOutputToJson(
  CreateLocalAccountCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?CreateLocalAccountCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.displayName case final $value?)
    'displayName': CreateLocalAccountCommandOutput._write_displayName($value),
  'id': ?instance.id,
  if (instance.recoveryCodes case final $value?)
    'recoveryCodes': CreateLocalAccountCommandOutput._write_recoveryCodes(
      $value,
    ),
  if (instance.recoveryWarning case final $value?)
    'recoveryWarning': CreateLocalAccountCommandOutput._write_recoveryWarning(
      $value,
    ),
  'storageMode': ?CreateLocalAccountCommandOutput._write_storageMode(
    instance.storageMode,
  ),
  'userId': ?instance.userId,
};

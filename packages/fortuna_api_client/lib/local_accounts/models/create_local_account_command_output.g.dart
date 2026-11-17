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
    displayName: json['displayName'] as String?,
    id: json['id'] as String?,
    recoveryCodes: (json['recoveryCodes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    recoveryWarning: json['recoveryWarning'] as String?,
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
  'displayName': ?instance.displayName,
  'id': ?instance.id,
  'recoveryCodes': ?instance.recoveryCodes,
  'recoveryWarning': ?instance.recoveryWarning,
  'storageMode': ?CreateLocalAccountCommandOutput._write_storageMode(
    instance.storageMode,
  ),
  'userId': ?instance.userId,
};

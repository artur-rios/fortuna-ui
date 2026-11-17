// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_local_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLocalAccountCommand _$CreateLocalAccountCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['displayName', 'secret', 'storageMode'],
    disallowNullValues: const ['storageMode'],
  );
  return CreateLocalAccountCommand(
    displayName: !json.containsKey('displayName')
        ? null
        : CreateLocalAccountCommand._read_displayName(json['displayName']),
    secret: !json.containsKey('secret')
        ? null
        : CreateLocalAccountCommand._read_secret(json['secret']),
    storageMode: CreateLocalAccountCommand._read_storageMode(
      json['storageMode'],
    ),
  );
}

Map<String, dynamic> _$CreateLocalAccountCommandToJson(
  CreateLocalAccountCommand instance,
) => <String, dynamic>{
  if (instance.displayName case final $value?)
    'displayName': CreateLocalAccountCommand._write_displayName($value),
  if (instance.secret case final $value?)
    'secret': CreateLocalAccountCommand._write_secret($value),
  'storageMode': ?CreateLocalAccountCommand._write_storageMode(
    instance.storageMode,
  ),
};

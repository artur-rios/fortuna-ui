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
    displayName: json['displayName'] as String?,
    secret: json['secret'] as String?,
    storageMode: CreateLocalAccountCommand._read_storageMode(
      json['storageMode'],
    ),
  );
}

Map<String, dynamic> _$CreateLocalAccountCommandToJson(
  CreateLocalAccountCommand instance,
) => <String, dynamic>{
  'displayName': ?instance.displayName,
  'secret': ?instance.secret,
  'storageMode': ?CreateLocalAccountCommand._write_storageMode(
    instance.storageMode,
  ),
};

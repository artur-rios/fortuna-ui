// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_local_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLocalAccountCommand _$CreateLocalAccountCommandFromJson(
  Map<String, dynamic> json,
) => CreateLocalAccountCommand(
  displayName: json['displayName'] as String?,
  secret: json['secret'] as String?,
  storageMode: json['storageMode'] == null
      ? null
      : LocalAccountStorageMode.fromJson((json['storageMode'] as num).toInt()),
);

Map<String, dynamic> _$CreateLocalAccountCommandToJson(
  CreateLocalAccountCommand instance,
) => <String, dynamic>{
  'displayName': instance.displayName,
  'secret': instance.secret,
  'storageMode': instance.storageMode,
};

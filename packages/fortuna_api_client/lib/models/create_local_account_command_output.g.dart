// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_local_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLocalAccountCommandOutput _$CreateLocalAccountCommandOutputFromJson(
  Map<String, dynamic> json,
) => CreateLocalAccountCommandOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  displayName: json['displayName'] as String?,
  id: json['id'] as String?,
  recoveryCodes: (json['recoveryCodes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  recoveryWarning: json['recoveryWarning'] as String?,
  storageMode: json['storageMode'] == null
      ? null
      : LocalAccountStorageMode.fromJson((json['storageMode'] as num).toInt()),
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$CreateLocalAccountCommandOutputToJson(
  CreateLocalAccountCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'displayName': instance.displayName,
  'id': instance.id,
  'recoveryCodes': instance.recoveryCodes,
  'recoveryWarning': instance.recoveryWarning,
  'storageMode': _$LocalAccountStorageModeEnumMap[instance.storageMode],
  'userId': instance.userId,
};

const _$LocalAccountStorageModeEnumMap = {
  LocalAccountStorageMode.value0: 0,
  LocalAccountStorageMode.value1: 1,
  LocalAccountStorageMode.$unknown: r'$unknown',
};

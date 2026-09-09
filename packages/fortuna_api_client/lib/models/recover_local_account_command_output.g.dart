// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommandOutput _$RecoverLocalAccountCommandOutputFromJson(
  Map<String, dynamic> json,
) => RecoverLocalAccountCommandOutput(
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  remainingRecoveryCodes: (json['remainingRecoveryCodes'] as num?)?.toInt(),
  token: json['token'] as String?,
);

Map<String, dynamic> _$RecoverLocalAccountCommandOutputToJson(
  RecoverLocalAccountCommandOutput instance,
) => <String, dynamic>{
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'remainingRecoveryCodes': instance.remainingRecoveryCodes,
  'token': instance.token,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommand _$RecoverLocalAccountCommandFromJson(
  Map<String, dynamic> json,
) => RecoverLocalAccountCommand(
  name: json['name'] as String?,
  newSecret: json['newSecret'] as String?,
  recoveryCode: json['recoveryCode'] as String?,
);

Map<String, dynamic> _$RecoverLocalAccountCommandToJson(
  RecoverLocalAccountCommand instance,
) => <String, dynamic>{
  'name': instance.name,
  'newSecret': instance.newSecret,
  'recoveryCode': instance.recoveryCode,
};

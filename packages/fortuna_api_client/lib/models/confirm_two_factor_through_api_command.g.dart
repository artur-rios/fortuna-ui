// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmTwoFactorThroughApiCommand _$ConfirmTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) => ConfirmTwoFactorThroughApiCommand(
  appCode: json['appCode'] as String?,
  emailCode: json['emailCode'] as String?,
);

Map<String, dynamic> _$ConfirmTwoFactorThroughApiCommandToJson(
  ConfirmTwoFactorThroughApiCommand instance,
) => <String, dynamic>{
  'appCode': instance.appCode,
  'emailCode': instance.emailCode,
};

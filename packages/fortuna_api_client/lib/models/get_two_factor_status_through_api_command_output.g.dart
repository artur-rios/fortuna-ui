// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_two_factor_status_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTwoFactorStatusThroughApiCommandOutput
_$GetTwoFactorStatusThroughApiCommandOutputFromJson(
  Map<String, dynamic> json,
) => GetTwoFactorStatusThroughApiCommandOutput(
  appEnabled: json['appEnabled'] as bool?,
  emailEnabled: json['emailEnabled'] as bool?,
  isActive: json['isActive'] as bool?,
  remainingRecoveryCodes: (json['remainingRecoveryCodes'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetTwoFactorStatusThroughApiCommandOutputToJson(
  GetTwoFactorStatusThroughApiCommandOutput instance,
) => <String, dynamic>{
  'appEnabled': instance.appEnabled,
  'emailEnabled': instance.emailEnabled,
  'isActive': instance.isActive,
  'remainingRecoveryCodes': instance.remainingRecoveryCodes,
};

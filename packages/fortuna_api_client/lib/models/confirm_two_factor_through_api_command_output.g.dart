// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_two_factor_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmTwoFactorThroughApiCommandOutput
_$ConfirmTwoFactorThroughApiCommandOutputFromJson(Map<String, dynamic> json) =>
    ConfirmTwoFactorThroughApiCommandOutput(
      enabled: json['enabled'] as bool?,
      recoveryCodes: (json['recoveryCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ConfirmTwoFactorThroughApiCommandOutputToJson(
  ConfirmTwoFactorThroughApiCommandOutput instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'recoveryCodes': instance.recoveryCodes,
};

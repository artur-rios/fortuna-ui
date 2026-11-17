// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_two_factor_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmTwoFactorThroughApiCommandOutput
_$ConfirmTwoFactorThroughApiCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['enabled', 'recoveryCodes'],
    disallowNullValues: const ['enabled'],
  );
  return ConfirmTwoFactorThroughApiCommandOutput(
    enabled: json['enabled'] as bool?,
    recoveryCodes: !json.containsKey('recoveryCodes')
        ? null
        : ConfirmTwoFactorThroughApiCommandOutput._read_recoveryCodes(
            json['recoveryCodes'],
          ),
  );
}

Map<String, dynamic> _$ConfirmTwoFactorThroughApiCommandOutputToJson(
  ConfirmTwoFactorThroughApiCommandOutput instance,
) => <String, dynamic>{
  'enabled': ?instance.enabled,
  if (instance.recoveryCodes case final $value?)
    'recoveryCodes':
        ConfirmTwoFactorThroughApiCommandOutput._write_recoveryCodes($value),
};

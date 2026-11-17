// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_two_factor_status_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTwoFactorStatusThroughApiCommandOutput
_$GetTwoFactorStatusThroughApiCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appEnabled',
      'emailEnabled',
      'isActive',
      'remainingRecoveryCodes',
    ],
    disallowNullValues: const [
      'appEnabled',
      'emailEnabled',
      'isActive',
      'remainingRecoveryCodes',
    ],
  );
  return GetTwoFactorStatusThroughApiCommandOutput(
    appEnabled: json['appEnabled'] as bool?,
    emailEnabled: json['emailEnabled'] as bool?,
    isActive: json['isActive'] as bool?,
    remainingRecoveryCodes:
        GetTwoFactorStatusThroughApiCommandOutput._read_remainingRecoveryCodes(
          json['remainingRecoveryCodes'],
        ),
  );
}

Map<String, dynamic> _$GetTwoFactorStatusThroughApiCommandOutputToJson(
  GetTwoFactorStatusThroughApiCommandOutput instance,
) => <String, dynamic>{
  'appEnabled': ?instance.appEnabled,
  'emailEnabled': ?instance.emailEnabled,
  'isActive': ?instance.isActive,
  'remainingRecoveryCodes':
      ?GetTwoFactorStatusThroughApiCommandOutput._write_remainingRecoveryCodes(
        instance.remainingRecoveryCodes,
      ),
};

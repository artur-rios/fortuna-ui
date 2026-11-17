// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommandOutput _$RecoverLocalAccountCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['expiresAt', 'remainingRecoveryCodes', 'token'],
    disallowNullValues: const ['expiresAt', 'remainingRecoveryCodes'],
  );
  return RecoverLocalAccountCommandOutput(
    expiresAt: RecoverLocalAccountCommandOutput._read_expiresAt(
      json['expiresAt'],
    ),
    remainingRecoveryCodes:
        RecoverLocalAccountCommandOutput._read_remainingRecoveryCodes(
          json['remainingRecoveryCodes'],
        ),
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$RecoverLocalAccountCommandOutputToJson(
  RecoverLocalAccountCommandOutput instance,
) => <String, dynamic>{
  'expiresAt': ?RecoverLocalAccountCommandOutput._write_expiresAt(
    instance.expiresAt,
  ),
  'remainingRecoveryCodes':
      ?RecoverLocalAccountCommandOutput._write_remainingRecoveryCodes(
        instance.remainingRecoveryCodes,
      ),
  'token': ?instance.token,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_password_recovery_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPasswordRecoveryThroughApiCommand
_$RequestPasswordRecoveryThroughApiCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['email']);
  return RequestPasswordRecoveryThroughApiCommand(
    email: !json.containsKey('email')
        ? null
        : RequestPasswordRecoveryThroughApiCommand._read_email(json['email']),
  );
}

Map<String, dynamic> _$RequestPasswordRecoveryThroughApiCommandToJson(
  RequestPasswordRecoveryThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.email case final $value?)
    'email': RequestPasswordRecoveryThroughApiCommand._write_email($value),
};

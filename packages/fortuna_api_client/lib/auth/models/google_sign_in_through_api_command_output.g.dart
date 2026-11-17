// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInThroughApiCommandOutput
_$GoogleSignInThroughApiCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['emailVerified', 'expiresAt', 'token'],
    disallowNullValues: const ['emailVerified', 'expiresAt'],
  );
  return GoogleSignInThroughApiCommandOutput(
    emailVerified: json['emailVerified'] as bool?,
    expiresAt: GoogleSignInThroughApiCommandOutput._read_expiresAt(
      json['expiresAt'],
    ),
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$GoogleSignInThroughApiCommandOutputToJson(
  GoogleSignInThroughApiCommandOutput instance,
) => <String, dynamic>{
  'emailVerified': ?instance.emailVerified,
  'expiresAt': ?GoogleSignInThroughApiCommandOutput._write_expiresAt(
    instance.expiresAt,
  ),
  'token': ?instance.token,
};

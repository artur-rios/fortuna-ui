// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginThroughApiCommandOutput _$LoginThroughApiCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'availableMethods',
      'challengeToken',
      'emailVerified',
      'expiresAt',
      'requiresTwoFactor',
      'token',
    ],
    disallowNullValues: const ['requiresTwoFactor'],
  );
  return LoginThroughApiCommandOutput(
    availableMethods: !json.containsKey('availableMethods')
        ? null
        : LoginThroughApiCommandOutput._read_availableMethods(
            json['availableMethods'],
          ),
    challengeToken: !json.containsKey('challengeToken')
        ? null
        : LoginThroughApiCommandOutput._read_challengeToken(
            json['challengeToken'],
          ),
    emailVerified: !json.containsKey('emailVerified')
        ? null
        : LoginThroughApiCommandOutput._read_emailVerified(
            json['emailVerified'],
          ),
    expiresAt: !json.containsKey('expiresAt')
        ? null
        : LoginThroughApiCommandOutput._read_expiresAt(json['expiresAt']),
    requiresTwoFactor: json['requiresTwoFactor'] as bool?,
    token: !json.containsKey('token')
        ? null
        : LoginThroughApiCommandOutput._read_token(json['token']),
  );
}

Map<String, dynamic> _$LoginThroughApiCommandOutputToJson(
  LoginThroughApiCommandOutput instance,
) => <String, dynamic>{
  if (instance.availableMethods case final $value?)
    'availableMethods': LoginThroughApiCommandOutput._write_availableMethods(
      $value,
    ),
  if (instance.challengeToken case final $value?)
    'challengeToken': LoginThroughApiCommandOutput._write_challengeToken(
      $value,
    ),
  if (instance.emailVerified case final $value?)
    'emailVerified': LoginThroughApiCommandOutput._write_emailVerified($value),
  if (instance.expiresAt case final $value?)
    'expiresAt': LoginThroughApiCommandOutput._write_expiresAt($value),
  'requiresTwoFactor': ?instance.requiresTwoFactor,
  if (instance.token case final $value?)
    'token': LoginThroughApiCommandOutput._write_token($value),
};

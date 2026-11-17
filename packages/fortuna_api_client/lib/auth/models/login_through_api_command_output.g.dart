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
    availableMethods: (json['availableMethods'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    challengeToken: json['challengeToken'] as String?,
    emailVerified: json['emailVerified'] as bool?,
    expiresAt: LoginThroughApiCommandOutput._read_expiresAt(json['expiresAt']),
    requiresTwoFactor: json['requiresTwoFactor'] as bool?,
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$LoginThroughApiCommandOutputToJson(
  LoginThroughApiCommandOutput instance,
) => <String, dynamic>{
  'availableMethods': ?instance.availableMethods,
  'challengeToken': ?instance.challengeToken,
  'emailVerified': ?instance.emailVerified,
  'expiresAt': ?LoginThroughApiCommandOutput._write_expiresAt(
    instance.expiresAt,
  ),
  'requiresTwoFactor': ?instance.requiresTwoFactor,
  'token': ?instance.token,
};

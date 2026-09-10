// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginThroughApiCommandOutput _$LoginThroughApiCommandOutputFromJson(
  Map<String, dynamic> json,
) => LoginThroughApiCommandOutput(
  availableMethods: (json['availableMethods'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  challengeToken: json['challengeToken'] as String?,
  emailVerified: json['emailVerified'] as bool?,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  requiresTwoFactor: json['requiresTwoFactor'] as bool?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$LoginThroughApiCommandOutputToJson(
  LoginThroughApiCommandOutput instance,
) => <String, dynamic>{
  'availableMethods': instance.availableMethods,
  'challengeToken': instance.challengeToken,
  'emailVerified': instance.emailVerified,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'requiresTwoFactor': instance.requiresTwoFactor,
  'token': instance.token,
};

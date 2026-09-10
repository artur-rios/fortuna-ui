// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInThroughApiCommandOutput
_$GoogleSignInThroughApiCommandOutputFromJson(Map<String, dynamic> json) =>
    GoogleSignInThroughApiCommandOutput(
      emailVerified: json['emailVerified'] as bool?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$GoogleSignInThroughApiCommandOutputToJson(
  GoogleSignInThroughApiCommandOutput instance,
) => <String, dynamic>{
  'emailVerified': instance.emailVerified,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'token': instance.token,
};

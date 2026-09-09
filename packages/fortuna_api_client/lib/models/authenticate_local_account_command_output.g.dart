// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_local_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateLocalAccountCommandOutput
_$AuthenticateLocalAccountCommandOutputFromJson(Map<String, dynamic> json) =>
    AuthenticateLocalAccountCommandOutput(
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$AuthenticateLocalAccountCommandOutputToJson(
  AuthenticateLocalAccountCommandOutput instance,
) => <String, dynamic>{
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'token': instance.token,
};

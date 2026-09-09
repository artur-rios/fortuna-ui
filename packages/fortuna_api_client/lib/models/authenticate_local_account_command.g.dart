// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_local_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateLocalAccountCommand _$AuthenticateLocalAccountCommandFromJson(
  Map<String, dynamic> json,
) => AuthenticateLocalAccountCommand(
  name: json['name'] as String?,
  secret: json['secret'] as String?,
);

Map<String, dynamic> _$AuthenticateLocalAccountCommandToJson(
  AuthenticateLocalAccountCommand instance,
) => <String, dynamic>{'name': instance.name, 'secret': instance.secret};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterThroughApiCommand _$RegisterThroughApiCommandFromJson(
  Map<String, dynamic> json,
) => RegisterThroughApiCommand(
  email: json['email'] as String?,
  name: json['name'] as String?,
  password: json['password'] as String?,
);

Map<String, dynamic> _$RegisterThroughApiCommandToJson(
  RegisterThroughApiCommand instance,
) => <String, dynamic>{
  'email': instance.email,
  'name': instance.name,
  'password': instance.password,
};

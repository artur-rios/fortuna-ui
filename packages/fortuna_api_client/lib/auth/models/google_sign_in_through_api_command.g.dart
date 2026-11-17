// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInThroughApiCommand _$GoogleSignInThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['idToken']);
  return GoogleSignInThroughApiCommand(
    idToken: !json.containsKey('idToken')
        ? null
        : GoogleSignInThroughApiCommand._read_idToken(json['idToken']),
  );
}

Map<String, dynamic> _$GoogleSignInThroughApiCommandToJson(
  GoogleSignInThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.idToken case final $value?)
    'idToken': GoogleSignInThroughApiCommand._write_idToken($value),
};

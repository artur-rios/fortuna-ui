// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauthenticate_connection_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReauthenticateConnectionCommand _$ReauthenticateConnectionCommandFromJson(
  Map<String, dynamic> json,
) => ReauthenticateConnectionCommand(
  externalReference: !json.containsKey('externalReference')
      ? null
      : ReauthenticateConnectionCommand._read_externalReference(
          json['externalReference'],
        ),
  additionalProperties:
      ReauthenticateConnectionCommand._extras(json, 'additionalProperties') ==
          null
      ? const {}
      : ReauthenticateConnectionCommand._readExtras(
          ReauthenticateConnectionCommand._extras(json, 'additionalProperties'),
        ),
);

Map<String, dynamic> _$ReauthenticateConnectionCommandToJson(
  ReauthenticateConnectionCommand instance,
) => <String, dynamic>{
  if (instance.externalReference case final $value?)
    'externalReference':
        ReauthenticateConnectionCommand._write_externalReference($value),
};

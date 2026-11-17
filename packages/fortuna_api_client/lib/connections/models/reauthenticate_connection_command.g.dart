// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauthenticate_connection_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReauthenticateConnectionCommand _$ReauthenticateConnectionCommandFromJson(
  Map<String, dynamic> json,
) => ReauthenticateConnectionCommand(
  externalReference: json['externalReference'] as String?,
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
) => <String, dynamic>{'externalReference': ?instance.externalReference};

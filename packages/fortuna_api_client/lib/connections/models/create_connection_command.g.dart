// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_connection_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConnectionCommand _$CreateConnectionCommandFromJson(
  Map<String, dynamic> json,
) => CreateConnectionCommand(
  dataSource: json['dataSource'] as String?,
  externalReference: json['externalReference'] as String?,
  additionalProperties:
      CreateConnectionCommand._extras(json, 'additionalProperties') == null
      ? const {}
      : CreateConnectionCommand._readExtras(
          CreateConnectionCommand._extras(json, 'additionalProperties'),
        ),
);

Map<String, dynamic> _$CreateConnectionCommandToJson(
  CreateConnectionCommand instance,
) => <String, dynamic>{
  'dataSource': ?instance.dataSource,
  'externalReference': ?instance.externalReference,
};

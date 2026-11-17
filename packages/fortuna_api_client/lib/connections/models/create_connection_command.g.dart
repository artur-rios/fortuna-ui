// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_connection_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConnectionCommand _$CreateConnectionCommandFromJson(
  Map<String, dynamic> json,
) => CreateConnectionCommand(
  dataSource: !json.containsKey('dataSource')
      ? null
      : CreateConnectionCommand._read_dataSource(json['dataSource']),
  externalReference: !json.containsKey('externalReference')
      ? null
      : CreateConnectionCommand._read_externalReference(
          json['externalReference'],
        ),
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
  if (instance.dataSource case final $value?)
    'dataSource': CreateConnectionCommand._write_dataSource($value),
  if (instance.externalReference case final $value?)
    'externalReference': CreateConnectionCommand._write_externalReference(
      $value,
    ),
};

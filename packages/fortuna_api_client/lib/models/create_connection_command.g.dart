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
);

Map<String, dynamic> _$CreateConnectionCommandToJson(
  CreateConnectionCommand instance,
) => <String, dynamic>{
  'dataSource': instance.dataSource,
  'externalReference': instance.externalReference,
};

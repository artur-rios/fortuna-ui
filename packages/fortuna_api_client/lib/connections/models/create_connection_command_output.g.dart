// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConnectionCommandOutput _$CreateConnectionCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'dataSourceType',
      'externalReference',
      'id',
      'institution',
      'status',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'dataSourceType',
      'id',
      'status',
      'updatedAt',
    ],
  );
  return CreateConnectionCommandOutput(
    createdAt: CreateConnectionCommandOutput._read_createdAt(json['createdAt']),
    dataSourceType: CreateConnectionCommandOutput._read_dataSourceType(
      json['dataSourceType'],
    ),
    externalReference: json['externalReference'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    status: CreateConnectionCommandOutput._read_status(json['status']),
    updatedAt: CreateConnectionCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$CreateConnectionCommandOutputToJson(
  CreateConnectionCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?CreateConnectionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'dataSourceType': ?CreateConnectionCommandOutput._write_dataSourceType(
    instance.dataSourceType,
  ),
  'externalReference': ?instance.externalReference,
  'id': ?instance.id,
  'institution': ?instance.institution,
  'status': ?CreateConnectionCommandOutput._write_status(instance.status),
  'updatedAt': ?CreateConnectionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

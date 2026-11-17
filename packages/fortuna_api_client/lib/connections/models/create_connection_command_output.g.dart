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
    externalReference: !json.containsKey('externalReference')
        ? null
        : CreateConnectionCommandOutput._read_externalReference(
            json['externalReference'],
          ),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : CreateConnectionCommandOutput._read_institution(json['institution']),
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
  if (instance.externalReference case final $value?)
    'externalReference': CreateConnectionCommandOutput._write_externalReference(
      $value,
    ),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': CreateConnectionCommandOutput._write_institution($value),
  'status': ?CreateConnectionCommandOutput._write_status(instance.status),
  'updatedAt': ?CreateConnectionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

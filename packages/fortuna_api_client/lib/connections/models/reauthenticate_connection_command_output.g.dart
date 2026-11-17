// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauthenticate_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReauthenticateConnectionCommandOutput
_$ReauthenticateConnectionCommandOutputFromJson(Map<String, dynamic> json) {
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
  return ReauthenticateConnectionCommandOutput(
    createdAt: ReauthenticateConnectionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    dataSourceType: ReauthenticateConnectionCommandOutput._read_dataSourceType(
      json['dataSourceType'],
    ),
    externalReference: json['externalReference'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    status: ReauthenticateConnectionCommandOutput._read_status(json['status']),
    updatedAt: ReauthenticateConnectionCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$ReauthenticateConnectionCommandOutputToJson(
  ReauthenticateConnectionCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?ReauthenticateConnectionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'dataSourceType':
      ?ReauthenticateConnectionCommandOutput._write_dataSourceType(
        instance.dataSourceType,
      ),
  'externalReference': ?instance.externalReference,
  'id': ?instance.id,
  'institution': ?instance.institution,
  'status': ?ReauthenticateConnectionCommandOutput._write_status(
    instance.status,
  ),
  'updatedAt': ?ReauthenticateConnectionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

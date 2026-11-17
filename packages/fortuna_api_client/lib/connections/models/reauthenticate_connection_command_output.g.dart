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
    externalReference: !json.containsKey('externalReference')
        ? null
        : ReauthenticateConnectionCommandOutput._read_externalReference(
            json['externalReference'],
          ),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : ReauthenticateConnectionCommandOutput._read_institution(
            json['institution'],
          ),
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
  if (instance.externalReference case final $value?)
    'externalReference':
        ReauthenticateConnectionCommandOutput._write_externalReference($value),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': ReauthenticateConnectionCommandOutput._write_institution(
      $value,
    ),
  'status': ?ReauthenticateConnectionCommandOutput._write_status(
    instance.status,
  ),
  'updatedAt': ?ReauthenticateConnectionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

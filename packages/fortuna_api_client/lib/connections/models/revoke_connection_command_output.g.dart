// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoke_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevokeConnectionCommandOutput _$RevokeConnectionCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'dataSourceType',
      'externalReference',
      'id',
      'importedDataRetained',
      'status',
      'stoppedSynchronizations',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'dataSourceType',
      'id',
      'importedDataRetained',
      'status',
      'stoppedSynchronizations',
      'updatedAt',
    ],
  );
  return RevokeConnectionCommandOutput(
    createdAt: RevokeConnectionCommandOutput._read_createdAt(json['createdAt']),
    dataSourceType: RevokeConnectionCommandOutput._read_dataSourceType(
      json['dataSourceType'],
    ),
    externalReference: json['externalReference'] as String?,
    id: json['id'] as String?,
    importedDataRetained: json['importedDataRetained'] as bool?,
    status: RevokeConnectionCommandOutput._read_status(json['status']),
    stoppedSynchronizations:
        RevokeConnectionCommandOutput._read_stoppedSynchronizations(
          json['stoppedSynchronizations'],
        ),
    updatedAt: RevokeConnectionCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$RevokeConnectionCommandOutputToJson(
  RevokeConnectionCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?RevokeConnectionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'dataSourceType': ?RevokeConnectionCommandOutput._write_dataSourceType(
    instance.dataSourceType,
  ),
  'externalReference': ?instance.externalReference,
  'id': ?instance.id,
  'importedDataRetained': ?instance.importedDataRetained,
  'status': ?RevokeConnectionCommandOutput._write_status(instance.status),
  'stoppedSynchronizations':
      ?RevokeConnectionCommandOutput._write_stoppedSynchronizations(
        instance.stoppedSynchronizations,
      ),
  'updatedAt': ?RevokeConnectionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

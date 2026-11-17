// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionOutput _$ConnectionOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'dataSourceType',
      'externalReference',
      'id',
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
  return ConnectionOutput(
    createdAt: ConnectionOutput._read_createdAt(json['createdAt']),
    dataSourceType: ConnectionOutput._read_dataSourceType(
      json['dataSourceType'],
    ),
    externalReference: json['externalReference'] as String?,
    id: json['id'] as String?,
    status: ConnectionOutput._read_status(json['status']),
    updatedAt: ConnectionOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$ConnectionOutputToJson(ConnectionOutput instance) =>
    <String, dynamic>{
      'createdAt': ?ConnectionOutput._write_createdAt(instance.createdAt),
      'dataSourceType': ?ConnectionOutput._write_dataSourceType(
        instance.dataSourceType,
      ),
      'externalReference': ?instance.externalReference,
      'id': ?instance.id,
      'status': ?ConnectionOutput._write_status(instance.status),
      'updatedAt': ?ConnectionOutput._write_updatedAt(instance.updatedAt),
    };

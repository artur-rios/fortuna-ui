// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_data_export_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveDataExportQueryOutput _$RetrieveDataExportQueryOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'contentType',
      'createdAt',
      'expiresAt',
      'failureReason',
      'fileName',
      'format',
      'id',
      'jobId',
      'rowCount',
      'status',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'expiresAt',
      'format',
      'id',
      'status',
      'updatedAt',
    ],
  );
  return RetrieveDataExportQueryOutput(
    contentType: json['contentType'] as String?,
    createdAt: RetrieveDataExportQueryOutput._read_createdAt(json['createdAt']),
    expiresAt: RetrieveDataExportQueryOutput._read_expiresAt(json['expiresAt']),
    failureReason: json['failureReason'] as String?,
    fileName: json['fileName'] as String?,
    format: RetrieveDataExportQueryOutput._read_format(json['format']),
    id: json['id'] as String?,
    jobId: json['jobId'] as String?,
    rowCount: RetrieveDataExportQueryOutput._read_rowCount(json['rowCount']),
    status: RetrieveDataExportQueryOutput._read_status(json['status']),
    updatedAt: RetrieveDataExportQueryOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$RetrieveDataExportQueryOutputToJson(
  RetrieveDataExportQueryOutput instance,
) => <String, dynamic>{
  'contentType': ?instance.contentType,
  'createdAt': ?RetrieveDataExportQueryOutput._write_createdAt(
    instance.createdAt,
  ),
  'expiresAt': ?RetrieveDataExportQueryOutput._write_expiresAt(
    instance.expiresAt,
  ),
  'failureReason': ?instance.failureReason,
  'fileName': ?instance.fileName,
  'format': ?RetrieveDataExportQueryOutput._write_format(instance.format),
  'id': ?instance.id,
  'jobId': ?instance.jobId,
  'rowCount': ?RetrieveDataExportQueryOutput._write_rowCount(instance.rowCount),
  'status': ?RetrieveDataExportQueryOutput._write_status(instance.status),
  'updatedAt': ?RetrieveDataExportQueryOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

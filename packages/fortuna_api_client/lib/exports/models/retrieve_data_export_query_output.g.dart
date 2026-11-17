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
    contentType: !json.containsKey('contentType')
        ? null
        : RetrieveDataExportQueryOutput._read_contentType(json['contentType']),
    createdAt: RetrieveDataExportQueryOutput._read_createdAt(json['createdAt']),
    expiresAt: RetrieveDataExportQueryOutput._read_expiresAt(json['expiresAt']),
    failureReason: !json.containsKey('failureReason')
        ? null
        : RetrieveDataExportQueryOutput._read_failureReason(
            json['failureReason'],
          ),
    fileName: !json.containsKey('fileName')
        ? null
        : RetrieveDataExportQueryOutput._read_fileName(json['fileName']),
    format: RetrieveDataExportQueryOutput._read_format(json['format']),
    id: json['id'] as String?,
    jobId: !json.containsKey('jobId')
        ? null
        : RetrieveDataExportQueryOutput._read_jobId(json['jobId']),
    rowCount: !json.containsKey('rowCount')
        ? null
        : RetrieveDataExportQueryOutput._read_rowCount(json['rowCount']),
    status: RetrieveDataExportQueryOutput._read_status(json['status']),
    updatedAt: RetrieveDataExportQueryOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$RetrieveDataExportQueryOutputToJson(
  RetrieveDataExportQueryOutput instance,
) => <String, dynamic>{
  if (instance.contentType case final $value?)
    'contentType': RetrieveDataExportQueryOutput._write_contentType($value),
  'createdAt': ?RetrieveDataExportQueryOutput._write_createdAt(
    instance.createdAt,
  ),
  'expiresAt': ?RetrieveDataExportQueryOutput._write_expiresAt(
    instance.expiresAt,
  ),
  if (instance.failureReason case final $value?)
    'failureReason': RetrieveDataExportQueryOutput._write_failureReason($value),
  if (instance.fileName case final $value?)
    'fileName': RetrieveDataExportQueryOutput._write_fileName($value),
  'format': ?RetrieveDataExportQueryOutput._write_format(instance.format),
  'id': ?instance.id,
  if (instance.jobId case final $value?)
    'jobId': RetrieveDataExportQueryOutput._write_jobId($value),
  if (instance.rowCount case final $value?)
    'rowCount': RetrieveDataExportQueryOutput._write_rowCount($value),
  'status': ?RetrieveDataExportQueryOutput._write_status(instance.status),
  'updatedAt': ?RetrieveDataExportQueryOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

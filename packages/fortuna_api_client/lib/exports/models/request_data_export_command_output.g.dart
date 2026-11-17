// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_data_export_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDataExportCommandOutput _$RequestDataExportCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'contentType',
      'delivery',
      'exportId',
      'fileName',
      'format',
      'jobId',
      'rowCount',
    ],
    disallowNullValues: const ['delivery', 'format', 'rowCount'],
  );
  return RequestDataExportCommandOutput(
    contentType: !json.containsKey('contentType')
        ? null
        : RequestDataExportCommandOutput._read_contentType(json['contentType']),
    delivery: RequestDataExportCommandOutput._read_delivery(json['delivery']),
    exportId: !json.containsKey('exportId')
        ? null
        : RequestDataExportCommandOutput._read_exportId(json['exportId']),
    fileName: !json.containsKey('fileName')
        ? null
        : RequestDataExportCommandOutput._read_fileName(json['fileName']),
    format: RequestDataExportCommandOutput._read_format(json['format']),
    jobId: !json.containsKey('jobId')
        ? null
        : RequestDataExportCommandOutput._read_jobId(json['jobId']),
    rowCount: RequestDataExportCommandOutput._read_rowCount(json['rowCount']),
  );
}

Map<String, dynamic> _$RequestDataExportCommandOutputToJson(
  RequestDataExportCommandOutput instance,
) => <String, dynamic>{
  if (instance.contentType case final $value?)
    'contentType': RequestDataExportCommandOutput._write_contentType($value),
  'delivery': ?RequestDataExportCommandOutput._write_delivery(
    instance.delivery,
  ),
  if (instance.exportId case final $value?)
    'exportId': RequestDataExportCommandOutput._write_exportId($value),
  if (instance.fileName case final $value?)
    'fileName': RequestDataExportCommandOutput._write_fileName($value),
  'format': ?RequestDataExportCommandOutput._write_format(instance.format),
  if (instance.jobId case final $value?)
    'jobId': RequestDataExportCommandOutput._write_jobId($value),
  'rowCount': ?RequestDataExportCommandOutput._write_rowCount(
    instance.rowCount,
  ),
};

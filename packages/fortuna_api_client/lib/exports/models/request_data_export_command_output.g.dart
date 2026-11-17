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
    contentType: json['contentType'] as String?,
    delivery: RequestDataExportCommandOutput._read_delivery(json['delivery']),
    exportId: json['exportId'] as String?,
    fileName: json['fileName'] as String?,
    format: RequestDataExportCommandOutput._read_format(json['format']),
    jobId: json['jobId'] as String?,
    rowCount: RequestDataExportCommandOutput._read_rowCount(json['rowCount']),
  );
}

Map<String, dynamic> _$RequestDataExportCommandOutputToJson(
  RequestDataExportCommandOutput instance,
) => <String, dynamic>{
  'contentType': ?instance.contentType,
  'delivery': ?RequestDataExportCommandOutput._write_delivery(
    instance.delivery,
  ),
  'exportId': ?instance.exportId,
  'fileName': ?instance.fileName,
  'format': ?RequestDataExportCommandOutput._write_format(instance.format),
  'jobId': ?instance.jobId,
  'rowCount': ?RequestDataExportCommandOutput._write_rowCount(
    instance.rowCount,
  ),
};

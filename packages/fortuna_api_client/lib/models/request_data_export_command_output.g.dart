// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_data_export_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDataExportCommandOutput _$RequestDataExportCommandOutputFromJson(
  Map<String, dynamic> json,
) => RequestDataExportCommandOutput(
  contentType: json['contentType'] as String?,
  delivery: json['delivery'] == null
      ? null
      : DataExportDelivery.fromJson((json['delivery'] as num).toInt()),
  exportId: json['exportId'] as String?,
  fileName: json['fileName'] as String?,
  format: json['format'] == null
      ? null
      : DataExportFormat.fromJson((json['format'] as num).toInt()),
  jobId: json['jobId'] as String?,
  rowCount: (json['rowCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$RequestDataExportCommandOutputToJson(
  RequestDataExportCommandOutput instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'delivery': instance.delivery,
  'exportId': instance.exportId,
  'fileName': instance.fileName,
  'format': instance.format,
  'jobId': instance.jobId,
  'rowCount': instance.rowCount,
};

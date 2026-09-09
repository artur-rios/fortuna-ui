// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_data_export_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveDataExportQueryOutput _$RetrieveDataExportQueryOutputFromJson(
  Map<String, dynamic> json,
) => RetrieveDataExportQueryOutput(
  contentType: json['contentType'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  failureReason: json['failureReason'] as String?,
  fileName: json['fileName'] as String?,
  format: json['format'] == null
      ? null
      : DataExportFormat.fromJson((json['format'] as num).toInt()),
  id: json['id'] as String?,
  jobId: json['jobId'] as String?,
  rowCount: (json['rowCount'] as num?)?.toInt(),
  status: json['status'] == null
      ? null
      : DataExportStatus.fromJson((json['status'] as num).toInt()),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RetrieveDataExportQueryOutputToJson(
  RetrieveDataExportQueryOutput instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'createdAt': instance.createdAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'failureReason': instance.failureReason,
  'fileName': instance.fileName,
  'format': instance.format,
  'id': instance.id,
  'jobId': instance.jobId,
  'rowCount': instance.rowCount,
  'status': instance.status,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

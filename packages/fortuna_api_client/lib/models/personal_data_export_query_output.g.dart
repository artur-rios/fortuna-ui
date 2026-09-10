// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_export_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDataExportQueryOutput _$PersonalDataExportQueryOutputFromJson(
  Map<String, dynamic> json,
) => PersonalDataExportQueryOutput(
  contentType: json['contentType'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  failureReason: json['failureReason'] as String?,
  fileName: json['fileName'] as String?,
  jobId: json['jobId'] as String?,
  progress: (json['progress'] as num?)?.toInt(),
  status: json['status'] == null
      ? null
      : DataExportStatus.fromJson((json['status'] as num).toInt()),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PersonalDataExportQueryOutputToJson(
  PersonalDataExportQueryOutput instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'createdAt': instance.createdAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'failureReason': instance.failureReason,
  'fileName': instance.fileName,
  'jobId': instance.jobId,
  'progress': instance.progress,
  'status': _$DataExportStatusEnumMap[instance.status],
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$DataExportStatusEnumMap = {
  DataExportStatus.value1: 1,
  DataExportStatus.value2: 2,
  DataExportStatus.value3: 3,
  DataExportStatus.value4: 4,
  DataExportStatus.$unknown: r'$unknown',
};

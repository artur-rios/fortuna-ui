// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_personal_data_export_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPersonalDataExportCommandOutput
_$RequestPersonalDataExportCommandOutputFromJson(Map<String, dynamic> json) =>
    RequestPersonalDataExportCommandOutput(
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      jobId: json['jobId'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
      status: json['status'] == null
          ? null
          : DataExportStatus.fromJson((json['status'] as num).toInt()),
    );

Map<String, dynamic> _$RequestPersonalDataExportCommandOutputToJson(
  RequestPersonalDataExportCommandOutput instance,
) => <String, dynamic>{
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'jobId': instance.jobId,
  'progress': instance.progress,
  'status': _$DataExportStatusEnumMap[instance.status],
};

const _$DataExportStatusEnumMap = {
  DataExportStatus.value1: 1,
  DataExportStatus.value2: 2,
  DataExportStatus.value3: 3,
  DataExportStatus.value4: 4,
  DataExportStatus.$unknown: r'$unknown',
};

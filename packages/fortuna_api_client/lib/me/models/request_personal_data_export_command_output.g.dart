// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_personal_data_export_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPersonalDataExportCommandOutput
_$RequestPersonalDataExportCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['expiresAt', 'jobId', 'progress', 'status'],
    disallowNullValues: const ['expiresAt', 'jobId', 'progress', 'status'],
  );
  return RequestPersonalDataExportCommandOutput(
    expiresAt: RequestPersonalDataExportCommandOutput._read_expiresAt(
      json['expiresAt'],
    ),
    jobId: json['jobId'] as String?,
    progress: RequestPersonalDataExportCommandOutput._read_progress(
      json['progress'],
    ),
    status: RequestPersonalDataExportCommandOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$RequestPersonalDataExportCommandOutputToJson(
  RequestPersonalDataExportCommandOutput instance,
) => <String, dynamic>{
  'expiresAt': ?RequestPersonalDataExportCommandOutput._write_expiresAt(
    instance.expiresAt,
  ),
  'jobId': ?instance.jobId,
  'progress': ?RequestPersonalDataExportCommandOutput._write_progress(
    instance.progress,
  ),
  'status': ?RequestPersonalDataExportCommandOutput._write_status(
    instance.status,
  ),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_export_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDataExportQueryOutput _$PersonalDataExportQueryOutputFromJson(
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
      'jobId',
      'progress',
      'status',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'expiresAt',
      'jobId',
      'progress',
      'status',
      'updatedAt',
    ],
  );
  return PersonalDataExportQueryOutput(
    contentType: json['contentType'] as String?,
    createdAt: PersonalDataExportQueryOutput._read_createdAt(json['createdAt']),
    expiresAt: PersonalDataExportQueryOutput._read_expiresAt(json['expiresAt']),
    failureReason: json['failureReason'] as String?,
    fileName: json['fileName'] as String?,
    jobId: json['jobId'] as String?,
    progress: PersonalDataExportQueryOutput._read_progress(json['progress']),
    status: PersonalDataExportQueryOutput._read_status(json['status']),
    updatedAt: PersonalDataExportQueryOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$PersonalDataExportQueryOutputToJson(
  PersonalDataExportQueryOutput instance,
) => <String, dynamic>{
  'contentType': ?instance.contentType,
  'createdAt': ?PersonalDataExportQueryOutput._write_createdAt(
    instance.createdAt,
  ),
  'expiresAt': ?PersonalDataExportQueryOutput._write_expiresAt(
    instance.expiresAt,
  ),
  'failureReason': ?instance.failureReason,
  'fileName': ?instance.fileName,
  'jobId': ?instance.jobId,
  'progress': ?PersonalDataExportQueryOutput._write_progress(instance.progress),
  'status': ?PersonalDataExportQueryOutput._write_status(instance.status),
  'updatedAt': ?PersonalDataExportQueryOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

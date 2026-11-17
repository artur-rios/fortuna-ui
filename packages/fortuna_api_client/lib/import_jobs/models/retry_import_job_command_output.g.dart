// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry_import_job_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetryImportJobCommandOutput _$RetryImportJobCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'duplicateCount',
      'id',
      'importedCount',
      'periodEnd',
      'periodStart',
      'rejectedCount',
      'sourceType',
      'status',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'duplicateCount',
      'id',
      'importedCount',
      'rejectedCount',
      'sourceType',
      'status',
      'updatedAt',
    ],
  );
  return RetryImportJobCommandOutput(
    createdAt: RetryImportJobCommandOutput._read_createdAt(json['createdAt']),
    duplicateCount: RetryImportJobCommandOutput._read_duplicateCount(
      json['duplicateCount'],
    ),
    id: json['id'] as String?,
    importedCount: RetryImportJobCommandOutput._read_importedCount(
      json['importedCount'],
    ),
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    rejectedCount: RetryImportJobCommandOutput._read_rejectedCount(
      json['rejectedCount'],
    ),
    sourceType: RetryImportJobCommandOutput._read_sourceType(
      json['sourceType'],
    ),
    status: RetryImportJobCommandOutput._read_status(json['status']),
    updatedAt: RetryImportJobCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$RetryImportJobCommandOutputToJson(
  RetryImportJobCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?RetryImportJobCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'duplicateCount': ?RetryImportJobCommandOutput._write_duplicateCount(
    instance.duplicateCount,
  ),
  'id': ?instance.id,
  'importedCount': ?RetryImportJobCommandOutput._write_importedCount(
    instance.importedCount,
  ),
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'rejectedCount': ?RetryImportJobCommandOutput._write_rejectedCount(
    instance.rejectedCount,
  ),
  'sourceType': ?RetryImportJobCommandOutput._write_sourceType(
    instance.sourceType,
  ),
  'status': ?RetryImportJobCommandOutput._write_status(instance.status),
  'updatedAt': ?RetryImportJobCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};

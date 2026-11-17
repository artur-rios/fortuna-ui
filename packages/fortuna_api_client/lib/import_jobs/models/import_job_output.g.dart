// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_job_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportJobOutput _$ImportJobOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'connectionId',
      'createdAt',
      'duplicateCount',
      'failureReason',
      'id',
      'importedCount',
      'periodEnd',
      'periodStart',
      'processedCount',
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
      'processedCount',
      'rejectedCount',
      'sourceType',
      'status',
      'updatedAt',
    ],
  );
  return ImportJobOutput(
    connectionId: !json.containsKey('connectionId')
        ? null
        : ImportJobOutput._read_connectionId(json['connectionId']),
    createdAt: ImportJobOutput._read_createdAt(json['createdAt']),
    duplicateCount: ImportJobOutput._read_duplicateCount(
      json['duplicateCount'],
    ),
    failureReason: !json.containsKey('failureReason')
        ? null
        : ImportJobOutput._read_failureReason(json['failureReason']),
    id: json['id'] as String?,
    importedCount: ImportJobOutput._read_importedCount(json['importedCount']),
    periodEnd: !json.containsKey('periodEnd')
        ? null
        : ImportJobOutput._read_periodEnd(json['periodEnd']),
    periodStart: !json.containsKey('periodStart')
        ? null
        : ImportJobOutput._read_periodStart(json['periodStart']),
    processedCount: ImportJobOutput._read_processedCount(
      json['processedCount'],
    ),
    rejectedCount: ImportJobOutput._read_rejectedCount(json['rejectedCount']),
    sourceType: ImportJobOutput._read_sourceType(json['sourceType']),
    status: ImportJobOutput._read_status(json['status']),
    updatedAt: ImportJobOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$ImportJobOutputToJson(ImportJobOutput instance) =>
    <String, dynamic>{
      if (instance.connectionId case final $value?)
        'connectionId': ImportJobOutput._write_connectionId($value),
      'createdAt': ?ImportJobOutput._write_createdAt(instance.createdAt),
      'duplicateCount': ?ImportJobOutput._write_duplicateCount(
        instance.duplicateCount,
      ),
      if (instance.failureReason case final $value?)
        'failureReason': ImportJobOutput._write_failureReason($value),
      'id': ?instance.id,
      'importedCount': ?ImportJobOutput._write_importedCount(
        instance.importedCount,
      ),
      if (instance.periodEnd case final $value?)
        'periodEnd': ImportJobOutput._write_periodEnd($value),
      if (instance.periodStart case final $value?)
        'periodStart': ImportJobOutput._write_periodStart($value),
      'processedCount': ?ImportJobOutput._write_processedCount(
        instance.processedCount,
      ),
      'rejectedCount': ?ImportJobOutput._write_rejectedCount(
        instance.rejectedCount,
      ),
      'sourceType': ?ImportJobOutput._write_sourceType(instance.sourceType),
      'status': ?ImportJobOutput._write_status(instance.status),
      'updatedAt': ?ImportJobOutput._write_updatedAt(instance.updatedAt),
    };

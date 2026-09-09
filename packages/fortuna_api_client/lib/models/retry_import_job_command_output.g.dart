// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry_import_job_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetryImportJobCommandOutput _$RetryImportJobCommandOutputFromJson(
  Map<String, dynamic> json,
) => RetryImportJobCommandOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  duplicateCount: (json['duplicateCount'] as num?)?.toInt(),
  id: json['id'] as String?,
  importedCount: (json['importedCount'] as num?)?.toInt(),
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
  rejectedCount: (json['rejectedCount'] as num?)?.toInt(),
  sourceType: json['sourceType'] == null
      ? null
      : TransactionSourceType.fromJson((json['sourceType'] as num).toInt()),
  status: json['status'] == null
      ? null
      : ImportJobStatus.fromJson((json['status'] as num).toInt()),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RetryImportJobCommandOutputToJson(
  RetryImportJobCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'duplicateCount': instance.duplicateCount,
  'id': instance.id,
  'importedCount': instance.importedCount,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'rejectedCount': instance.rejectedCount,
  'sourceType': instance.sourceType,
  'status': instance.status,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

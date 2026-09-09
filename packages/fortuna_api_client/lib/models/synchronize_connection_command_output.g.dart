// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeConnectionCommandOutput _$SynchronizeConnectionCommandOutputFromJson(
  Map<String, dynamic> json,
) => SynchronizeConnectionCommandOutput(
  importJobId: json['importJobId'] as String?,
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
  status: json['status'] == null
      ? null
      : ImportJobStatus.fromJson((json['status'] as num).toInt()),
);

Map<String, dynamic> _$SynchronizeConnectionCommandOutputToJson(
  SynchronizeConnectionCommandOutput instance,
) => <String, dynamic>{
  'importJobId': instance.importJobId,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'status': instance.status,
};

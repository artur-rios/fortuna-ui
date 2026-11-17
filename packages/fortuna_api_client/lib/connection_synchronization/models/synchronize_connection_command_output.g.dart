// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeConnectionCommandOutput _$SynchronizeConnectionCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['importJobId', 'periodEnd', 'periodStart', 'status'],
    disallowNullValues: const ['importJobId', 'status'],
  );
  return SynchronizeConnectionCommandOutput(
    importJobId: json['importJobId'] as String?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    status: SynchronizeConnectionCommandOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$SynchronizeConnectionCommandOutputToJson(
  SynchronizeConnectionCommandOutput instance,
) => <String, dynamic>{
  'importJobId': ?instance.importJobId,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'status': ?SynchronizeConnectionCommandOutput._write_status(instance.status),
};

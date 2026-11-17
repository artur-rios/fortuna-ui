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
    periodEnd: !json.containsKey('periodEnd')
        ? null
        : SynchronizeConnectionCommandOutput._read_periodEnd(json['periodEnd']),
    periodStart: !json.containsKey('periodStart')
        ? null
        : SynchronizeConnectionCommandOutput._read_periodStart(
            json['periodStart'],
          ),
    status: SynchronizeConnectionCommandOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$SynchronizeConnectionCommandOutputToJson(
  SynchronizeConnectionCommandOutput instance,
) => <String, dynamic>{
  'importJobId': ?instance.importJobId,
  if (instance.periodEnd case final $value?)
    'periodEnd': SynchronizeConnectionCommandOutput._write_periodEnd($value),
  if (instance.periodStart case final $value?)
    'periodStart': SynchronizeConnectionCommandOutput._write_periodStart(
      $value,
    ),
  'status': ?SynchronizeConnectionCommandOutput._write_status(instance.status),
};
